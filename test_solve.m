function s=test_solve(N,nprocs)

if (isstr(N))
  N = str2num(N);
end

if (isstr(nprocs))
  nprocs = str2num(nprocs);
end


n = N;         % set matrix size
M = rand(n);      % create random matrix
A = M + M';       % create A as a symmetric real matrix
x = ones(n,1);    % define solution x as unity vector
b = A * x;        % compute RHS b from A and x

for i=1:nprocs
  m = 2^(i-1);
  maxNumCompThreads(m);   % set the thread count
  tic                     % starts timer
  y = A\b;                % solves Ay = b; y should equal x
  walltime(i) = toc;      % prints wall clock time
  Speedup = walltime(1)/walltime(i);
  Efficiency = 100*Speedup/m;
  fprintf ( 1, '  # cores = %u\n', m );
  fprintf ( 1, '  Walltime  = %8.4f\n', walltime(i) );
  fprintf ( 1, '  Speedup   = %8.4f\n', Speedup );
  fprintf ( 1, '  Efficiency   = %8.4f\n', Efficiency );
  
end
s=1;
end