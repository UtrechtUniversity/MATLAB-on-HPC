# Parallel computing with MATLAB
This part provides instructions on how to create (or adapt) a script that is compatible for HPC, examples of ways to parallelize MATLAB code and benchmark tests how these parallel solutions perform on HPC.

# Instructions for creating HPC compatible MATLAB scripts
To make a script compatible for HPC you basically need to make 2 changes.

1. The main script should be structured and saved as a function.

2. Any input variables that are passed assigned outside this function and passed when calling the main function are passed as characters and need to be converted to numeric.

Example:

```
function m = examplescript (n)  % Create function

if (isstr(n))                   % Convert function input
  n = str2num(n);               % Convert function input
end                             % Convert function input

m = magic(n);                   % Main body of script
disp(m)                         % Main body of script

end                             % End of function
```
The output m will be printed as text in the output file of the HPC job. To save variable or the entire workspace for future analyses, use the save command and save e.g. as .mat file.

To be compatible with HPC, scripts have to be translated to machine language using the [mcc](https://nl.mathworks.com/help/compiler/mcc.html) command. Compiling the above script can be done as follows.

```
../mcc -mv -o myexample examplescript.m
```

A couple of obtions are activated in the command:

```-m```

which means: direct mcc to generate a standalone application.

```-v```

which means: display the compilation steps.

```-o <executable name>```

which is used to specify the name of the final executable.

If you compile a script that calls different (non built-in) functions, these need to be specified as well directly after the main script.
```
../mcc -mv -o myexample examplescript.m examplescript2.m
```
If there are a large number of scripts that are called it can help to put them in a folder and add this folder using the ```-a``` option:
```
../mcc -mv -o examplefolder examplescript.m -a ./examplefolder
```
```-a ./examplefolder``` will include all files in the ```examplefolder``` and files in subfolders of ```examplefolder```.

To include only matlabscript that are inside ```examplefolder``` use:

```-a ./examplefolder/*.m```

```*.m``` means that all files with a ```.m``` extension are included.

# Speeding up MATLAB calculations
A MATLAB script can take a lot of time to complete for several reasons, e.g: A single step within the script can take a lot of time because of the complexity of calculations, a very large number of very small calculations can also lead to long computation times as well as the usage of very large datasets. Depending on the reason for the long computation times there may be one or several options to reduce computation times.
To obtain insight into where most time is lost, it may be wise to use the [profiling](https://nl.mathworks.com/help/matlab/matlab_prog/profiling-for-improving-performance.html) options of MATLAB.

## Implicit parallelization (multithreading)
Suitable for: scripts spending a significant amount of time on functions that are multithreaded by default in MATLAB ( [function list](https://nl.mathworks.com/matlabcentral/answers/95958-which-matlab-functions-benefit-from-multithreaded-computation)).

Many MATLAB functions are multithreaded by default and use all available cores on a machine to execute faster. This means that codes that spend a significant amount of time performing these type of functions could greatly benefit from running on multicore nodes on HPC systems without additional changes to the code. However, multithreading may in certain situations slow down code when communication data transfer between the cores outweighs the lower workload. 

Below two examples of multithreaded functions are shortly discussed: matrix multiplication and linear solving.

**Example matrix multiplication**

This [example script](./test_matmul.m) performs a simple matrix multiplication of a 5000*5000 matrix. The calculation is repeated 5 times with an increasing number of cores (1,2,4,8,16) each iteration. This script was run on the UBC cluster on a compute node with 24 cores. The time it took for each iteration to complete and resulting speedup is displayed in the table below. The speedup is clear, although a little biased, as the first iteration takes a little longer due to first time execution. The speedup is dependend on problem size. A smaller or larger matrix can reduce speedup, possibly due to memory issues, communication or other trade-offs.


Cores     |Walltime |Speedup 
----------|---------|---------
1         | 4.4     |  1
2         | 1.5     |  3.0
4         | 0.8     |  5.8
8         | 0.5     |  9.0
16        | 0.4     | 11.4


**Example solve system of linear equations**

This [example script](./test_solve.m) solves a system of linear equations. The calculation is repeated 5 times with an increasing number of cores (1,2,4,8,16) each iteration. This script was run on the UBC cluster on a compute node with 24 cores. The time it took for each iteration to complete and resulting speedup is displayed in the table below. There is some speedup when using more core, but not very impressive.


Cores     |Walltime |Speedup 
----------|---------|---------
1         | 9.4     | 1
2         | 6.1     | 1.5
4         | 4.7     | 2.0
8         | 4.1     | 2.3
16        | 3.7     | 2.5


The testscripts above can be used as a template to test different functions and problem sizes before implementing such a solution to your code.
Note that MATLAB automatically uses all available cores available, so no alterations have to be made to your code to implement this and running your code on a HPC node with 16 or more cores may automatically result in speedups (depending on whether your problem is suitable). For these specific test examples the command ```maxNumCompThreads(m)``` is used each iteration to limit the number of threads.
To disable multithreading add ```-R singleCompThread``` to the mcc command:
```
../mcc -mv -R singleCompThread -o myexample examplescript.m
```
## Parallel Computing Toolbox

The [Parallel Computing Toolbox](https://nl.mathworks.com/help/distcomp/index.html) provides a number of options to make use of multicore processors for parallel calculations and big data analyses. 

**The parfor command**  
Suitable for: Tasks involving a number of independent calculations
(e.g. model simulations, parameter optimization, sensitivity analyses, for-loops with independent iterations, repetitions)

A [parfor-loop](https://nl.mathworks.com/help/distcomp/parfor.html) can simply replace for-loops. It only works when iteration in a for-loop are independent of eachother. Iterations are assigned to different workers (cores) and it is not possible to control which worker performs which iteration. If iterations are not too short and more or less equal in computation time speedups can be quite high.

This [example script](./test_parallel.m) does a number of independent eigenvector calculations. The calculation is repeated 5 times with an increasing number of cores (1,2,4,8,16) each iteration. This script was run on the UBC cluster on a compute node with 24 cores. The time it took for each iteration to complete and resulting speedup is displayed in the table below. The speedup is clear, although a little biased, as the first iteration takes a little longer due to first time execution.

Cores     |Walltime |Speedup 
----------|---------|---------
1         | 46.9    |  1
2         | 15.7    |  3.0
4         |  8.7    |  5.4
8         |  4.7    | 10.0
16        |  3.3    | 14.0


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



