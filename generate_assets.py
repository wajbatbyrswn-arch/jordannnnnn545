import urllib.request
import wave
import struct
import math
import os

os.makedirs('assets/images', exist_ok=True)
os.makedirs('assets/sounds', exist_ok=True)

images = {
    'petra.jpg': 'https://placehold.co/600x400/E57373/FFFFFF/png?text=Petra',
    'deadsea.jpg': 'https://placehold.co/600x400/64B5F6/FFFFFF/png?text=Dead+Sea',
    'wadi_rum.jpg': 'https://placehold.co/600x400/FFB74D/FFFFFF/png?text=Wadi+Rum',
    'jerash.jpg': 'https://placehold.co/600x400/81C784/FFFFFF/png?text=Jerash',
    'aqaba.jpg': 'https://placehold.co/600x400/4FC3F7/FFFFFF/png?text=Aqaba'
}

req_headers = {'User-Agent': 'Mozilla/5.0'}

for name, url in images.items():
    if os.path.exists(f'assets/images/{name}') and os.path.getsize(f'assets/images/{name}') > 0:
        continue
    try:
        req = urllib.request.Request(url, headers=req_headers)
        with urllib.request.urlopen(req) as response, open(f'assets/images/{name}', 'wb') as out_file:
            data = response.read()
            out_file.write(data)
        print(f"Downloaded {name}")
    except Exception as e:
        print(f"Failed to download {name}: {e}")

def generate_tone(filename, freqs, duration, volume=0.5, type='sine'):
    sample_rate = 44100
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        
        num_samples = int(sample_rate * duration)
        freq_len = len(freqs)
        
        for i in range(num_samples):
            t = float(i) / sample_rate
            chunk_idx = int((float(i) / num_samples) * freq_len)
            freq = freqs[chunk_idx]
            
            if type == 'sine':
                value = math.sin(2.0 * math.pi * freq * t)
            elif type == 'square':
                value = 1.0 if math.sin(2.0 * math.pi * freq * t) > 0 else -1.0
            
            samples_per_chunk = num_samples / freq_len
            idx_in_chunk = i % samples_per_chunk
            envelope = 1.0 - (idx_in_chunk / samples_per_chunk)
            
            if i > num_samples * 0.9:
                envelope *= (num_samples - i) / (num_samples * 0.1)
                
            packed_value = struct.pack('h', int(value * envelope * volume * 32767.0))
            wav_file.writeframes(packed_value)

generate_tone('assets/sounds/click.wav', [1200], 0.05, 0.5, 'sine')
generate_tone('assets/sounds/correct.wav', [600, 800], 0.3, 0.4, 'sine')
generate_tone('assets/sounds/wrong.wav', [250, 200], 0.4, 0.2, 'square')
generate_tone('assets/sounds/win.wav', [440, 554, 659, 880], 0.6, 0.5, 'sine')
print("Sounds generated!")
