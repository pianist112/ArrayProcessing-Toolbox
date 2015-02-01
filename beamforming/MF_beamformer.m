% ULA setting:
% input parameters:
%   anglePhi: look-angle of the array. anglePhi=arcsin(lambda*u/d), -.5<u<.5 so that -90<anglePhi<90
%   arraySize: number of sensors in the ULA
% output parameter:
%   steerVector: steering vector at angle anglePhi 

function steerVector = ulaSet(anglePhi,arraySize) 
   u = sin(anglePhi*pi/180);
   steerVector = exp(-j*pi*[0:arraySize-1]'*u)/sqrt(arraySize);
