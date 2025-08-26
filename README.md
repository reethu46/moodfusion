MoodFusion 🎙️📷

MoodFusion is a multimodal emotion detection system** that combines speech (audio) and facial expressions (video) to classify human emotions such as Happy, Sad, Angry, and Neutral.  
Developed in MATLAB using audio signal processing and computer vision techniques.

---

 ⚡ Features
- 🎤 Speech-based emotion detection using:
  - Energy (signal strength)
  - Pitch estimation (autocorrelation)
- 📷 Facial emotion detection using:
  - Face detection (Viola–Jones algorithm)
  - Mouth region analysis (smile detection via edge density)
- 🔗 Fusion model:
  - Combines both voice + face for more robust emotion detection
- 📊Visualization:
  - Recorded audio waveform
  - FFT Spectrum
  - Energy & Pitch bar graph
  - Captured image, detected face & mouth region
  - Final detected emotion displayed clearly

---

 🛠️ Tech Stack
- MATLAB (Signal Processing + Computer Vision Toolbox)
- Audio Recording (`audiorecorder`)
- Face Detection (`vision.CascadeObjectDetector`)
- Fusion Rules for multimodal decision-making

---
📦 Installation
1. Install **MATLAB R2021a or later**  
2. Install required Toolboxes:  
   - Signal Processing Toolbox  
   - Computer Vision Toolbox
--- 
🚀 How to Run

Open MATLAB 
Run the main script:
emotiondetection6.m
Record audio + capture face
View results with emotion visualization

📷 Example Output

Audio waveform with pitch & energy plot
Detected face + mouth region
Final detected emotion displayed





