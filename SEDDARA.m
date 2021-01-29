
clear all; close all; clc

fo = rgb2gray(imread('car.jpg'));

figure, imshow(fo); title('Truth Image','Fontsize',20);

f_noise = imnoise(fo,'salt & pepper',0.1);

% f_noise = fo;

% d = fspecial('gaussian', [3 3], 50);

d = fspecial('motion', 10,15);

g = imfilter(f_noise, d);

% figure, imshow(g); title('Blurred Image','Fontsize',20);

% figure, imshow(g); title('Blurred + Noisy Image','Fontsize',20);% Fourier Domain

figure, imshow(g); title('Motion blurred + Noisy Image','Fontsize',20);% Fourier Domain



G = fftshift(fft2(g));

% s = fspecial('motion', 10,30);

s = fspecial('gaussian', [3 3], 500);

G_smooth = imfilter(abs(G),s);

% G_smooth = wiener2(abs(G),[2 2]);



Kg = 1/max(max(G_smooth));

para = fminsearch(@(para) myfun(para(1), para(2), Kg, G_smooth, G, fo),[0.3 0.5] )



alpha = para(1);	%0.2;%

K = para(2);        %0.08;%

D = (Kg.*G_smooth).^alpha;

F = G .* conj(D) ./ ((abs(D)).^2 + K);

f = ifft2(F);

figure, imshow((abs(f)),[min(min(abs(f))) max(max(abs(f)))]);

title('Reconstructed Image','Fontsize',20);

cost = myfun(alpha, K, Kg, G_smooth, G, fo)

D
