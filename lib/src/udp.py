import socket, select

UDP_PORTs = {
	11005: 'CORIDYLL'
}

UDP_SOCKETs = []
UDP_SIZE = 4096

empty = []

def open_ports():
	for port, name in UDP_PORTs.items():
		server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		server_socket.bind(('localhost', port))
		print(f'Port {name} open@{port}')
		UDP_SOCKETs.append(server_socket)

def receive() -> tuple():
	readable, writable, exceptional = select.select(UDP_SOCKETs, empty, empty)
	for s in readable:

		message, _address = s.recvfrom(UDP_SIZE)
		if not message:
			break

		# get where the message comes from
		_host, port = s.getsockname()
		#print(f"\n---I come from {direction}\n")
		# get UDP message

		return (message.decode())

def listen(message_queue):
	while True:
		code = receive()
		message_queue.put(code)
