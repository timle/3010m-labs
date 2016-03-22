function [frequency, power] = fft_3010(sample, sample_rate)
% Input:    
%   sample: 
%   sample_rate: 
% 
% Output:
%   frequency: 
%   power: 
%
% Introduced in lab 9
%
% from http://www.mathworks.com/help/matlab/math/fast-fourier-transform-fft.html
%       more information, and many more usage examples available here


fs = sample_rate;                         % Sample frequency (Hz)
x = sample;

m = length(x);          % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(x,n);           % DFT
f = (0:n-1)*(fs/n);     % Frequency range
power = y.*conj(y)/n;   % Power of the DFT

frequency = f(1:floor(n/2));
power = power(1:floor(n/2));