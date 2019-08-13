function noisy = addnoise(signal,snr)
% ADDNOISE add white gaussian noise of snr db ratio to an original signal
% coded by Cédric Morio Nov 2018
%
% noisy = ADDNOISE(signal,snr)
%   Inputs :
%       signal : original signal
%       snr : signal to noise ratio
%   Output :
%       noisy : noisy signal
%
% See Also AWGN WGN
%
p = sum(abs(signal).^2) / length(signal);
p = 10 * log10(p);
[m,n] = size(signal);
p = p - snr;
np = 10 ^ (p/10);
rng(0); % reset the radom generator to 0 for all the condition
noise = (sqrt(np))*randn(m,n);
noisy = signal + noise;