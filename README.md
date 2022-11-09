# Calcium Imaging Analysis 
Matlab files used in the paper: 
Differentiated dynamic response in C. elegans chemosensory cilia 
by Christine W. Bruggeman, Guus H. Haasnoot, Noémie Danné, Jaap van Krugten and Erwin J.G. Peterman
DOI:https://doi.org/10.1016/j.celrep.2022.111471

1) Use Metadata_Time script to get correct time per slice and frame out of metadata. 
2) FrameToTime uses intensity per frame (obtained with ImageJ) together with output from previous script to make matrix with intensity and time in seconds
3) IntensityvsTime_Edit makes the mean and individual plots of multiple measurements with the same stimuli. These plots are normalized in time and intensity.

Matlab scripts written by Aniruddha Mitra
