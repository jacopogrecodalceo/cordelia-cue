from wand.image import Image, Color
import numpy as np

def make(input_file):
	with Image(filename=input_file) as img:
		fuzz = 0.15
		img.transparent_color(Color('white'), 0, fuzz=int(np.iinfo(np.uint16).max * fuzz))
		img.save(filename=input_file)
