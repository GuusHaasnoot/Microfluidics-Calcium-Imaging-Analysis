filesinfolder = dir('*.txt');
for k=1:length(filesinfolder)

  fname = filesinfolder(k).name;
  ffolder = filesinfolder(k).folder;
  
  Metadata_main(fname,ffolder);
end



Metadata_main;
%% Extracting time data for imaging z slices over time. Saved file contains 2 mat files
% Timeinfo stores the frame number(1), grouped-Z frame number (2), the
% specific z-slice (3) and the elapsed time corresponding to the acquired
% frame.
% TimeSliceinfo stores the grouped-Z frame number and the corresponding
% time for the grouped Z frame.
function Metadata_main (FileName, PathName) 
% = uigetfile({'*.txt','MetaData(*.txt)'},'Load Metadata');
                fullpath = fullfile(PathName,FileName);
TxtData=fileread(fullpath);
k = strfind(TxtData, 'ElapsedTime-ms": ');
f = strfind(TxtData,  '"FrameKey-');
Timeinfo=zeros(length(k),4);
for i=1:length(k)
    u=find(TxtData(k(i):k(i)+35)==char(','),1,'first');
    uu= TxtData(k(i)+17:k(i)+u-2);
    v=find(TxtData(f(i):f(i)+30)==char('-'),3,'first');
    w=find(TxtData(f(i):f(i)+30)==char('"'),2,'first');
    vv= TxtData(f(i)+v(1):f(i)+v(2)-2);
    vvv= TxtData(f(i)+v(3):f(i)+w(2)-2);
    Timeinfo(i,1)=i;
    Timeinfo(i,2)=str2num(vv)+1;
    Timeinfo(i,3)=str2num(vvv)+1;
    Timeinfo(i,4)=str2num(uu)/1000;
end
Num_TimeSlice = floor(length(Timeinfo)/max(Timeinfo(:,3)));
Z_Num= max(Timeinfo(:,3));
TimeSliceinfo=zeros(Num_TimeSlice,2);
for j =1:Num_TimeSlice
    TimeSliceinfo(j,1)=j;
%     A = Timeinfo(((j-1)*Z_Num + 1):((j-1)*Z_Num + Z_Num), 4) ;
%     TimeSliceinfo(j,2)= mean(A); %mean time of the grouped Z
%     TimeSliceinfo(j,2)= Timeinfo(((j-1)*Z_Num + 1),4); %time corresponding to the first frame of every Z-stack
      TimeSliceinfo(j,2)= Timeinfo((j*Z_Num),4); %time corresponding to the last frame of every Z-stack   
end

firstframediff = (TimeSliceinfo(1,2)-0);
restframediff = diff(TimeSliceinfo(1:Num_TimeSlice,2));
Timestackdiff = [firstframediff;restframediff];
TimeSliceinfo(:,3) = Timestackdiff;
Timestackdiffmean = mean(Timestackdiff);


%prompt = {'Enter Filename:' };
%dlg_title = 'Enter Filename';
%num_lines = 1;
def = strcat('Timeinfo_',(erase(FileName,'metadata_')));
%answer = inputdlg(prompt,dlg_title,num_lines,def);
save(strcat(def,'.mat'),'Timeinfo','TimeSliceinfo','Timestackdiffmean');
end




