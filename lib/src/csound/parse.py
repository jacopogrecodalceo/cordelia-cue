import re

import const.path as path
from script.func import get_files, get_info

sequenze_path = get_files(path.sonvs, '.wav')
SEQUENZE = []
for sequenza in sequenze_path:
	_, name, _ = get_info(sequenza)
	SEQUENZE.append(name)

# Define constants for better maintainability
START_PREFIX = 'start:'
END_PREFIX = 'end:'
COMMENT_PREFIX = ';'

def extract_keywords(keywords, line):
	"""
	Extracts keywords and their values from a line of text.
	""" 
	# Define regular expression pattern to match keyword-value pairs
	pattern = re.compile(r'(?P<keyword>\w+)=(?P<value>[^,]+)')
	matches = pattern.findall(line)
	for keyword, value in matches:
		keywords[keyword] = value.strip()
	
	return keywords

def start_line(line):
	"""
	Processes a 'start' line from the input code.
	"""

	#start: 101, "0a1-introduction-240211.wav", line=21
	line = line[len(START_PREFIX):].split(';')[0].strip()
	audio_file, *rest = map(str.strip, line.split(','))
		
	keywords = {
		'start_from': 0,
		'when': 0,
		'loop': 0,
		'dyn': 1,
		'fadein': 0,
		'fadein_mode': 0,
		'fadeout': .005,
		'fadeout_mode': 0
	}
 
	keywords = extract_keywords(keywords, ','.join(rest))

	audio_no_quotes = audio_file.replace('"', '')
	try:
		audio_index = SEQUENZE.index(audio_no_quotes)

		cs_code = rf'''schedule "start_seq", 0, 0,	{audio_index}, "{audio_no_quotes}.wav",\
{keywords["when"]},				\;DELAY STARTING SEQ
{keywords["start_from"]},		\;START SEQ FROM
{keywords["loop"]},				\;IS LOOP
{keywords["dyn"]},				\;DYN
{keywords["fadein"]},	{keywords["fadein_mode"]},	\;FADEIN <sec> <mode>
{keywords["fadeout"]},	{keywords["fadeout_mode"]}	 ;FADEOUT <sec> <mode>'''

		return cs_code
	except:
		warning = rf'''prints "{'='*32}\\n"
prints "Cannot find {audio_no_quotes}!\\n"
prints "{'='*32}\\n"'''
		return warning

def end_line(line):
	"""
	Processes an 'end' line from the input code.
	"""

	line = line[len(END_PREFIX):].split(';')[0].strip()
	audio_file, *rest = map(str.strip, line.split(','))

	keywords = {
		'when': 0,
	}
	keywords = extract_keywords(keywords, ','.join(rest))

	audio_no_quotes = audio_file.replace('"', '')
	try:
		audio_index = SEQUENZE.index(audio_no_quotes)
		cs_code = rf'schedule "end_seq", 0, 0,	{audio_index}, {keywords["when"]}'

		return cs_code
	except:
		warning = rf'''prints "{'='*32}\\n"
prints "Cannot find {audio_no_quotes}!\\n"
prints "{'='*32}\\n"'''
		return warning


def handle_input(code):
	filtered_lines = [line for line in code.splitlines() if not line.startswith(';') and line]
	processed_lines = []
	for line in filtered_lines:
		if line.startswith('start:'):
			processed_lines.append(start_line(line))
		elif line.startswith('end:'):
			processed_lines.append(end_line(line))
		else:
			processed_lines.append(line.split(', line=')[0])

	return processed_lines
