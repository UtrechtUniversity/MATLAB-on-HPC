function s=test_matmul(N,nprocs)

if (isstr(N))
  N = str2num(N);
end

if (isstr(nprocs))
  nprocs = str2num(nprocs);
end


n=N;
A = rand(n);                % create random matrix
B = rand(n);                % create another random matrix

% vector implementation (may trigger multithreading)

for i=1:nprocs
   m = 2^(i-1);
   maxNumCompThreads(m); % set the thread count to 1, 2, 4, or 8
   tic                         % starts timer
   C = A * B;                  % matrix multiplication
   walltime(i) = toc;          % wall clock time
   Speedup = walltime(1)/walltime(i);
   Efficiency = 100*Speedup/m;
  fprintf ( 1, '  # cores = %u\n', m );
  fprintf ( 1, '  Walltime  = %8.4f\n', walltime(i) );
  fprintf ( 1, '  Speedup   = %8.4f\n', Speedup );
  fprintf ( 1, '  Efficiency   = %8.4f\n', Efficiency );

   
end
s=1;
end
