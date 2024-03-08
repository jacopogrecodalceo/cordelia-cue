import os
from datetime import datetime

this_module = __file__
today = datetime.now().strftime("%y%m%d")

src = os.path.dirname(os.path.dirname(this_module))
lib = os.path.dirname(src)
cs = os.path.join(lib, '_csound')
main = os.path.dirname(lib)

flags = os.path.join(cs, '_flags')
data = os.path.join(lib, '_data')
sonvs = os.path.join(main, 'sonvs')
pics = os.path.join(main, 'pics')
json = os.path.join(data, 'this.json')
pdf = os.path.join(main, 'this.pdf')
default_tex = os.path.join(data, 'default.tex')

cue = os.path.join(main, f'{os.path.basename(main)}-{today}.corll')

abstract = os.path.join(main, 'abstract')

""" 

def is_string(var_name, var_value):
	if not var_name.startswith('__'):
		return type(var_name) == str and isinstance(var_value, str)

local_vars = locals()
for var_name, var_value in dict(local_vars).items():
	# Take only string and remove local_vars
	if is_string(var_name, var_value) and not var_name == 'local_vars':
		assert os.path.exists(var_value), f"{var_name}: {var_value} doesn't exist"
		print(f"{var_name} has this path: {var_value}")
		 """