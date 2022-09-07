clear all
%% This converts the frame numbers to time unit seconds
% Input1: The fluorescence intensity per frame, acquired from the plot
% z-profile function in ImageJ or analyzed with Trackmate in Fiji
% Input2: The .mat file with the information extracted from the metadata
% per measurement. Acquired with the function Metadat_Time made by
% Aniruddha Mitra






filesinfolder = [dir('*.dat');dir('*.xlsx')];
for k=1:length(filesinfolder)

  filename = filesinfolder(k).name;
  folder = filesinfolder(k).folder;
  fullpath = fullfile(folder,filename);
  if isa(fullpath,'*.xlsx')
      A=readmatrix(fullpath,'ThousandsSeparator'.'.');
  else
      A=readmatrix(fullpath);
  end
  
  if size(A,2)>10
      frame = A(1:length(A),9);
      intensity = A(1:length(A),13);
  else 
      frame = A(1:length(A),1);
      intensity = A(1:length(A),2);
  end
  
  
findname = erase(filename,{'.dat';'.xlsx';})
findname1 = erase(filename,{'.dat';'.xlsx'});
B = load(findname);
Time = frame*B.Timestackdiffmean;
C = [Time,intensity];

save(strcat(findname1,'TimeUnit.mat'),'C')


end
