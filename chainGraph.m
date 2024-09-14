
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

2. Fix arrows in quiver plots so they aren't horizontal bars. Probably can't.

%}

%% Call function
In = [1:2000];
InStr = string(In);
Inn = "";

for (n = 1:length(InStr))
    if (n == 1)
        Inn = strcat("[", InStr(n));

        if (isscalar(InStr))
            Inn = strcat(Inn, "]");
        end
    elseif (n == length(InStr))
        Inn = strcat(Inn, ", ", InStr(n), "]");
    else
        Inn = strcat(Inn, ", ", InStr(n));
    end
end

% Save input to file and pass to Prolog via import in C.
fileID0 = fopen("Input.praenuntio","w"); 
    
if (fileID0 == -1)
    fprintf("Error: Cannot create Praenuntio." + newline + newline);
    return;
end

fprintf(fileID0, "%s", Inn);
fclose(fileID0);
command = "traverseDown.exe";

yn = system(command);

if (yn ~= 0)
    fprintf("The system call didn't work!" + newline);
    return
end

%% Import Data

fileID = fopen("collatz collapse.compendium","r"); 
if (fileID == -1)
    fprintf("Error: Cannot find Compendium." + newline + newline);
    return;
end

data = textscan(fileID, "%s");
deeta = string(data{1});
fclose(fileID);

%% Format Data

%{---------------------------------------------------%}
%{   Format data as string arrays without brackets   %}
%{---------------------------------------------------%}

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


%{----------------------------------------------------------------------------%}
%{   Convert to a single cell array of numbers (removing duplicates chains)   %}
%{----------------------------------------------------------------------------%}

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


%{----------------------------------------------------------%}
%{   Generate list of steps from each "X" to the next "1"   %}
%{----------------------------------------------------------%}

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


%{---------------------------%}
%{   Create U and V arrays   %}
%{---------------------------%}

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
        F{n} = -1;
    end
end

V = cell2mat(F);
W = V;

%% Create plots

%{-----------------------------------------%}
%{   Quiver plot 1 with labels and stuff   %}
%{-----------------------------------------%}

f = figure(1);
f.WindowState = "maximized";

Q2A = subplot(1, 2, 1);
q2a = quiver(Y, X, U, V, 0);

title("Why is this a triangle?");
subtitle("(Length represents the distance to next number," + newline + "Direction represents going up or down to next number.)");

set( get(Q2A,'XLabel'), 'String', 'Degree of Change to Next Number' );
set( get(Q2A,'YLabel'), 'String', 'Starting Number' );

q2a.MaxHeadSize = 0.1;
q2a.Marker = "*";


%{-----------------------------------------%}
%{   Quiver plot 2 with labels and stuff   %}
%{-----------------------------------------%}

Q2B = subplot(1, 2, 2);
q2b = quiver(Y, X, V, U, 0);

title("Why is this fractal tile-ing?");
subtitle("(Arrows point to next number.)");

set( get(Q2B,'XLabel'), 'String', 'Number of Steps until Termination' );
set( get(Q2B,'YLabel'), 'String', 'Starting Number' );

q2b.MaxHeadSize = 33/max(U);
q2b.Marker = "*";


%{-----------------------------------------%}
%{   Quiver 3D plot with labels and stuff  %}
%{-----------------------------------------%}

f = figure(2);
f.WindowState = "maximized";

Q3 = subplot(1, 1, 1);
q3 = quiver3(X, Y, Z, U, V, W, 0);

title("I'm not sure seeing it in 3D is helpful, but oh well.");
subtitle("(Arrows point to next number.)");

set( get(Q3,'XLabel'), 'String', 'Starting Number' );
set( get(Q3,'YLabel'), 'String', 'Number of Steps until Termination' );
set( get(Q3,'ZLabel'), 'String', 'Number of Steps until Termination' );

q3.MaxHeadSize = 33/max(U);
q3.Marker = "*";


%{-----------------------------------------%}
%{   2D line plot with labels and stuff    %}
%{-----------------------------------------%}

f = figure(3);
f.WindowState = "maximized";

P2 = subplot(1, 1, 1);
p2 = plot(X, Y);

title("Fractal tiling with points shown.");
subtitle("(Points show each value.)");

set( get(P2,'XLabel'), 'String', 'Starting Number' );
set( get(P2,'YLabel'), 'String', 'Number of Steps until Termination' );

set( P2,'XLimitMethod', 'padded');
set( P2,'YLimitMethod', 'padded');

hold on;
s2 = scatter(X, Y);
hold off;

% RGB(1-255) to (RGB 0-1)
colorR = 13.6;
colorG = 116.9;
colorB = 188.9;

RGB = [colorR/255, colorG/255, colorB/255];

s2.Marker = "*";
s2.MarkerEdgeColor = RGB;


%{-----------------------------------------%}
%{   3D line plot with labels and stuff    %}
%{-----------------------------------------%}

f = figure(4);
f.WindowState = "maximized";

P3 = subplot(1, 1, 1);
p3 = plot3(X, Y, Z);

title("I'm not sure seeing it in 3D is helpful, but oh well.");
subtitle("(Looks 3D around the bunched up places, but I don't know what Z would be.)");

set( get(P3,'XLabel'), 'String', 'Starting Number' );
set( get(P3,'YLabel'), 'String', 'Number of Steps until Termination' );
set( get(P3,'ZLabel'), 'String', 'Number of Steps until Termination' );
