import os
import json
import sox

import const.path as path

from script.func import *

def make():

	json_data = {}
	corydill_file = get_files(path.main, '.corll')
 
	with open(corydill_file[0], 'r') as f:
		for line in f.readlines():
			if line.startswith('start:'):
				# Find the index of the first double quote
				start_index = line.find('"')

				# Find the index of the second double quote, starting from the position after the first double quote
				end_index = line.find('"', start_index + 1)

				# Extract the text between the double quotes
				basename = line[start_index + 1:end_index]					
    
				audio_file = os.path.join(path.sonvs, f'{basename}.wav')    
				pic_file = os.path.join(path.pics, f'{basename}.png')

				json_data[basename] = {
					'audio_path': audio_file if os.path.exists(audio_file) else ValueError("Audio does not exist"),
					'pic_path': pic_file if os.path.exists(pic_file) else ValueError("Picture does not exist"),
					'duration': seconds_to_mmss(sox.file_info.duration(audio_file))
					}

	with open(path.json, 'w') as f:
		json.dump(json_data, f, indent=4)
