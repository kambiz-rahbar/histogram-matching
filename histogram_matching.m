clc
clear
close all

%% 1. for original image
org_img = imread('original.jpg');
if size(org_img,3)>1
    org_img = rgb2gray(org_img);
end
[org_M, org_N] = size(org_img);
org_hist = imhist(org_img);
org_cdf = cumsum(org_hist) / (org_M*org_N);

%% 2. for reference image
ref_img = imread('reference.jpg');
if size(ref_img,3)>1
    ref_img = rgb2gray(ref_img);
end
[ref_M, ref_N] = size(ref_img);
ref_hist = imhist(ref_img);
ref_cdf = cumsum(ref_hist) / (ref_M*ref_N);

%% 3. calculate transfer function
T = zeros(256,1);
for k = 1:256
    b = org_cdf(k);
    [~, indx] = min(abs(b - ref_cdf));
    T(k) = indx-1;
end

%% 4. apply to original image
res_img = org_img;
for k = 0:255
    res_img(org_img==k) = T(k+1);
end
[res_M, res_N] = size(res_img);
res_hist = imhist(res_img);
res_cdf = cumsum(res_hist) / (res_M*res_N);

%% 5. show results
figure(1);
plot(T); title('transfer function'); grid minor;

figure(2);
subplot(3,3,1); imshow(org_img); title('original image'); grid minor;
subplot(3,3,2); plot(org_hist); title('original histogram'); grid minor;
subplot(3,3,3); plot(org_cdf); title('original CDF'); grid minor;

subplot(3,3,4); imshow(ref_img); title('reference image'); grid minor;
subplot(3,3,5); plot(ref_hist); title('reference histogram'); grid minor;
subplot(3,3,6); plot(ref_cdf); title('reference CDF'); grid minor;

subplot(3,3,7); imshow(res_img); title('result image'); grid minor;
subplot(3,3,8); plot(res_hist); title('result histogram'); grid minor;
subplot(3,3,9); plot(res_cdf); title('result CDF'); grid minor;
