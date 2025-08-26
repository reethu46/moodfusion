clc; clear; close all;

%% Step 1: Record Audio (3 sec)
recObj = audiorecorder(44100,16,1);
disp('🎙️ Start speaking...');
recordblocking(recObj,3);
disp('✅ Recording finished!');
y = getaudiodata(recObj);
fs = 44100;
audiowrite('sample.wav',y,fs);

%% Step 2: Preprocess
[y,fs] = audioread('sample.wav');
y = y(:,1);                 % mono
y = y / max(abs(y)+eps);    % normalization

%% Step 3: Silence Check
threshold = 0.005;   % silence energy threshold
signal_energy = sum(y.^2)/length(y);

if signal_energy < threshold
    disp('⚠️ No speech detected! Try to speak again 🎤');
    return;
end

%% Step 4: VOICE Emotion Detection
energy = sum(y.^2)/length(y);
pitchObj = pitch(y,fs);
avgPitch = mean(pitchObj);

if energy > 0.015 && avgPitch > 170
    voiceEmotion = 'Happy 😀';
elseif energy < 0.008 && avgPitch < 150
    voiceEmotion = 'Sad 😔';
else
    voiceEmotion = 'Angry 😡';
end

disp(['Voice Emotion: ',voiceEmotion]);

%% Step 5: FACE Emotion Detection
% Capture webcam frame
cam = webcam;
img = snapshot(cam);
clear cam;

faceDetector = vision.CascadeObjectDetector();
bbox = step(faceDetector,img);

faceEmotion = 'Unknown 😐';

if ~isempty(bbox)
    % pick largest face
    [~,bigIdx] = max(bbox(:,3).*bbox(:,4));
    face = imcrop(img,bbox(bigIdx,:));

    grayFace = imresize(rgb2gray(face),[48 48]);
    [h, w] = size(grayFace);

    % Mouth ROI
    y1 = round(0.60*h);
    h2 = round(0.35*h);
    mouthRegion = imcrop(grayFace,[1, y1, w, h2]);

    % Edge detection for smile
    mouthEdges = edge(mouthRegion,'Canny');
    smileStrength = nnz(mouthEdges)/numel(mouthEdges);

    if smileStrength > 0.05
        faceEmotion = 'Happy 😀';
    elseif smileStrength < 0.025
        faceEmotion = 'Sad 😔';
    else
        faceEmotion = 'Neutral 🙂';
    end
end

disp(['Face Emotion: ',faceEmotion]);

%% Step 6: Combined Decision
if strcmp(voiceEmotion,'Happy 😀') || strcmp(faceEmotion,'Happy 😀')
    finalEmotion = 'Happy 😀';
elseif strcmp(voiceEmotion,'Sad 😔') || strcmp(faceEmotion,'Sad 😔')
    finalEmotion = 'Sad 😔';
else
    finalEmotion = 'Angry 😡';
end

disp(['✅ Final Detected Emotion: ',finalEmotion]);

%% Step 7: Visualizations
figure;
subplot(3,2,1), plot(y), title('Recorded Speech Signal');
subplot(3,2,2), plot(abs(fft(y))), title('FFT Spectrum');
subplot(3,2,3), bar([energy avgPitch]), set(gca,'XTickLabel',{'Energy','Pitch'});
title('Extracted Voice Features');
subplot(3,2,4), imshow(img), title('Webcam Frame');
if exist('bbox','var') && ~isempty(bbox)
    hold on; rectangle('Position',bbox(bigIdx,:),'EdgeColor','g','LineWidth',2);
end
subplot(3,2,5), imshow(face), title(['Face → ',faceEmotion]);
if exist('mouthRegion','var')
    subplot(3,2,6), imshow(mouthRegion), title('Mouth ROI');
end
sgtitle(['Final Emotion: ',finalEmotion]);
