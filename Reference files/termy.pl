/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*  The functions here are to show the branches of Collatz,  */
/*  from the input to 1, in the terminal, and it will 		 */
/*  return a List of each number in the chain.               */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/


/*--------------------------------*/
/*         Useful Headers         */
/*--------------------------------*/

:- set_prolog_flag(answer_write_options,[max_depth(0)]).			% Make Prolog print all values in a list, instead of truncating the list [a, b, c, | ...].
:- set_prolog_flag(double_quotes, chars).							% Converts strings into character lists.

:- use_module(library(clpfd)).										% Load the library including "#=" integer arithmetic.
:- use_module(library(lists)).										% Load the library for list manipulation, including reversing the list.


/*------------------------------------*/
/*  Downward Traversal (Irreversible) */
/*------------------------------------*/

/* Find the chains and save the list */
traverseDownList(InList, OutList) :-
	(atom(InList) ->  
	(
		atom_string(InList, InString), 
		commaReplaceDown(InString, OutString),
		term_string(T, OutString)
	);
	(
		T = InList
	)),
	string_length(OutString, Le),
	(Le #= 1 ->
	(
		nl,
		traverseDown(T, OutList),
		nl,
		nl
	);
	(
		traverseDownList2(T, OutList)
	)),
	saveDownList(OutList).
	

/* Take a list and traverse its numbers down to 1 */
traverseDownList2( [Head | Tail], List ) :-
	List = [ListA | ListB],
	nl,
	traverseDown(Head, ListA),
	nl,
	traverseDownList2(Tail, ListB).
	
	%% This performs the normal traversal for every element of the input list.
	%% It also adds newline to the console for easy viewing of each element's chain.
	

/* Stop condition for empty list */
traverseDownList2( [], [] ) :-
	nl.
	
	%% This puts a newline between the last chain and the output list.
	
	
/* Take a number and traverse it down */
traverseDown(Input, List) :-
	(decrement(Input, List) -> Output #= 1; Output #= 0),
	write(Output).
	
	%% This puts a final 1 at the end of a chain. 
	%% It will put a 0 at the end if for any reason, we could not decrement to 1.
	%% That functionality was added just in case. It would allow us to (1) see if there are any holes in Collatz,
	%% and (2) see if there are any holes in our algorithm.
	
	
/* Stop condition for reaching 1 */
decrement(1, Tail) :- 
	Tail #= 1.
	
	%% This puts a 1 at the end of each chain's list, for when we visualize all the paths in MATLAB.
	
	
/* General case for decrementing */
decrement(Input, [Head | Tail]) :-
	(odd(Input) -> pathDownA(Input, Input2); pathDownB(Input, Input2)),
	write(Input),
	write('->'),
	Head #= Input,
	decrement(Input2, Tail).
	
	%% This runs the decrement along the odd method if the input is odd, 
	%% and along the even method if the input is even. It also writes some
	%% helpful stuff for visualizing each Collatz chain.
	
	
/* Remove duplicated commas in input */
commaReplaceDown(InString, OutString) :-	
	(re_match("(,,)", InString) -> 								
	(
		re_replace("(,,)", ",", InString, MidString),
		commaReplaceDown(MidString, OutString)
	);
	(
		OutString = InString
	)).


/* Test if Input is odd */
odd(Input) :-
	integer(Input),
	Input #> 0,
	Input>>1 #= (Input-1) rdiv 2.
	
	%% Note: I was hoping this could be used as a definition if used in reverse, but it cannot be because the last bit of the Input binary is lost.
	%% I made a thread on SWI-Prolog forum to see if we could make a reversible odd/3, but I'm not sure I'd know what to do with it even if we can.
	
	
/* Find the next value of the Collatz chain when odd */
pathDownA(Input, Output) :-
	integer(Input),
	Input #> 0,
	Output #= ((3*Input) + 1).
	
	%% Note that this version of pathDownA works both backwards and forwards, because we assume Input is odd,
	%% and because we are using rdiv. If we checked Input's odd/even-ness with odd/1, it would not work in reverse, 
	%% and if we used div, /, regardless of what equal sign we use, it will not go in reverse. 
	
	%% TraverseUp includes an odd/3 that does work in reverse though.
	
	%% Another important note -> In order to see all numbers attached in these chains, 
	%% we are not dividing by 2 despite along the odd path despite 3x+1 always resulting in an even number.
	
	
/* Find the next value of the Collatz chain when even */
pathDownB(Input, Output) :-
	integer(Input),
	Input #> 0,
	Output #= Input rdiv 2.
	
	%% Note that this version of pathDownA works both backwards and forwards, because we assume Input is even,
	%% and because we are using rdiv. If we checked Input's odd/even-ness with odd/1, it would not work in reverse, 
	%% and if we used div, /, regardless of what equal sign we use, it will not go in reverse. 
	
	%% TraverseUp includes an odd/3 that does work in reverse though.
	
	
/*-----------------------------------------*/
/*       Clean list and save to file       */
/*-----------------------------------------*/
	
/* Create a temp file to get our list as a string */
cleanDownList(InList, OutString) :-
	(InList = [] -> OutString = "";
	(
		string_chars(In, "tmp.compendium"),
		open(In, write, Input), 									% Create or remake List file.
		write(Input, InList),										% Write the List to the file
		close(Input),												% Close the file.
		
		%% Writing to a temporary file so we get a string.
		
		open(In, read, Input2),
		read_line_to_codes(Input2, InCodes),					    % Read the data to character codes.
		close(Input2),
		delete_file("tmp.compendium"),
		
		%% Reading and deleting the temporary file.
		
		string_codes(InString, InCodes),							% Convert codes to string.
		pipeReplaceDown(InString, OutString)							% Fix the string.
		
		%% Correcting the string and leaving it as-is so that we don't have to debug as much.
		
	)).
	
/* Replace pipes with commas */
pipeReplaceDown(InString, OutString) :-
	(re_match("[|]", InString) -> 
	(
		re_replace("[|]", ",", InString, MidString),
		pipeReplaceDown(MidString, OutString)
	);
	(
		OutString = InString
	)).
	
	
/* Save our binary tree list to a file */
saveDownList(List) :-
	cleanDownList(List, OutString),									% Get rid of pipes.
	string_chars(In, "collatz collapse.compendium"),
	open(In, write, Input), 										% Create or remake List file.
	write(Input, OutString),										% Write the List to the file
	close(Input).													% Close the file.
	