#  Install "Development Tools" and Vim editor:
yum groupinstall -y 'Development Tools'
#  Install Extra Packages for Enterprise Linux (EPEL):
yum install -y epel-release vim wget tar net-tools
# • Download and install optional NGINX dependencies:
yum install -y perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel libxml2 libxml2-devel gd gd-devel GeoIP GeoIP-devel
# • Download the latest mainline version of NGINX source code and extract it:
wget https://nginx.org/download/nginx-1.20.0.tar.gz && tar zxvf nginx-1.20.0.tar.gz

# • Download third party module from git:
# got to home/tms directory then 
mkdir -p /home/tms
cd /
git clone https://github.com/openresty/headers-more-nginx-module.git
# • Download the NGINX dependencies source code and extract them:
# NGINX depends on 3 libraries: PCRE, zlib and OpenSSL:
# PCRE version 8.40
cd /
wget https://ftp.exim.org/pub/pcre/pcre-8.40.tar.gz && tar zxvf pcre-8.40.tar.gz

# zlib version 1.2.11
wget https://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz

# OpenSSL version 1.1.0f
wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz && tar xzvf openssl-1.1.0f.tar.gz

# • Remove all .tar.gz files. We dont need them anymore:
rm -rf *.tar.gz
# • Go to the NGINX source directory:
cd /nginx-1.20.0
# auto CHANGES CHANGES.ru conf configure contrib html LICENSE man README src
# • Copy NGINX manual page to /usr/share/man/man8:
cp /nginx-1.20.0/man/nginx.8 /usr/share/man/man8
gzip /usr/share/man/man8/nginx.8
# Check that Man page for NGINX is working
man nginx
# • Configure, compile, and install NGINX:
./configure --prefix=/etc/nginx \
            --sbin-path=/usr/sbin/nginx \
            --modules-path=/usr/lib64/nginx/modules \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --user=nginx \
            --group=nginx \
            --build=CentOS \
            --builddir=nginx-1.20.0 \
            --with-select_module \
            --with-poll_module \
            --with-threads \
            --with-file-aio \
            --with-http_ssl_module \
            --with-http_v2_module \
            --with-http_realip_module \
            --with-http_addition_module \
            --with-http_xslt_module=dynamic \
            --with-http_image_filter_module=dynamic \
            --with-http_geoip_module=dynamic \
            --with-http_sub_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_mp4_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_auth_request_module \
            --with-http_random_index_module \
            --with-http_secure_link_module \
            --with-http_degradation_module \
            --with-http_slice_module \
            --with-http_stub_status_module \
            --http-log-path=/var/log/nginx/access.log \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-mail=dynamic \
            --with-mail_ssl_module \
            --with-stream=dynamic \
            --with-stream_ssl_module \
            --with-stream_realip_module \
            --with-stream_geoip_module=dynamic \
            --with-stream_ssl_preread_module \
            --with-compat \
            --with-pcre=../pcre-8.40 \
            --with-pcre-jit \
            --with-zlib=../zlib-1.2.11 \
            --with-openssl=../openssl-1.1.0f \
            --with-openssl-opt=no-nextprotoneg \
            --with-debug \
	    --add-module=/home/tms/headers-more-nginx-module

# NOTE: Change the nginx version and –add-module directive as per the environment.
# • Make and install:
make;
make install

# • Symlink /usr/lib64/nginx/modules to /etc/nginx/modules directory, so that you can load dynamic modules in nginx configuration like this load_module modules/ngx_foo_module.so;:
ln -s /usr/lib64/nginx/modules /etc/nginx/modules

# • Print the NGINX version, compiler version, and configure script parameters:
nginx -V

# • Create the NGINX system user and group:
useradd --system --home /var/cache/nginx --shell /sbin/nologin --comment "nginx user" --user-group nginx

# • Check syntax and potential errors:
nginx -t

# ERROR 1:
# #If this error is thrown:
# nginx: [emerg] module "/usr/lib64/nginx/modules/ngx_http_perl_module.so" version 1016001 instead of 1020000 in /usr/share/nginx/modules/mod-http-perl.conf:1
# nginx: configuration file /etc/nginx/nginx.conf test failed
# # Goto /usr/share/nginx/modules/mod-http-perl.conf and delete this line:
# load_module "/usr/lib64/nginx/modules/ngx_http_perl_module.so";

# ERROR 2:
# # If this error is thrown:
# nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
# nginx: [emerg] mkdir() "/var/cache/nginx/client_temp" failed (2: No such file or directory)
# nginx: configuration file /etc/nginx/nginx.conf test failed
# Just create directory
# • Create a systemd unit file for nginx:
# vim /usr/lib/systemd/system/nginx.service

# • Copy/paste the following content:
# NOTE: The location of the PID file and the NGINX binary may be different depending on how NGINX was compiled.
# [Unit]
# Description=nginx - high performance web server
# Documentation=https://nginx.org/en/docs/
# After=network-online.target remote-fs.target nss-lookup.target
# Wants=network-online.target

# [Service]
# Type=forking
# PIDFile=/var/run/nginx.pid
# ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx.conf
# ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
# ExecReload=/bin/kill -s HUP $MAINPID
# ExecStop=/bin/kill -s TERM $MAINPID

# [Install]
# WantedBy=multi-user.target
# • Start and enable the NGINX service:
# systemctl start nginx.service && systemctl enable nginx.service

# • Check if NGINX will startup after a reboot:
# systemctl is-enabled nginx.service
# # enabled

# • Check if NGINX is running:
# systemctl status nginx.service
# ps aux | grep nginx
# curl -I 127.0.0.1

# echo "daemon off;" >> /etc/nginx/nginx.conf
``