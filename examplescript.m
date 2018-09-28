function m = examplescript (n)          % Create function

if (isstr(n))                           % Convert function input
  n = str2num(n);                       % Convert function input
end                                     % Convert function input

load examplefile.mat                    % Load input data

m = l*rand(1,n);                         % Main body of script
disp(m)                                 % Main body of script

save(fullfile(pwd,'outputfile.mat'));   % Save output data

end                                     % End of function