function [t,dof,p] = ttest_overlap(yA,yB,yAB,varargin)
% function for partially overlapping t-test between condition A and B
% written by Cédric Morio, Decathlon SportsLab, September 2017.
%
% !!! WARNING: spm8 toolbox is required to compute p values
%
% [t,dof,p] = TTEST_OVERLAP(yA,yB,yAB)
% Required Inputs:
%       yA: vector of size (n,1) containing n independent observations of
%           the A condition
%       yB: vector of size (m,1) containing m independent observations of
%           the B condition, m can differ from n
%       yAB: vector of size (k,2) containing k paired observations of
%           A(:,1) and B(:,2) conditions, k can differ from m and n
%
% [t,dof,p] = TTEST_OVERLAP(yA,yB,yAB,'two_tailed',true,'equal_var',true)
% varargin (optional):
%       'two_tailed': true if the t-test is interpreted two tailed, false
%           if the t-test is interpreted one tailed. default is set true
%           for two tailed
%       'equal_var': true if equal variances can be assumed for A and
%           B distribution, false if variances are inequals or if equal 
%           variance cannot be assumed, thus default is  false.
%
% Outputs:
%       t: statistical t value for partially overlap t-test (Derrick et al.
%          2017)
%       dof: degrees of freedom
%       p: p-value corresponding to the t distribution for the specified t
%           and dof values
%
% Based on:
%      Derrick B, Toher D, WhiteP. How to compare the means of two samples
% that include paired observations and independent observations: a
% companion to Derrick, Russ, Toher, and White (2017). The Quantitative
% Methods for Psychology, 2017, 13(2):120:126. doi:10.20982/tqmp.13.2.p120
%      Derrick B, Russ B, Toher D, White P. Test Statistics for the
% comparison of means for two samples which include both paired
% observations and independent observations. Journal of Modern Applied
% Statistical Methods, 2017, 16(1):137-157. doi:10.22237/jmasm/1493597280
%
if nargin < 3
    error('error: too few arguments in ttest_overlap call.');
elseif nargin > 3
    % set default values
    equal_var = false;
    two_tailed = true;
    % set equal_var and two_tailed
    for k = 1:length(varargin)
        if strcmpi(varargin{k},'equal_var')
            equal_var = varargin{k+1};
        elseif strcmpi(varargin{k},'two_tailed')
            two_tailed = varargin{k+1};
        end
    end
end
% separate paired observation in two disctinct vector
if ~isempty(yAB)
    yAd = yAB(:,1);
    yBd = yAB(:,2);
else
    yAd = [];
    yBd = [];
end
% basic computing of mean, sd, n values
x1 = mean([yA;yAd]);
x2 = mean([yB;yBd]);
if x1<x2
    tmp = yA;
    yA = yB;
    yB = tmp;
    tmp = yAd;
    yAd = yBd;
    yBd = tmp;
    clear tmp;
    x1 = mean([yA;yAd]);
    x2 = mean([yB;yBd]);
end
s1 = std([yA;yAd]);
s2 = std([yB;yBd]);
n1 = length(yA)+length(yAd);
n2 = length(yB)+length(yBd);
na = length(yA);
nb = length(yB);
% correlation for the paired data
if isempty(yAB)||size(yAd,1)==1
    r = 1; % case of full independent or only one paired sample
else
    R = corrcoef(yAd,yBd);
    r = R(1,2);
end
nc = size(yAB,1);
% compute t statistics and dof
if equal_var
    % when equal variance can be assumed
    sp = sqrt(((n1-1)*s1^2+(n2-1)*s2^2) / ((n1-1)+(n2-1)));
    t = (x1-x2)/(sp*sqrt((1/n1)+(1/n2)-(2*r*(nc/(n1*n2)))));
    % degrees of freedom v
    dof = (nc-1)+((na+nb+nc-1)/(na+nb+2*nc))*(na+nb);
else
    % when equal variance cannot be assumed
    t = (x1-x2)/(sqrt(s1^2/n1+s2^2/n2-(2*r*((s1*s2*nc)/(n1*n2)))));
    % degrees of freedom v
    gamma = ((s1^2/n1+s2^2/n2)^2)/((((s1^2/n1)^2)/(n1-1))+(((s2^2/n2)^2)/(n2-1)));
    dof = (nc-1)+((gamma-nc+1)/(na+nb+2*nc))*(na+nb);
end
% probability p on the student disdribution
% need of the spm8 toolbox  for p computing using the function 'spm_Tcdf'
% addpath('C:\Users\Cedric\Documents\MATLAB\spm1d\spm8');
if exist('spm_Tcdf')
    if two_tailed
        p = (1-spm_Tcdf(t,dof))*2;
    else
        p = (1-spm_Tcdf(t,dof));
    end
else
    p = NaN;
    warning('p value cannot be computed because spm8 toolox or ''spm_Tcdf'' function was not available in the matlab path');
end
end % end function
