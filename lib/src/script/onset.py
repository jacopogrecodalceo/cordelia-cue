import librosa
import librosa.display
import numpy as np
import matplotlib.pyplot as plt

def find_nearest_values(arr1, arr2):
    """
    Find the nearest values in arr1 to the values in arr2 without repetition.

    Parameters:
    - arr1: NumPy array
    - arr2: NumPy array containing values to search for in arr1.

    Returns:
    - nearest_values: NumPy array of nearest values from arr1 to arr2 without repetition.
    """
    # Calculate absolute differences between all values in arr1 and arr2
    abs_diff = np.abs(arr1[:, np.newaxis] - arr2)

    # Find the index of the minimum absolute difference for each column
    nearest_indices = np.argmin(abs_diff, axis=0)

    # Get the nearest values from arr1 using the indices
    nearest_values = arr1[nearest_indices]

    # Remove duplicate values, if any
    nearest_values = np.unique(nearest_values)

    return nearest_values

# Load an audio file
audio_file = '/Users/j/Desktop/envol-t/sonvs/0-2-usine-03-usine{loop=1}.wav'
y, sr = librosa.load(audio_file)

def detect_onset(y, sr):
	o_env = librosa.onset.onset_strength(y=y, sr=sr)
	onset_times = librosa.times_like(o_env, sr=sr)
	onset_frames = librosa.onset.onset_detect(onset_envelope=o_env, sr=sr)
	return onset_times[onset_frames]

# Display the waveform and onsets
width = 1024
n_fft = 2048
height = width // (4)
dpi = width / (height / 25.4)
#fig.savefig(export_filename, dpi=dpi, bbox_inches='tight', pad_inches=0)
D = librosa.stft(y, n_fft=n_fft)
S_db = librosa.amplitude_to_db(np.abs(D), ref=np.max)
fig, ax = plt.subplots(dpi=dpi, figsize=(width // dpi, height // dpi), constrained_layout=True)  # Adjust the figsize for width and height
ax.set_axis_off()

librosa.display.specshow(S_db, x_axis='time', y_axis='log', ax=ax)

ax.vlines(find_nearest_values(detect_onset(y, sr), np.arange(0, width, 5, dtype=np.uint16)), 0, n_fft, color='w', alpha=1)
plt.show()