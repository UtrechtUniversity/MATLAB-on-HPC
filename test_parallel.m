function s = test_parallel(ni, nprocs)

if (isstr(ni))
    ni = str2num(ni);
end

if (isstr(nprocs))
    nprocs = str2num(nprocs);
end

myCluster = parcluster('local'); % cores on compute node are "local"
m = 2.^(0:(nprocs-1));

for i=1:nprocs
    tic                         % starts timer
    
    A = 500;
    a = zeros(ni);
    parfor (ii = 1:ni,m(i))
        a(ii) = max(abs(eig(rand(A))));
    end
    walltime(i) = toc;      % prints wall clock time
    Speedup = walltime(1)/walltime(i);
    Efficiency = 100*Speedup/m(i);
    fprintf ( 1, '  # cores = %u\n', m(i) );
    fprintf ( 1, '  Walltime  = %8.4f\n', walltime(i) );
    fprintf ( 1, '  Speedup   = %8.4f\n', Speedup );
    fprintf ( 1, '  Efficiency   = %8.4f\n', Efficiency );
   
end
delete(gcp)
s=1;
end
