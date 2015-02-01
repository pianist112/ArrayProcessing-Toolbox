% ULA setting 

function steerVector = ulaSet(anglePhi, spacing, carrierFreq, waveSpeed, arraySize) 
  lambda = waveSpeed/carrierFreq;
  steerVector = (spacing/lambda)*sin(anglePhi*pi/180);
