function nq = nyquist(fs,type,n)
%   nq = nyquist(Fs, TYPE, N) compute the corrected nyquist frequency for a 
%   2nd order filter 'butter' or 'damped' with N passes depending on the 
%   original sampling frequency Fs.
%
if nargin < 1
    error('not enough arguments when calling lpfilter.');
elseif nargin > 3
    error('too much arguments when calling lpfilter.');
elseif nargin == 1
    type = 'butter'; % type of filter is not specified
    n = 2; % number of passes is not specified
elseif nargin == 2
    switch type
        case 'butter'
            n = 2;
        case 'damped'
            n = 10;
        otherwise
            warning('type must be ''butter'' or ''damped''. default value will consider no correction of the nyquist frequency with nq=fe/2');
    end
end

switch type
    case 'butter'
        if n == 1
            % if the number of passes of the Butterworth is 1, there is no correction
            Cbw = 1;
        else
            % the correction is :
            Cbw = 1/(nthroot((2^(1/n))-1,4));
        end
        nq = fs/2/Cbw;
    case 'damped'
        Ccrit = 1/(sqrt((2^(1/(2*n)))-1)); % correction of the cutoff frequency
        nq = fs/2/Ccrit;
    otherwise
        nq = fs/2;
end