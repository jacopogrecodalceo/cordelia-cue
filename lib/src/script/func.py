import os

def get_files(dir, extension):
	# List all files in the directory
	files = os.listdir(dir)

	# Filter files that end with '.orc'
	filtered_files = sorted([file for file in files if file.endswith(extension)], key=lambda x: x.lower())

	processed_files = []
	for file in filtered_files:
		processed_files.append(os.path.join(dir, file))
  
	return processed_files

def get_info(file):
	directory = os.path.dirname(file)
	name = os.path.splitext(os.path.basename(file))
	basename = name[0]
	extension = name[1]
	return directory, basename, extension

def create_dir(main_dir, name):
	path = os.path.join(main_dir, name)

	if os.path.exists(path):
		user_input = input(f"The directory '{path}' exists. Do you want to remove it and its contents? (y/n): ").strip().lower()
		if user_input == 'y':
			try:
				os.rmdir(path)
				print(f"Removed existing directory: {path}")
			except OSError:
				import shutil
				# Directory is not empty, use shutil.rmtree to remove it
				shutil.rmtree(path)
				print(f"Removed existing directory and its contents: {path}")
				os.mkdir(path)
		else:
			print(f"Directory '{path}' was not removed.")
	else:
		print(f"Directory '{path}' does not exist.")
		os.mkdir(path)
		# Create the directory
	print(f"Created directory: {path}")
	return path

def seconds_to_mmss(seconds):
    minutes, seconds = divmod(int(seconds), 60)
    return f"{minutes:02d}:{seconds:02d}"
