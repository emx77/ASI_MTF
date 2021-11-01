# ASI_MTF
Imagej macro (ASI_MTF.ijm) to calculate the modulation transfer function (MTF) based on a knife edge (or slanted edge) measurement.

# Installation
In ImageJ, click on Plugins, Install... and open ASI_MTF.ijm to add this macro to the ImageJ plugin menu.

# Usage
Open an image file of a knife edge measurement. Select a rectangular area around the edge and the macro will calculate
the MTF as a function of pixel spatial frequency. A test image with several edges can be found in the data folder.

The edge does not have to be straight, however the macro needs one edge in the region of interest. The region of interest has to be sufficiently large to have enough data for the calculations.

The MTF will be calculated in two ways. The first one is based on a line spread histogram. The 2nd one is based on a Gaussian fit of the line spread data points for all pixels. Results representing the point spread function (PSF) and edge or line spread function (ESF or LSF) are also available.

ASI_NNPS.ijm is a macro under development to calculate the NNPS based on a stack of flat field (open beam) images. It runs in ImageJ 1.51.

# Author
Erik Maddox (erik.maddoxATamscins.com), Amsterdam Scientific Instruments B.V.

# Applications
J. Salido, P. T. Toledano, N. Vallez, O. Deniz, J. Ruiz-Santaquiteria, G. Cristobal, and G. Bueno, "MicroHikari3D: an automated DIY digital microscopy platform with deep learning capabilities," Biomed. Opt. Express 12, 7223-7243 (2021) (https://www.osapublishing.org/boe/fulltext.cfm?uri=boe-12-11-7223&id=46277)
  
