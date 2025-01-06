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
J. Salido, ea., "MicroHikari3D: an automated DIY digital microscopy platform with deep learning capabilities", Biomed. Opt. Express 12, 7223-7243 (2021) (https://doi.org/10.1364/BOE.439014)

R. Peng, ea. "Characterizing the resolution and throughput of the Apollo direct electron detector", Journal of Structural Biology: X
Volume 7, 2023, 100080 (https://www.sciencedirect.com/science/article/pii/S2590152422000216)

K. Stanaitis, ea., "Study of the low-cost HIPS and paraffin-based terahertz optical components", Lith. J. Phys. 63 233-240 (2023) (https://doi.org/10.3952/physics.2023.63.4.5)

M. Zabic, ea., "Point spread function estimation with computed wavefronts for deconvolution of hyperspectral imaging data", Sci. Rep. 15, 673 (2025) (https://doi.org/10.1038/s41598-024-84790-6)
