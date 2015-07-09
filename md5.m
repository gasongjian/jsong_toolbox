function md5str=md5(STR);
%  获取字符串的hash值.
%
%  example:
%     md5('hello!')
%    ans=
%        5a8dd3ad0756a93ded72b823b19dd877
%
%   2015.6.6 @ J.Song beta 1.0


import java.security.*;
import java.math.*;
md = MessageDigest.getInstance('MD5');
hash = md.digest(double(STR));
bi = BigInteger(1, hash);
md5str=char(bi.toString(16));
end