# Parallel computing with MATLAB
This part provides examples of ways to parallelize MATLAB code and benchmark tests how these parallel solutions perform on HPC.

A MATLAB script can take a lot of time to complete for several reasons, e.g: A single step within the script can take a lot of time because of the complexity of calculations, a very large number of very small calculations can also lead to long computation times as well as the usage of very large datasets.   Depending on the reason for the long computation times there may be one or several options to reduce computation times.
To obtain insight into where most time is lost, it may be wise to use the [profiling](https://nl.mathworks.com/help/matlab/matlab_prog/profiling-for-improving-performance.html) options of MATLAB.





## Implicit parallelization

Example matrix multiplication
Example linear solving


## Parallel Computing Toolbox

The [Parallel Computing Toolbox](https://nl.mathworks.com/help/distcomp/index.html) provides a number of options to make use of multicore processors for parallel calculations and big data analyses. 

**The parfor command**  
Suitable for: Tasks involving a number of independent calculations
(e.g. model simulations, parameter optimization, sensitivity analyses, for-loops with independent iterations, repetitions)




When a task involves many more iterations than the number of cores available on a node, it may be useful to cut the work into smaller pieces and submit separate jobs and make use of more than one node at the same time (see section jobs below).

More background about when to use the parfor command can be found [here](https://nl.mathworks.com/help/distcomp/decide-when-to-use-parfor.html).


**SPMD command**  
SPMD (single program multiple data) can be used for more complex programs. It has more flexibility than the parfor command, as it allows communication between the workers.

**Big datasets or large arrays**  
Sometimes datasets/matrices are too large in terms of memory to perform calculations on them on a local working station. MATLAB has several options to deal with large datasets and these options can be used in combination with the Parallel Computing Toolbox to distribute data over multiple processors, see [Mathworks documentation](https://nl.mathworks.com/help/distcomp/big-data-processing.html).


## MATLAB Distributed Computing Server

MATLAB Distributed Computing Server is currently not provided within the UU license, end therefore not elaborated in this guide.


## Jobs
Suitable for: Tasks involving a number of independent calculations
(e.g. model simulations, parameter optimization, sensitivity analyses, for-loops with independent iterations, repetitions)

