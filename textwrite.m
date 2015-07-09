function textwrite(filename,data,delimiter)
%  把元胞数组的内容写到txt中
%  delimiter为分隔符，默认为','
%
%  example:
%     data={1,'2',3;'4','s','a'};
%     textwrite('test.txt',data,'|')
%  output:
%     test.txt
%         1|2|3
%         4|s|a
%
%   2015.6.6 @ J.Song beta 1.0


if nargin==2
delimiter=',';
end

[nrows,ncols] = size(data);
for i=1:nrows
    for j=1:ncols
        if ~isa(data{i,j},'char')
            
            data{i,j}=num2str(data{i,j});
        end
    end
end
fileID = fopen(filename,'w');
formatSpec = [repmat(['%s',delimiter],1,ncols-1),'%s\r\n'];
for row = 1:nrows
    fprintf(fileID,formatSpec,data{row,:});
end
fclose(fileID);