import const.path as path
import func

def make():
	wav_files = func.get_files(path.sonvs, '.wav')

	with open(path.abstract, 'w') as file:
		for f in wav_files:
			_, basename, _ = func.get_info(f)
			file.write(basename + '\n')
	