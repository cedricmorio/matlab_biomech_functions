function [fc,nq,err] = analyseresiduellewinter(signal,fs,type,n,trace)
% Created by Cédric Morio, PhD
% Decathlon SportsLab
% December 2019
%
% based on Winter 1990
% make a residual analysis on the input SIGNAL
% requires LPFILTER, NYQUIST, NYQUISTINV functions
%
% inputs :
%       SIGNAL original signal to perform the residual analysis on
%       FE signal frequency
%       TYPE 'butter' or 'damped' filtering method
%       N filtering passes
%       TRACE 'on' or 'off' if the figure is plotted or not
% outputs :
%       FC the cut-off frequency automatically detected according to Winter
%       1990 method
%       NQ the corresponding nyquist frequency to FC, the minimum recording
%       frequency corresponds to 2*NQ
%       ERR the minimal residual error for FC frequency
%
L = length(signal); % original signal length
nres = round(nyquist(fs,type,n)); % length of residual vector
R = zeros(nres,1); % initialisation of the residual vector
F = zeros(nres,1); % initialisation of the frequency vector
% computation of the residual vector
for i = 1:nres
    % filtered signal
    tmp = lpfilter(signal,i,fs,type);
    % residual signal
    res = signal-tmp;
    % RMS of the residual signal
    R(i) = sqrt(sum(res.^2)/L);
    F(i) = i;
end
% selection of th best linear regression
r2 = zeros(nres,1);% r square vector
for i = 1:nres-1
    r = corrcoef(F(i:end),R(i:end));
    r2(i) = round(-r(1,2),2);
end
i = 1;
while r2(i)<max(r2) && i<nres
    i = i + 1;
end
fc = i;
nq = nyquistinv(fc,type,n);
p = polyfit(F(fc:nres),R(fc:nres),1);
err = p(2);
% display of the residual graph
if strcmp(trace,'on')
    figure('Color',[1 1 1]);
    plot(F,R,'r','LineWidth',2);
    hold on;
    plot(F,polyval(p,F),'--b');
    line([0 fc],[err err],'Color','b');
    line([fc fc],[err 0],'Color','b');
    title('residual analysis');
    xlabel('frequencies');
    ylabel('residuals');
end