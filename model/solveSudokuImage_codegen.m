% Copyright (c) 2021 Michio Inoue
function Imask = solveSudokuImage_codegen(Icam)
%% Read In a File
% check the function with the pre-recorded image
% Icam = imread('photoEx4.jpg');
% In C-code gen mode
% s = coder.load("sampleImage.mat","Icam");
% Icam = s.Icam;
% Icam = imresize(Icam,[1000,1000]);
%
N = 750;
Icam = reshape(Icam,[3,N,N]);
Icam = permute(Icam,[3,2,1]);

%% Convert to gray image
Ibw = rgb2gray(Icam); % codegen ok

%% Convert to Black and White / ２値化処理
Ibw = ~imbinarize(Ibw,'adaptive', ...
    'ForegroundPolarity','dark', ...
    'Sensitivity',0.4); % codegen ok

%% Remove Noise / ノイズ除去
thNoise = numel(Ibw)*0.0001; % 0.01%
Ibw = bwareaopen(Ibw,floor(thNoise)); % code gen ok

%% Clear the border / 外とつながっている部分を除去
Ibw = imclearborder(Ibw); % code gen ok

%% Find the largest box / 一番大きい枠を探す
R = regionprops(Ibw,'Area','BoundingBox','PixelList');
% code gen ok

areaMax = 0;
kmax = 0;
for ii=1:length(R)
    if areaMax < R(ii).Area
        areaMax = R(ii).Area;
        kmax = ii;
    end
end

tmpR = R(kmax);
tmp = tmpR.PixelList;
DIAG1 = sum(tmp,2);
DIAG2 = diff(tmp,[],2);

[~,dUL] = min(DIAG1);    [~,dDR] = max(DIAG1);
[~,dDL] = min(DIAG2);    [~,dUR] = max(DIAG2);

pts = tmpR.PixelList([dUL dDL dDR dUR dUL],:);

% no error till here
% %%

fixedPoints = [1 1; 9 1; 9 9; 1 9]/10.*size(Ibw);
movingPoints = pts(1:4,:);
boxarea = polyarea(movingPoints(:,1),movingPoints(:,2));

if boxarea/(1e6) < 0.1
    tmp = cat(3,Icam,zeros(N,N,1,'uint8'));
    tmp = permute(tmp,[3,2,1]);
    Imask = tmp(:);
    return
else
    transformationType = "projective";
    tform = fitgeotrans(movingPoints,fixedPoints, ...
        transformationType); % code gen ok % error occurs here for bad images
end
Ibw_warp = imwarp(Ibw,tform); % code gen ok
Icam_warp = imwarp(Icam,tform); % code gen ok

%% Find the largest box / 再度一番大きい枠を探す
R = regionprops(Ibw_warp,'Area','BoundingBox','PixelList');
% code gen ok

areaMax = 0;
kmax = 0;
for ii=1:length(R)
    if areaMax < R(ii).Area
        areaMax = R(ii).Area;
        kmax = ii;
    end
end

tmpR = R(kmax);
tmp = tmpR.PixelList;
DIAG1 = sum(tmp,2);
DIAG2 = diff(tmp,[],2);

[~,dUL] = min(DIAG1);    [~,dDR] = max(DIAG1);
[~,dDL] = min(DIAG2);    [~,dUR] = max(DIAG2);

pts = tmpR.PixelList([dUL dDL dDR dUR dUL],:);

%% Only keep elements in the boxes / ますに入っている要素のみキープ
% code gen ok
data = cell(9,9);
xx = linspace(pts(1,1),pts(2,1),10);
yy = linspace(pts(2,2),pts(3,2),10);
for ii=1:9
    for jj=1:9
        tmp = imcrop(Ibw_warp,[xx(ii),yy(jj),...
            xx(ii+1)-xx(ii), yy(jj+1)-yy(jj)]); % code gen ok
        data{ii,jj} = imclearborder(tmp); % code gen ok
    end
end

% cellfun is not supported
sizes = zeros(81,1);
for ii=1:81
    sizes(ii) = sum(data{ii},'all');
end
% sizes = cellfun(@(x) sum(x,'all'),data(:));
medianSize = median(sizes(sizes>0));

%%
% code gen ok
digits = zeros(81,1);
for ii=1:81
    image = data{ii};

    if sum(image,'all') < medianSize/10
        digits(ii) = 0;
    else
        image = imresize(image,[56,56]);
        E = regionprops(image,'Centroid');
        Tx = 28-E(1).Centroid(1);
        Ty = 28-E(1).Centroid(2);
        image = imtranslate(image,[Tx Ty]);

        out = digitPredictFcn_CNN(double(image(:))*255);

        [~,cnnpred0] = max(out);

        image1 = imtranslate(image,[5 0]);
        out = digitPredictFcn_CNN(double(image1(:))*255);
        [~,cnnpred1] = max(out);

        image2 = imtranslate(image,[0 5]);
        out = digitPredictFcn_CNN(double(image2(:))*255);
        [~,cnnpred2] = max(out);

        image3 = imrotate(image,10,'crop');
        out = digitPredictFcn_CNN(double(image3(:))*255);
        [~,cnnpred3] = max(out);

        image4 = imrotate(image,-10,'crop');
        out = digitPredictFcn_CNN(double(image4(:))*255);
        [~,cnnpred4] = max(out);
        cnnpred = mode([cnnpred0,cnnpred1,cnnpred2,cnnpred3,cnnpred4]);
        digits(ii) = cnnpred-1;
    end
end

%% Calculate the Solution / ソリューションを計算する
% code gen ok
M = reshape(digits,[9,9])';
M_sol = Sudoku(M);

%% Generate an image from the solution / ソリューションから画像を作成
I = solution2image_codegen(M,M_sol);
%% Overlay the solution on the original image / 画像をオーバレイ

Iresize = imresize(~I,[pts(3,2)-pts(2,2),pts(2,1)-pts(1,1)]);
Imask = zeros(size(Icam_warp));
Imask(pts(2,2):pts(3,2)-1, pts(1,1):pts(2,1)-1,2) = Iresize;
Imask = Icam_warp .* uint8(~Imask);
Imask = imresize(Imask,[N,N]);

tmp = cat(3,Imask,zeros(N,N,1,'uint8'));
tmp = permute(tmp,[3,2,1]);
Imask = tmp(:);