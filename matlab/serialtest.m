clear all
close all
instrreset;

% Test Type:
% 0 -- Random MNIST image
% 1 -- 512x512 test image
testType = 0;

% Image Name
imgName = 'standard_test_images/livingroom.tif';

% Initialize Variables
baudRate = 115200;

% Read data
if testType == 0
    images = loadMNISTImages('handwriting-images');
    [numBytes, numImages] = size(images);
    imageIndex = randi(numImages);

    % Get a random image and convert range to 0-255 (8 bits)
    dim = sqrt(numBytes);
    A = 255 - round(255*reshape(images(:,imageIndex),dim,dim));
elseif testType == 1
    A = imread(imgName);
    A = A(:,:,1);
end

[height,width] = size(A);

% Set Up Serial Port
s = serial('com1','BaudRate',baudRate);
s.OutputBufferSize = height;
s.InputBufferSize = height;


% Send Image to FPGA
fopen(s);
S = zeros(height,width);
for i = 1:width
    fwrite(s, A(:,i));
    S(:,i) = fread(s, height);
end

% Close Serial Port
fclose(s);

% Plot Results
figure
subplot(1,2,1)
imshow(A, [0 255])
title('Image Sent to FPGA')

subplot(1,2,2)
imshow(S, [0 255])
title('Image Received from FPGA')

% Automatically Close figure
%pause(2)
%close all
