function  [flag]=mymail(receiver,subject,content,fujian_dir);

%  mymail(receiver,subject,content,fujian_dir)
%  个人邮件发送函数
%  mymail(receiver,subject,content,fujian_dir)
%  其中
%   receiver为收件人邮箱，如receiver='********@126.com';
%           支持单显群发，此时receiver为cell类，例如receiver={'test1@**.**';'test2@**.**'};
%  subject = ['ceshi'];   %邮件标题
%  content =[ '第一行！'10 '第二行'10'第三行'];  %邮件内容 10代表换行
%  fujian_dir={'**.**','**.**'}; 若无附件，则请赋值[]
%
%  sendmail('gasongjian@126.com',subject,content,'theif8.jpg'); %接受邮件的邮箱
%
%
%
%  注意： 附件名建议为英文格式，否则可能出现文件名编码错误.
%
%
%   为了安全，可配置完毕后编译成p文件，然后把m文件删除   
%    pcode mymail
%   进一步，也可以设置MAC地址锁定，即只有有权限的电脑才能使用。
%
%  2012.5.16 @ J.Song beta 1.1




%%%%%%%%%%%%%%%%%%%%%%【需要自行配置的地方】%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mail_send = '*************';  %发件人的邮箱
mail_password = '**********' ;  % 发件人邮箱密码
%%%%%%%%%%%%%%%%%%%%%%%【需要自行配置的地方】%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if all(ismember(mail_send,'*'))
    warning('使用前请打开函数文件配置发件箱.')
    return
end
    

mail_class=mail_send(strfind(mail_send,'@')+1:end);
flag=0;
if (nargin==3)
    fujian_dir=[];
end
 
MailAddress = mail_send;   
password = mail_password;      
setpref('Internet','E_mail',MailAddress);
setpref('Internet','SMTP_Server',['smtp.',mail_class]);
setpref('Internet','SMTP_Username',MailAddress);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

content=[content 10 10 10 '=======================================  '...
    10  'This Email Sended Automatically by Matlab.']; %可自行修改。

if ~iscell(receiver)
    receiver={receiver};
end



try
    
for i=1:length(receiver)    
sendmail(receiver{i},subject,content,fujian_dir);
end
flag=1;
catch err
    fprintf('ERROR:  %s',err.identifier);
end








 
     
         
         
         
         
         
