clear;
close all;
clc;


binfile = ['a01_s01_e01_depth.bin'];  %%二进制文件所在目录
savefile = 'a01_s01_e01_depth';
mkdir(savefile);
if ~exist(binfile,'file');
    disp('error');
end;
disp(binfile);
fileread = fopen(binfile);      
if fileread<0
    disp('no such file.');
    return;
end;

header = fread(fileread,3,'uint=>uint');
nnof = header(1); ncols = header(2); nrows = header(3);

depths = zeros(ncols, nrows, nnof);
for f = 1:1:nnof
    frame = zeros(ncols,nrows);
    for row = 1:nrows
         tempRow = fread(fileread, ncols, 'uint=>uint');
         tempRowID = fread(fileread, ncols, 'uint8');
         frame(:,row) = tempRow;
    end
    depth(:,:,f) = frame;
    frame = fliplr(frame);
    [M,N,D] = size(frame);
    for b = 1:N   %%%深度值均衡
        for a = 1:M
            s = frame(a,b)/16;
            s = fix(s);
            frame(a,b) = s*1;
        end;
    end;
    frame = rot90(frame);
    frame = uint8(frame);
    imgfile = [savefile,'\',num2str(f),'.png'];  %%%保存目录及文件名
    imwrite(frame,imgfile);
    clear tempRow tempRowID;
end
fclose(fileread);