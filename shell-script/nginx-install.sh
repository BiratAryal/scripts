#!/bin/bash
yum install -y epel-release;
yum groupinstall -y 'Development Tools';
wget https://nginx.org/download/nginx-1.20.0.tar.gz && tar zxvf nginx-1.20.0.tar.gz;
wget https://ftp.exim.org/pub/pcre/pcre-8.42.tar.gz && tar xzvf pcre-8.42.tar.gz;
wget https://zlib.net/fossils/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz;
wget https://www.openssl.org/source/openssl-1.1.1a.tar.gz && tar xzvf openssl-1.1.1a.tar.gz;
yum install -y perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel libxml2 libxml2-devel gd gd-devel GeoIP GeoIP-devel ;
git clone https://github.com/openresty/headers-more-nginx-module.git;
rm -rvf *.tar.gz;
cd ~/nginx-1.20.0;
cp ~/nginx-1.20.0/man/nginx.8 /usr/share/man/man8;
gzip /usr/share/man/man8/nginx.8;
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
--with-http_perl_module=dynamic \ 
--with-perl_modules_path=/usr/lib64/perl5 \ 
--with-perl=/usr/bin/perl \ 
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
-with-stream_ssl_preread_module \ 
--with-compat \ 
--with-pcre=../pcre-8.42 \ 
--with-pcre-jit \ 
--with-zlib=../zlib-1.2.11 \ 
--with-openssl=../openssl-1.1.1a \ 
--with-openssl-opt=no-nextprotoneg \ 
--with-debug;

make;
make install;
ln -s /usr/lib64/nginx/modules /etc/nginx/modules;
useradd --system --home /var/cache/nginx --shell /sbin/nologin --comment "nginx user" --user-group nginx;
mkdir -p /var/cache/nginx;
