function [ filelist ] = fcnFILELIST( dirpath, keyword )
%fcnFILELIST returns cell array of the files which contains the keyword in given directary
%   Detailed explanation goes here

dirobj = dir(dirpath);
dirname = {dirobj.name}';
filelist = dirname(~cellfun(@isempty,strfind(dirname,keyword)));

end

