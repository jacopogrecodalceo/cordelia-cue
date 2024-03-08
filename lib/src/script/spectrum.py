from wand.image import Image, Color
import numpy as np
import matplotlib
matplotlib.use('TkAgg')  # Use a non-GUI backend
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import librosa
import random
import subprocess

import const.path as path
from .func import *

EXPORT_FORMAT = 'png'
CUSTOM_CMAPs = [
	'RdPu',
	'PuRd',
	'BuPu',
	'PuBu',
	]

width = 16*256
height = 9*256

""" def plot_spectrogram(channel, args):
	y, n_fft, hop_length = args
	D = librosa.stft(y[channel], n_fft=n_fft, hop_length=hop_length)
	S_db = librosa.amplitude_to_db(np.abs(D), ref=np.max)
	return S_db """

def format_frequency(freq):
	freq = int(freq)
	if freq > 1000:
		return f"{freq / 1000:.1f}kHz"
	else:
		return f"{freq}Hz"

def format_time(duration):
	if duration < 2.5:
		return 1/4
	elif duration < 5:
		return 1/2
	elif duration < 45:
		return 1
	elif duration < 120:
		return 5
	elif duration > 120:
		return 15
	elif duration > 240:
		return 30

def process_plot_spectrum(input):
	_, basename, _ = get_info(input)
	output = os.path.join(path.pics, f'{basename}.png') 
 
	y, sr = librosa.load(input, mono=False, sr=None)
	duration = len(y) / sr

	channels = y.shape[0]

	n_fft = 8192
	hop_length = n_fft // 8


	#result is 3149 × 1773
	#width = width + width - 3149
	#height = height + height - 1773
	#dpi = width / (height / 25.4)
	dpi = 300

	custom_cmap = random.choice(CUSTOM_CMAPs)

	spectrograms = []
	for channel in range(channels):
		#y, n_fft, hop_length = args
		D = librosa.stft(y[channel], n_fft=n_fft, hop_length=hop_length)
		S_db = librosa.amplitude_to_db(np.abs(D), top_db=120, ref=np.max)
		#args = (y, n_fft, hop_length)
		#spectrograms = list(executor.map(lambda channel: plot_spectrogram(channel, args), range(channels)))
		#y_harm, y_perc = librosa.effects.hpss(y[channel])
		spectrograms.append(S_db)

	fig, ax = plt.subplots(nrows=channels, dpi=dpi, figsize=(width // dpi, height // dpi), sharex=True)
	plt.subplots_adjust(hspace=0)

	linewidth = .25
	# Generate logarithmically spaced array of frequencies
	num_freqs = 11  # Number of frequency points
	min_freq = 20  # Minimum frequency in Hz
	max_freq = sr / 2  # Maximum frequency (Nyquist frequency)
	log_freqs = np.logspace(np.log10(min_freq), np.log10(max_freq), num=num_freqs)

	for channel, S_db in enumerate(spectrograms):
		#print(S_db)

		librosa.display.specshow(S_db,
						x_axis='time',
						y_axis='log',
						ax=ax[channel],
						n_fft=n_fft,
						hop_length=hop_length,
						sr=sr,
						cmap=plt.get_cmap(custom_cmap)
						)

		ax[channel].xaxis.set_major_locator(ticker.MultipleLocator(base=format_time(duration)))  # Show major ticks every second
		ax[channel].grid(True, which='major', axis='x', linewidth=linewidth, color='black')  # Add gridlines

		ax[channel].tick_params(axis='both', which='major', labelsize=7, labelfontfamily='Andale Mono', width=linewidth)
		ax[channel].set_xlabel('')
		ax[channel].set_ylabel(f'{channel+1}ch')
		#librosa.display.waveshow(y_harm, sr=sr, ax=ax[channel], color='b')
		#librosa.display.waveshow(y_perc, sr=sr, ax=ax[channel], color='w')
		# Customize the tick labels to add 's' for seconds
		""" def format_ticks(x, pos):
			return f"{int(x)}s"
		
		ax[channel].xaxis.set_major_formatter(ticker.FuncFormatter(format_ticks)) """


		ax[channel].set_yticks(log_freqs[:-1])  # Set y-axis ticks as logarithmically spaced frequencies
		ax[channel].set_yticklabels([format_frequency(freq) for freq in log_freqs[:-1]], fontsize=3.5)  # Set y-axis tick labels

		#ax[channel].set_ylim([0, sr / 2])  # Adjust the y-axis limit to the Nyquist frequency
		ax[channel].xaxis.set_minor_locator(plt.NullLocator())
		ax[channel].yaxis.set_minor_locator(plt.NullLocator())

		# Remove outside borders
		ax[channel].spines['top'].set_visible(False)
		ax[channel].spines['right'].set_visible(False)
		ax[channel].spines['bottom'].set_visible(False)
		ax[channel].spines['left'].set_visible(False)

		line_x_adjust = 1/2048  # Adjust the horizontal position of the line
		if channel < channels-1:
			plt.axhline(y=log_freqs[-1], color='black', linewidth=linewidth, xmin=line_x_adjust, xmax=1-line_x_adjust)  # Adjust the y-coordinate as needed

		#ax[channel].set_axis_off()

	fig.savefig(output, dpi=dpi, bbox_inches='tight', pad_inches=1/8, format=EXPORT_FORMAT)
	plt.close(fig)
	return output

def make(input, transparency=True, grain=True, correction=True):

	output = process_plot_spectrum(input)

	if correction:
		with Image(filename=output) as img:
			# Apply image enhancement techniques here
			img.sharpen(radius=1, sigma=0.95)
			img.level(black=0.125, white=0.925, gamma=1.0)
			img.blur(radius=1, sigma=0.85)

			# Save the enhanced image
			img.save(filename=output)

	if grain:
		command = f'/Users/j/Documents/zsh/filmgrain "{output}" "{output}"'
		subprocess.run(command, shell=True)

	if transparency:
		with Image(filename=output) as img:
			fuzz = .105
			img.transparent_color(Color('white'), 0, fuzz=int(np.iinfo(np.uint16).max * fuzz))
			img.trim()
			img.save(filename=output)


