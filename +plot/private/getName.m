function s=getName(file)
    %scan_file: 'E:\Nanonis\2015-02-27\image007.sxm'
    s=file.header.scan_file;
    list = strsplit(s,'\');
    s=list{end};
    list = strsplit(s,'.');
    s=list{1};
    
end