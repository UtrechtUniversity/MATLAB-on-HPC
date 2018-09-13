function s = test_1(n, nprocs)

fprintf ( 1, '  Start of script');

if (isstr(n))
  n = str2num(n);
end;

if (isstr(nprocs))
  nprocs = str2num(nprocs);
end;

tic

A = 500;
a = zeros(n);
for i = 1:n
    a(i) = max(abs(eig(rand(A))));
end

toc
fprintf ( 1, '  End of script');

s=1;
end
