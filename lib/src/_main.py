import queue
import time

from threading import Thread

import udp

from csound import cs, handle_input

message_queue = queue.Queue()

def process_messages():
	while True:
		code = message_queue.get()
		print('='*32)
		print('RECEIVED CODE:')
		print(code)
		cs_lines = '\n'.join(handle_input(code))
		print('='*32)
		print('COMPILED ORC:')
		print(cs_lines)
		print('='*32)
		cs.compileOrcAsync(cs_lines)
		time.sleep(.015)  # Adjust delay time as needed

def csound_perf_homemade(cs):	
	cs.start()
	cs.perform()
	cs.cleanup()
	cs.reset()

def main():
	udp.open_ports()

	# Create and start the thread for listening to messages
	threads = [
		Thread(target=process_messages, daemon=True), 
		Thread(target=udp.listen, daemon=True, args=(message_queue,)),
		Thread(target=csound_perf_homemade, args=(cs,))]

	# Process the received messages in the main thread
	for t in threads:
		t.start()

if __name__ == "__main__":
	main()