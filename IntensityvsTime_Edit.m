%clear all

filesinfolder = dir('*TimeUnit.mat');
All_Intensity = []; % generates a matrix with each column storing 1 worm data

for i=1:length(filesinfolder)
  
    
  filename = filesinfolder(i).name;
  folder = filesinfolder(i).folder;
  fullpath = fullfile(folder,filename);
  
  Data = load(fullpath);
  prompt = {'Frame number Stimulus ON','Frame number Stimulus OFF'};%
  answer = inputdlg(prompt,strcat(filename,'Stimulus Timing'),[1 70]);
  stimulusON = str2double(answer{1});
  
  findname = erase(filename,{'.mat';'TimeUnit';'_Track2TimeUnit';'_Track3TimeUnit';'_Track4TimeUnit'});
  B = load(findname);
  
  timenorm = (Data.C(:,1) - ((stimulusON-1)*B.Timestackdiffmean));
  Intensity = Data.C(:,2);
  First20 = Intensity((stimulusON-21):(stimulusON-1),1);    
  Fzero = mean(First20);
  Fmin = min(Intensity); 
  
%   if ((Fzero+10000)>(Intensity(1))) || ((Intensity(1))>(Fzero-10000))
%       IntensityNormalized = ((Intensity - Fzero)/Fzero);
%   else 
%   end

IntensityNormalized = (Intensity - Fzero)/Fzero;  
%normalizedData = mat2gray(IntensityNormalized); %why did you use this step?
normalizedData = rescale(IntensityNormalized);
time_interpolate = -20:0.5:120; % generating x coordinates for interpolated values
Intensity_interpolate = interp1(timenorm,normalizedData,time_interpolate); % interpolated intensity values

All_Intensity(:,i)=Intensity_interpolate; 

plot(timenorm,normalizedData,'LineWidth',1,'Color',1/255*[200,200,200])
hold on
set(gca,'FontSize',18)
title('10mM Cu2+','FontSize',18)         %strrep(filename,'_','-')
xlabel('Time (s)','FontSize',14)
xlim([-20,120])
ylabel('Normalized GCaMP intensity','FontSize',14)
ylim([-0.1,1.1])




end
MeanIntensity = [];
for j = 1:length(All_Intensity)
MeanIntensity(j,1) = nanmean(All_Intensity(j,1:5)); % nanmean calculates the mean, ignoring the Nan values
end
plot(time_interpolate,MeanIntensity,'LineWidth',4,'Color',[0.6,0,0.9])
saveas(gcf,'figureplots.eps')
