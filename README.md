# ASI_MTF
Imagej macro (ASI_MTF.ijm) to calculate the modulation transfer function (MTF) based on a knife edge measurement.

# Installation
In ImageJ, click on Plugins, Install... and open ASI_MTF.ijm to add this macro to the ImageJ plugin menu.

# Usage
Open an image file of a knife edge measurement. Select a rectangular area around the edge and the macro will calculate
the MTF as a function of pixel spatial frequency. A test image with several edges can be found in the data folder.

The edge does not have to be straight, however the macro needs one edge in the region of interest. The region of interest has to be sufficiently large to have enough data for the calculations.

The MTF will be calculated in two ways. The first one is based on a line spread histogram. The 2nd one is based on a Gaussian fit of the line spread data points for all pixels.

ASI_NNPS.ijm is a macro under development to calculate the NNPS based on a stack of flat field (open beam) images. 

# Author
Erik Maddox (erik.maddoxATamscins.com), Amsterdam Scientific Instruments B.V.
  