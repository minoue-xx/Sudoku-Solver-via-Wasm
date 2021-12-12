% Copyright (c) 2021 Michio Inoue
function out = digitPredictFcn_CNN(XX) %#codegen

assert(isa(XX, 'double'));
assert(all( size(XX) == [56*56,1]));

persistent mynet;

if isempty(mynet)
    mynet = coder.loadDeepLearningNetwork('./trainCNN/digitPredictModel.mat');
end

XX = reshape(XX,[56,56]);
out = double(predict(mynet,XX));