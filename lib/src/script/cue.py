import os
import func

import const.path as path

SYMBOL_CUE = ';---'

INFO_CUE = '''; KEYWORDs:
; start_from: <int sec>
; when: <int sec>
; loop: <boolean 0 or 1>
; dyn: <float 0, 1>
; fade[in - out]: <int sec>, fade[in - out]_mode

'''

END_CUE = rf'''
{SYMBOL_CUE}RECORD OFF & CLOSE
event_i "e", 0, 1
{SYMBOL_CUE}ENDLIST

; turnoff_i:
; (0) all instances,
; (1) oldest only,
; (2) or newest only,
; (4) notes with fractional instrument'''

def make():

	main_title = os.path.basename(path.main)
	sonvs_files = func.get_files(path.sonvs, '.wav')

	score = []

	score.append(rf'''{SYMBOL_CUE}{main_title} info{SYMBOL_CUE[::-1]}
;{path.cue}
{INFO_CUE}
{SYMBOL_CUE}
gkrehearsal init 1 ; to remove ESC release'

{SYMBOL_CUE}RECORD ON
schedule "MNEMOSINE", 0, -1, "{main_title}.wav"

''')
	
	for i, file in enumerate(sonvs_files):
		score.append(SYMBOL_CUE)
		if i != 0:
			score.append(f'end: {i-1}')

		_, basename, extension = func.get_info(file)
		schedule_string = f'start: {i}, "{basename}{extension}"'

		score.append(schedule_string)
	
	score.append(END_CUE)

	with open(path.cue, 'w') as f:
		f.write('\n'.join(score))

