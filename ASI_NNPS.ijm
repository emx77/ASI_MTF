print("");
print("ASI_NNPS");
print("version: 1.0.1");
print("date: 20180323");
print("Author: Erik Maddox, Amsterdam Scientific Instruments B.V.");
print("");

//run("Image Sequence...", "open=/home/emaddox/work/M4I/20180219/raw_000021_hits.tif file=_hits sort");

print(getInfo("window.type"),nSlices);

if((getInfo("window.type")!="image") || nSlices<2) {
  print("The input image needs to be a stack with at least two frames.");
  //exit();
}

rename("input_stack");

setBatchMode(true);

// gain=5.5;
// mean=1175;
Stack.getStatistics(voxelCount, mean); 

//gain=2.90;
//mean=1439;
  
gain=1;
//mean=100;

wi = getWidth();
he = getHeight();

//top right coordinates:
// 0 1
// 2 3
sf_sz = 256;
intpix=4;

xtr = newArray(0,sf_sz+intpix,0,sf_sz+intpix);
ytr = newArray(0,0,sf_sz+intpix,sf_sz+intpix);

//xtr = newArray(0,sf_sz+4+1,0,sf_sz+4+1);
//ytr = newArray(0,0,sf_sz+4+1,sf_sz+4+1);

nsubframes = lengthOf(xtr);

print("x="+wi,"y="+he, "z="+nSlices, "subframes="+nsubframes);
print("mean counts per pixel:", mean);

//todo: check npoints for all, base on input images

npoints = sf_sz/2;
print("npoints =", npoints);
xp = newArray(npoints);
yp = newArray(npoints);

for(i=0; i<npoints; i++) {
  // xpoints in Nyquist frequency
  xp[i]=i/npoints;
  yp[i]=0;
}

ncombi = floor(nSlices/2);

print("ncombinations =", ncombi);

run("FFT Options...", "raw");

for (j=1; j<=ncombi; j++) {
  print("\\Update: processing: "+j+"/"+ncombi);
  jcombi = 2*j-1;
  setSlice(jcombi);
  
  run("Duplicate...", "title=one");     
  selectWindow("input_stack");
  setSlice(2*j); 
  run("Duplicate...", "title=two");
  imageCalculator("Subtract create 32-bit stack", "two","one");
  rename("dif"+jcombi); 

  close("one");
  close("two");
   
  // loop over subframes
   
  for (k=0; k<nsubframes; k++) {
    //selectWindow("dif");
    //makeRectangle(xtr[k], ytr[k], sf_sz, sf_sz);
    makeRectangle(xtr[k], ytr[k], sf_sz, sf_sz);
    
    run("Duplicate...", "title=subframe"); 
    getRawStatistics(lnPixels, lmean, lmin, lmax, lstd);
    //print(j,k,lmean);
    run("Subtract...", "value="+lmean); 
    //getRawStatistics(lnPixels, lmean2, lmin, lmax, lstd);
    //print(j, lmean2); 
    run("Macro...", "code=v=v/(sqrt(2)*"+gain+")");
  
    run("Select All");
    run("FFT");
    close("subframe");
    //close("FFT of subframe");
    selectWindow("PS of subframe");
    run("Select All");
    //setBatchMode(false); 

    im_cx=npoints;
    im_cy=npoints;
    im_radius=npoints;

    rad_sum = newArray(npoints);
    rad_occ = newArray(npoints);

    for (ii=0; ii<sf_sz; ii++) {
      for (jj=0; jj<sf_sz; jj++) {
        tmpval = getPixel(ii,jj);
        tmpdx = im_cx-(ii+0.5);
        tmpdy = im_cy-(jj+0.5);
       
        distance = sqrt(tmpdx*tmpdx+tmpdy*tmpdy);
        if (distance<npoints) {
          tmpbin=floor(distance);
          rad_sum[tmpbin]+=tmpval;
          rad_occ[tmpbin]++; 
        }
      }
    }

    for (ii=0; ii<npoints; ii++) {
      if (rad_occ[ii]!=0) {
        rad_sum[ii] =rad_sum[ii]/rad_occ[ii];
      }
    }


    // the plugin below does not work in batch mode 
    //run("Radial Profile Angle", "x_center="+npoints+" y_center="+npoints+" radius="+npoints+" starting_angle=0 integration_angle=180"); 
    // setBatchMode(true); 
    for (i=0; i<npoints; i++) {
      //yp[i]=yp[i]+Ext.getYValue(0,i);
      yp[i]=yp[i]+rad_sum[i];  
    }
    close("PS of subframe");

    selectWindow("dif"+jcombi);
    // print("next subframe");
  } // next sub frame

  // print("next combi");
  // print("aaaa");

  close("dif"+jcombi);
  selectWindow("input_stack");

} // next two slices



for (i=0; i<npoints; i++) {
  yp[i]=yp[i]/nsubframes/ncombi/npoints/npoints/4/(mean/gain); 
} 

setBatchMode(false);

Plot.create("Normalised Noise Power Spectrum", "Nyquist frequency", "NNPS", xp, yp);
Plot.show();

print("Ready.");
