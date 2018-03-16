print("");
print("ASI_MTF");
print("version: 1.0.1");
print("date: 20180316");
print("Author: Erik Maddox, Amsterdam Scientific Instruments B.V.");
print("");

image=getTitle();
print(image);

if (selectionType()<0) {
  waitForUser("Draw a box around the edge, then click OK");
}   

selectWindow(image);
getSelectionBounds(x0, y0, dx, dy);

//
// work with a temporary image based on the selection
//
run("Duplicate...", " ");
rename("selected_area");

//
// determine in which direction the PSF will be calculated
//
makeRectangle(0, 0, floor(dx/2), dy);
getStatistics(area, mean, min, max, std);
mean_left=mean;
makeRectangle(1+floor(dx/2), 0, dx -floor(dx/2), dy);
getStatistics(area, mean, min, max, std);
mean_right=mean;
makeRectangle(0, 0, dx, floor(dy/2));
getStatistics(area, mean, min, max, std);
mean_top=mean;
makeRectangle(0,1+floor(dy/2), dx, dy -floor(dy/2));
getStatistics(area, mean, min, max, std);
mean_bottom=mean;

dif_hor = mean_left - mean_right;
dif_ver = mean_top - mean_bottom;

loop_over_rows=false;
cols_low_to_high=false;
if (abs(dif_hor)>abs(dif_ver)) {
  loop_over_rows=true;
  if (dif_hor>0) {
    cols_low_to_high=true;
  }
}
else {
  if (dif_ver>0) {
    cols_low_to_high=true;
  }
}

//
// transform image to loop over rows and have the edge high values to low values 
// and from left to right
//

run("Select All");
if(loop_over_rows==false) {
  run("Rotate 90 Degrees Left");
}
if(cols_low_to_high==false) {
  run("Flip Horizontally");  
}

getSelectionBounds(sel_x0, sel_y0, sel_dx, sel_dy);
x0=sel_x0;
y0=sel_y0;
dx=sel_dx; 
dy =sel_dy;

// arrays for the point spread function
max_size_psf = (dx-2)*dy;
x_psf = newArray(max_size_psf);
y_psf = newArray(max_size_psf);

// range in pixels for x for psf
xmin = -10;
xmax = 10;

// count the data points within range 
count2 = 0;

// rows can be skipped if no good edge found in the row
skipped_rows=0;

// array length for histograms and psf plots
len=512;

// arrays for the histogram method
hist_binc= newArray(len);
hist_val = newArray(len);

// loop over all rows
for (j=0; j<dy; j++) {
  print("\\Update:row", j+1, " of ", dy);    
  xx = newArray(dx-2);
  yy = newArray(dx-2);
  yy2 = newArray(dx-2);
  max_i= -1;
  max = 0;  
  
  // loop over all pixels in row 
  // and calculate local derivative
  for (i=1; i<dx-1; i++) {
    xp =i+x0+0.5;
    yp =j+y0+0.5;
    cm= getPixel(xp-1, yp);
    c0 = getPixel(xp,yp);
    cp = getPixel(xp+1,yp);
  
    // derivative array	
    xx[i-1] = xp;
    yy[i-1] = (cm-cp)/2;
    
    // counts array
    yy2[i-1] = c0;
  
    if (yy[i-1]>max) {
      max = yy[i-1];
      max_i = xp;
    }
  }
 
  initialGuesses = newArray(0, max, max_i, 1); 
  Fit.doFit("Gaussian", xx, yy, initialGuesses);
  // rows without edge will have a bad chi^2 
  if (Fit.rSquared>0.66) {
    // align row such that the centre of peak corresponds to x=0  
    peakcenter=Fit.p(2);
    for (i=0; i<(dx-2); i++) {
      dif = xx[i]-peakcenter;
      if (dif>xmin && dif <xmax) { 
        x_psf[count2] = dif;
        y_psf[count2] = yy[i];
        count2++; 
      }
      // dif is in pixels, calculate which bin to select
      bin = floor((len/2)-dif);
      if (bin>-1 && bin<len) {
         hist_val[bin]+=yy[i];
      }
    }
  }
  else {
    skipped_rows++;
  }
}

// reduce to number of entries within the xmin, xmax range
x_psf_r = Array.slice(x_psf, 0, count2-1);
y_psf_r = Array.slice(y_psf, 0, count2-1);

// perform fit on psf data points
initialGuesses = newArray(0, 5, 0, 1);
Fit.doFit("Gaussian", x_psf_r, y_psf_r, initialGuesses );
Fit.plot;

print("");
print("Results:");
print("sigma PSF = ", Fit.p(3));
// print("rSquared PSF = ", Fit.rSquared);
print("Nr. of lines used = ", dy - skipped_rows, "of", dy);

// close the temporary window
selectWindow("selected_area");
close();

// array for histogram of fit function 
py = newArray(len);

first_binc= -len/2 + 0.5;

// peak centre
p2= Fit.p(2);
for (i=0; i<len; i++) {  
  py[i] = Fit.f(first_binc+i + p2)-Fit.p(0);
  hist_binc[i] = first_binc+i; 
}

Plot.create("Input function", "x", "value", hist_binc, hist_val);
Plot.setColor("red");
Plot.setLimits(xmin, xmax, NaN, NaN);
Plot.show();

// do the fourier transforms
ft_fit = Array.fourier(py);
ft_hist = Array.fourier(hist_val);

ft_len = lengthOf(ft_fit);

sf = newArray(ft_len);
for (i=0; i<ft_len; i++) {
  sf[i] = i+0.5;
  ft_hist[i]=(ft_hist[i]*ft_hist[i]);
  ft_fit[i]=(ft_fit[i]*ft_fit[i]); 
}

// normalize the MTF
// imagej FT is squared sum of positive negative spatial frequencies, except for FT(0)

tmp = ft_fit[1];
for (i=0; i<ft_len; i++) {
  ft_fit[i]= ft_fit[i]/tmp;
}
tmp = ft_hist[1];
for (i=0; i<ft_len; i++) {
  ft_hist[i]= ft_hist[i]/tmp;
}

// todo: remove first data point from plot.
// todo: update plot titles

Plot.create("Fourier amplitudes: ", "frequency bin", "amplitude (RMS)", sf, ft_hist);
Plot.setColor("blue");
Plot.add("line", sf, ft_fit);
Plot.setColor("black");
Plot.show();

print("histogram MTF(0,0.5,1.0):", ft_hist[1], ft_hist[floor(0.25*ft_len)],ft_hist[floor(0.5*ft_len)]);
print("fit MTF(0,0.5,1.0):", ft_fit[1], ft_fit[floor(0.25*ft_len)],ft_fit[floor(0.5*ft_len)]);
print("Ready.");
