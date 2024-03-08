import const.path as path
import concurrent.futures

import script.spectrum as spectrum
import script.transparency as transparency

from script.func import get_files

if __name__ == "__main__":
	
	""" audio_files = get_files(path.sonvs, '.wav')
	for audio_file in audio_files:
		spectrum.make(audio_file) """

	audio_files = get_files(path.sonvs, '.wav')
	with concurrent.futures.ProcessPoolExecutor() as executor:
		executor.map(spectrum.make, audio_files)
  
""" 	pic_files = get_files(path.pics, '.png')
	with concurrent.futures.ProcessPoolExecutor() as executor:
		executor.map(transparency.make, pic_files) """
