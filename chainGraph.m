
%% TraverseDown
% Summary:
% This runs Collatz down from X to 1, with the syntax:
%       system(' "traverseDown.exe" [X, Y]');
%       system(' "traverseDown.exe" Z');
%
% Note that it takes either a list or a value as input.
% Brackets are required for list, optional for values,
% and commas are optional for lists.
%
% It then loads the COMPENDIUM file that is created and graphs
% the numerical relationships as a directed graph.
%
% Note: The default behavior is to filter out extra nodes, but
% I have left in code to include them if you want that.

%% Future Improvements

%{

1. Find a way to save arguments to file, have C load the arguments, and pass them
    to Prolog, OR if that has limitations, have Prolog itself load the file.
    This is to bypass the MATLAB "Error using system: The command is too long."

2. Fix arrows in quiver plots so they point to next X value correctly.

%}

%% Call function
In = [1:1000];
InStr = string(In);
Inn = "";

for (n = 1:length(InStr))
    if (n == 1)
        Inn = strcat("[", InStr(n));
    elseif (n == length(InStr))
        Inn = strcat(Inn, ", ", InStr(n), "]");
    else
        Inn = strcat(Inn, ", ", InStr(n));
    end
end

command = "traverseDown.exe" + " " + Inn;
system(command);
fileID = fopen("collatz collapse.compendium","r"); 

%% Import Data
data = textscan(fileID, "%s");
deeta = string(data{1});


%% Format Data

%{---Format data as string arrays without brackets---%}
A = strsplit(deeta, ",[");

for (n = 1:length(A))
    A(n) = erase(A(n), "[");
    A(n) = erase(A(n), "]");
end

for (n = 1:length(A))
    for (m = 1:length(A))
        if (n==m)
            continue;
        else
            if (contains(A(n), A(m)))
                A(m) = 0;
            end
        end
    end
end

%{---Convert to a single cell array of numbers (removing duplicates chains)---%}
B = {};
count0 = 0;

for (n = 1:length(A))
    if (A(n) == "0")
        count0 = count0 + 1;
        continue;
    else
        B{n-count0} = A(n);
    end
end

for (n = 2:length(B))
    B{1} = append(B{1}, ",", B{n});
end

X = str2num( B{1} );


%{---Generate list of steps from each "X" to the next "1"---%}
C = {};
D = {};
count0 = 0;

for (n = 1:length( X ))
    if (X(n) == 1)
        C{n-count0} = n;
    else
        count0 = count0 + 1;
    end
end

alpha = 1;

for (n = 1:length( X ))
    D{n} = C{alpha} - n;

    if (n == C{alpha})
        alpha = alpha + 1;
    end
end

Y = cell2mat(D);
Z = Y;

%{---Create U and V arrays---%}
E = {};
F = {};

for ( n = 1:length(X) )
    if (X(n) == 1)
        E{n} = 0;
    else
        E{n} = X(n+1)-X(n);
    end
end

U = cell2mat(E);

for ( n = 1:length(X) )
    if (Y(n) == 0)
        F{n} = 0;
    else
        F{n} = 1;
    end
end

V = cell2mat(F);
W = V;

%% Create plots

f = figure(1);

%q2 = quiver(X, Y, U, V, 0.25);
%q3 = quiver3(X, Y, Z, U, V, W);
p2 = plot(X, Y);
%p3 = plot3(X, Y, Z);

