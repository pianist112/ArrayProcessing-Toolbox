% ULA setting:
% input parameters:
%   anglePhi: look-angle of the array. Can also be matched file angle
%   spacing: array spacing, in real distance (not lambda)
%   carrierFreq: modulating frequency
%   waveSpeed: most cases is c=3e8 but may vary in different medias
%   arraySize: number of sensors in the ULA
% output parameter:
%   steerVector: steering vector at angle anglePhi 

function steerVector = ulaSet(anglePhi, spacing, carrierFreq, waveSpeed, arraySize) 
  lambda = waveSpeed/carrierFreq;
  u = (spacing/lambda)*sin(anglePhi*pi/180);
  steerVector = exp(-j*2*pi*u*(0:arraySize-1)/arraySize)/sqrt(M);
