% Copyright (c) 2021 Michio Inoue
% This script generates 56x56 images of each digit using all the available
% font in MATLAB. The generated image is going to be used for traning CNN to
% classify digits. The images will be saved in ./digitsData/(digits)

%% Folder setup
folderName = "digitsData";
if ~exist(folderName,'dir')
    mkdir(folderName);
    for ii=0:9
        mkdir(fullfile(folderName,string(ii)));
    end
end

%% Figure setting
% Close all the existing figures
close all
h_fig = figure(1);
% set(1,'visible','off');
% Set the size of the figure (to fix aspect ratio)
h_fig.Units = 'pixels';
h_fig.Position = [100,100,120,120];

% Set the size of axes to fit to figure
h_axes = gca;
h_axes.Units = 'normalized';
h_axes.Position = [0,0,1,1];
axis([0 1 0 1]);
axis ij % Note: places the origin at the upper left corner of the axes
axis off 

%% Generate images of digits
% Places texts on axes and save it as image.

d = listfonts; % list of available font names
DotPerInch = get(h_fig,'screenPixelsPerInch'); % Resolution in dots per inch (DPI)
for ii=1:length(d)
    for k = 1:10

        % place text on axes (at center)
        h_text = text(0.5,0.5,num2str(k-1), ...
            HorizontalAlignment='center',...
            FontSize=50,...
            FontName=d{ii});

        % save it as image
        print('-dpng','testimage.png',['-r' num2str(DotPerInch)]);

        % generate binary image and set the size
        I = im2gray(imread('testimage.png'));
        I = ~imbinarize(I,0.5);
        I = imresize(I,[56,56]);

        % save
        filename = fullfile(folderName,string(k-1),string(d{ii})+".jpg");
        imwrite(I,filename) 
        delete(h_text)
    end
end

