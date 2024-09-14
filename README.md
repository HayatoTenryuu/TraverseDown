# TraverseDown

### Purpose:
1. I wanted to see how things looked, and fun stuff came out from this. 
2. Different plots gave different info, so this did turn out as a thing of interest.
3. I found a limit on what it was doing, so I wanted to push that limit.

### How to use:
1. In case of a serious break, the .exe file that MATLAB uses can be regenerated from the reference files.
2. If you have some dire need to go back, or if the MATLAB file is the problem, we are using Github, so you can go to an earlier version (which is also what inspired me to use Github for this).
3. The .exe files need to be regenerated from the source files any time they are updated.
4. To recompile the .exe, use command `swipl-ld -o traverseUp term.c termy.pl`.
5. Updates to term.c or termy.pl are rare, so consider those highly stable points of reference.
6. Compendium files are just output data being passed from Prolog to MATLAB.
7. Praenuntio files are just input data being passed from MATLAB to Prolog.

### How it works:
1. This program normally passes a list/array of starting numbers to Prolog, and Prolog works them down.
2. Prolog can print the chains to the terminal (which enters the MATLAB terminal), but I prefer it not.
3. The output is saved as a list of lists (array of arrays) which are imported into MATLAB.
4. MATLAB checks if any are subsets of each other (2->1 is within 4->2->1).
5. Subsets are unified, unique sets are appended, and then the remaining thing is graphed.
6. Graphs include: Plot, 3D plot (in case it sparks ideas), quiver, and 3D quiver (just in case).

      i. If you pass a 5, *argv[1] will return "53", because char(53) = "5".

      ii. Again, 53 is the ASCII code for the number 5.

      iii. If you pass an array, *argv[1] returns "91", because char(91) = "[".
