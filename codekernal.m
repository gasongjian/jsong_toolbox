function y=codekernal(STR,type,method,varargin);
% FUNCTION CODEKERNAL(STR,METHOD)
% 内部函数，实现各种加密与编码解码(持续添加)
%       md5加密：
%      codekernal('youstr','encode','md5')
%       某种编码：
%      codekernal('youstr','encode','utf8')
%       解码   ：
%      codekernal(code,'decode','utf8')
%
%
%
%   @ J.Song   @2015.01.25  beta1.0
%


%% 编码
if strcmp(type,'encode')
    switch method
        case {'md5','MD5'}
            import java.security.*;
            import java.math.*;
            md = MessageDigest.getInstance('MD5');
            hash = md.digest(double(STR));
            bi = BigInteger(1, hash);
            y=char(bi.toString(16));
        case {'utf-8','utf8'}
            y=char;
            unistr=STR;
            if (nargin>3)&&strcmp(varargin{1},'delimiter')
                delimiter=varargin{2};
            else
            delimiter='%';
            end

            for i=1:length(unistr)
                if unistr(i)=='老'
                    np=32769;
                else
                np=double(unistr(i));
                end
 
                if np<128                  
                    temp=dec2bin(np);
                    bindata='00000000';
                    bindata(9-length(temp):end)=temp;
                    y=strcat(y,[delimiter,dec2hex(bin2dec(bindata),2)]); %确保生成的十六进制有两位数字
                elseif np<2048
                    temp=dec2bin(np);
                    bindata='1100000010000000';
                    bindata([15-length(temp):8 11:16])=temp;
                    temp2=dec2hex(bin2dec(bindata),4);
                    if length(temp2)==4
                        temp2=[delimiter,'0',temp2(1:2),delimiter,temp2(3:end)];
                    else
                        error(wrong);
                    end
                    y=strcat(y,temp2);
                    
                elseif np<65536
                    temp=dec2bin(np);
                    bindata='111000001000000010000000';
                    bindata([6*2+9-length(temp):8 11:16 19:24])=temp;
                    temp2=dec2hex(bin2dec(bindata),6);
                    if length(temp2)==6
                        temp2=[delimiter,temp2(1:2),delimiter,temp2(3:4),delimiter,temp2(5:6)];
                    else
                        error('wrong');
                    end
                    y=strcat(y,temp2);
                elseif np<1114112
                    temp=dec2bin(np);
                    bindata='11110000100000001000000010000000';
                    bindata([6*3+9-length(temp):8 11:16 19:24 27:32])=temp;
                    temp2=dec2hex(bin2dec(bindata),8);
                    if length(temp2)==8
                        temp2=[delimiter,'0',temp2(1:2),delimiter,temp2(3:4),delimiter,temp2(5:6),delimiter,temp2(7:8)];
                    else
                        error('wrong');
                    end
                    y=strcat(y,temp2);
                end
            end
            %y=double(y);
    end
    
end



%% 解码
if strcmp(type,'decode')
    
    switch method
        case {'utf8'}
            hexstr=char(STR);
            hexstr(strfind(hexstr,32))=[];
            %hexstr(findstr(hexstr,double(delimiter)))=[]; % 去除分隔符
            flag=1;y=char;
            while flag>0
                % 一个字节是小于7F。所以当第一个字符小于8时一定是1个字节的情况，否则不是。
                if hex2dec(hexstr(1))<8
                    y=[y,hex2dec(hexstr(1:2))];
                    if length(hexstr)==2
                        flag=0;
                    else
                        hexstr=hexstr(3:end);
                    end
                else
                    % 2-4个字节的情形。 可以通过二进制下第一个0的位置判断是几个字节。若第一个0在第3个位置，则下一个字符为3-1个字节
                    headbin=num2str(dec2bin(hex2dec(hexstr(1:2)))); %头文件生成的二进制，如'天'='E5A4A9'中取E5=11100101
                    index=strfind(headbin,48);% 找出headbin中0的位置，例如上面可以看出天由三个字节组成
                    if isempty(index),error('please input the right utf8 code!');end
                    index=index(1)-1;%该字符的字节数
                    temp=num2str(dec2bin(hex2dec(hexstr(1:2*index))));%字符对应的二进制(utf8下的)
                    % 把utf8下的二进制转换成unicode下的二进制
                    index2=index+2:8;
                    for i=1:index-1
                        index2=[index2 [11:16]+(8*i-8)];%去除每个字节前面的1和多余的0
                    end
                    y=[y,char(bin2dec(temp(index2)))];
                    if index*2==length(hexstr)
                        flag=0;
                    else
                        hexstr=hexstr(2*index+1:end);
                    end
                    
                end
                
            end
        case {'CJK','cjk'}
           
    end     
end







