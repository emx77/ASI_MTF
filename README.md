# ASI_MTF
Imagej macro to calculate the MTF based on a knife edge measurement

# Installation
In ImageJ, click on Plugins, Install... to add this macro to the ImageJ plugin menu

# Usage
Open an image file of a knife edge measurement. Select a rectangular area around the edge and the macro will calculate
the MTF as a function of pixel spatial frequency.

The edge does not have to be straight, however the macro needs one edge in the region of interest. The region of interest has to be sufficiently large to have enough data for the calculations.

The MTF will be calculated in two ways. The first one is based on a combined point spread histogram. The 2nd one a Gaussian fit of the data for all evaluated rows or columns.   