import ctcsound
import subprocess
import re
import os

import const.path as path

FLAGs = []
with open(path.flags, 'r') as file:
	for line in file:
		line = line.strip()
		if line and not line.startswith(';'):
			FLAGs.append(line)

def extract_rtaudio():
	for flag in FLAGs:
		match = '-+rtaudio='
		if flag.startswith(match):
			return flag[len(match):] if flag.startswith(match) else 'PortAudio'

# Get the list of devices and their details
def get_local_devices(rtaudio):
	output = subprocess.run(['csound', f'-+rtaudio={rtaudio}','--devices'], capture_output=True, text=True).stderr.strip()
	devices = re.findall(r'adc.*|dac.*', output, flags=re.MULTILINE)
	return devices

def is_device_in_csound(device, CSOUND_DEVICEs):
	if device and not device.startswith(';'):
		for csound_device in CSOUND_DEVICEs:
			if device in csound_device:
				return csound_device
	return False

def is_default(converter):
	options = []
	defaults_path = os.path.join(path.lib, '_default', converter)
	with open(defaults_path) as f:
		for converter_line in f.readlines():

			if converter_line and not converter_line.startswith(';'):
				converter_line = converter_line.strip().split('--')

				converter_device = converter_line[0]
				converter_options = converter_line[1:]

				for csound_device in CSOUND_DEVICEs:
					if converter_device in csound_device and converter in csound_device:
						match = re.match(fr'{converter}\d+', csound_device)[0]
						
						if converter_options:
							for option in converter_options:
								options.append(f'--{option}')
						options.append(f'-i{match}' if converter == 'adc' else f'-o{match}')
						return options if options else [f'-i{converter}'] if converter == 'adc' else [f'-o{converter}']

def query_devices():
	options = []
	for converter in ['adc', 'dac']:
		options.extend(is_default(converter))
	return options

rtaudio = extract_rtaudio()

CSOUND_DEVICEs = get_local_devices(rtaudio)
assert CSOUND_DEVICEs

#######################################
# INIT CSOUND OPTIONs
#######################################
ctcsound.csoundInitialize(ctcsound.CSOUNDINIT_NO_ATEXIT | ctcsound.CSOUNDINIT_NO_SIGNAL_HANDLER)
cs = ctcsound.Csound()

for option in FLAGs:
	cs.setOption(option)
	print(option)

for option in query_devices():
	cs.setOption(option)
	print(option)

#cs.compileOrc(ORC)
#cs.readScore('f0 z')

# List all files in the directory
files = os.listdir(path.cs)

# Filter files that end with '.orc'
orc_files = sorted([file for file in files if file.endswith('.orc')], key=lambda x: x.lower())
ORC = ';---\n'
# Print the filtered files
for orc_file in orc_files:
	with open(os.path.join(path.cs, orc_file), 'r') as content:
		ORC += content.read()

cs.compileOrc(ORC)

