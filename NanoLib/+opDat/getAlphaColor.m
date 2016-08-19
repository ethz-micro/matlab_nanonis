function outputRGB = getAlphaColor(inputRGB,alpha,varargin)
% getAlphaColor correct the input color making it lighter or darker
% 
% inputRGB = [R,G,B] where R,G,B in [0,1]
% alpha = procent to change
% varargin = (default) light | dark

narginchk(2,3)

effect = 'light';

if nargin == 3
    effect = varargin{1};
end


switch effect
    case 'light'
        aRGB = ones(1,3); % white
    case 'dark'
        aRGB = zeros(1,3); % black
    otherwise
        error('Effect should be either light or dark');
end
            
outputRGB(1) = inputRGB(1) + (aRGB(1) - inputRGB(1)) * alpha;
outputRGB(2) = inputRGB(2) + (aRGB(2) - inputRGB(2)) * alpha;
outputRGB(3) = inputRGB(3) + (aRGB(3) - inputRGB(3)) * alpha;