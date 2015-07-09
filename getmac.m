function data=getmac()
%  获取电脑的机器名和MAC地址
%
%  example:
%     data=getmac;
%   output:
%      data.pcname='*****';
%      data.macsite='**-**-**-**-**-**'
%
%   2015.6.6 @ J.Song beta 1.0




[~,b]=dos('ipconfig/all');
zj_name=regexp(b,'主机名[\.\s:]{1,}([a-z0-9A-Z-]{0,})','tokens');%主机名
if (iscell(zj_name))&&(~isempty(zj_name))
    zj_name=zj_name{1}{1};
else
    zj_name='ERROR:absence';
end

macdata=regexp(b,'物理地址[\.\s:]{1,}([a-z0-9A-Z-]{0,})','tokens');
if (iscell(macdata))&&(~isempty(macdata))
    macdata=macdata{1}{1};
else
    macdata='ERROR:absence';
end

data=struct;
data.pcname=zj_name;
data.macsite=macdata;

end






