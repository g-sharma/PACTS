function [mymatrix] = Ndicomreader(foldername,filefilter);

directory_structure = dir([foldername '/' filefilter '*.dcm']); 
names={directory_structure.name};
firstfile = [foldername filesep names{1}];

myslice = dicomread(firstfile);
mymatrix = zeros(size(myslice,1),size(myslice,2),length(names));

for i = 1:length(names)
    current_name = [foldername filesep names{i}];
    currentInfo = dicominfo(current_name);
    mymatrix(:,:,currentInfo.InstanceNumber) = dicomread(current_name);
end
