imagePath = 'E:/Calibrations/fwdcam/';
boardsSize = [9 6];

% Create a set of calibration images.
images = imageDatastore(imagePath);
%%
% Detect calibration pattern.
[imagePoints,boardSize] = detectCheckerboardPoints(images.Files);
%%
% Generate world coordinates of the corners of the squares. Square size is
% in millimeters.
squareSize = 29;
worldPoints = generateCheckerboardPoints(boardSize,squareSize);
%%
% Calibrate the camera.
I = readimage(images,1); 
imageSize = [size(I, 1), size(I, 2)];
cameraParams = estimateCameraParameters(imagePoints,worldPoints, ...
                                  'ImageSize',imageSize);
%%
% Remove lens distortion and display results.
I = images.readimage(1);
J1 = undistortImage(I,cameraParams);
%%
figure; imshowpair(I,J1,'montage');
title('Original Image (left) vs. Corrected Image (right)');
%%
J2 = undistortImage(I,cameraParams,'OutputView','full');
figure; 
imshow(J2);
title('Full Output View');
