import os, subprocess, json

import const.path as path

def make():

	main_title = os.path.basename(path.main)

	with open(path.json, 'r') as f:
		# Load JSON data from the file
		data = json.load(f)
  
	temp_tex = os.path.join(path.data, 'temp.tex')
	with open(path.default_tex, 'r') as def_f:
		text = def_f.read()
		replaced_text = text.replace('---TITLE---', main_title).replace('---PIC---', os.path.join(path.data, 'pic.png'))
		with open(temp_tex, 'w') as f:
			f.write(replaced_text)

			for basename, item in data.items():
				latex_insert = [
					r'\centering',
					r'\vspace*{\fill}',
					rf'\verb+{basename}+\\',
					rf'\verb+{item["duration"]}+\\'
					r'%\vspace*{.025\baselineskip}',
					r'\begin{figure}[h]',
					r'\centering',
					r'\includegraphics[width=\textwidth, height=11cm]{' + item['pic_path'] + '}',
					r'\end{figure}',
					r'\vfill',
					r'\pagebreak'
				]

				f.write('\n'.join(latex_insert))
				f.write('\n%---\n\n\n')

			end_line = r'\end{document}'
			f.write(end_line)

		subprocess.run(['pdflatex', f'-output-directory={path.main}', temp_tex])
		os.rename(os.path.join(path.main, 'temp.pdf'), os.path.join(path.main, f'{main_title}.pdf'))

		#remove file
		#exts = ['tex', 'aux', 'log']
		#for e in exts:
		#	os.remove(os.path.join(src_dir, f'temp.{e}'))