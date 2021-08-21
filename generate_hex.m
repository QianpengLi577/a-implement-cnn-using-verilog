a=textread("x.txt");
number_dec = single(a);
hexString = num2hex(number_dec);
dlmwrite('xhex.txt', hexString, 'delimiter', '', 'newline', 'pc');

a=textread("b.txt");
number_dec = single(a);
hexString = num2hex(number_dec);
dlmwrite('bhex.txt', hexString, 'delimiter', '', 'newline', 'pc');

a=textread("out.txt");
number_dec = single(a);
hexString = num2hex(number_dec);
dlmwrite('outhex.txt', hexString, 'delimiter', '', 'newline', 'pc');

a=textread("w.txt");
number_dec = single(a);
hexString = num2hex(number_dec);
dlmwrite('whex.txt', hexString, 'delimiter', '', 'newline', 'pc');

a=textread("w_all.txt");
number_dec = single(a);
hexString = num2hex(number_dec);
dlmwrite('wallhex.txt', hexString, 'delimiter', '', 'newline', 'pc');