import socket
from IPy import IP

def scan(target):
	converted_ip = check_ip(target)
	print('\n'+'[Scanning targets]'+ str(target))
	for port in range(1, 82):
		scan_port(converted_ip, port)

def check_ip(ip):
	try:
		IP(ip)
		return(ip)
	except ValueError:
		return socket.gethostbyname(ip)
def get_banner(s):
	return s.recv(1024)
# defining funciton 
def scan_port(ipaddress,port):
	try:
		sock = socket.socket()
		# setting timeout will determine the accuracy of your port scanner
		sock.settimeout(0.5)
		sock.connect((ipaddress, port))
		try:
			banner = get_banner(sock)
			print ('[+] Open Port ' + str(port) + ' : ' + str(banner.decode().strip('\n')))
		except:
			print('[+]Open Port'+str(port))

	except:
		pass


targets = input ('[+] Enter Target/s To Scan (Split Multiple Targets with ,): ')
if ',' in targets:
	for ip_add in targets.split(','):
		scan(ip_add.strip(' '))
else:
	scan(targets)


