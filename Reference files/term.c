/* Include libraries. */
#include <stdio.h>
#include <string.h>
#include <SWI-Prolog.h>

/* Main */
int main(int argc, char **argv)                                                 // Get (arg_count = count of arg_vector characters) and (arg_vector pointer = pointer to input char array)
{ 
    /*-----------------------*/
    /*         Setup         */
    /*-----------------------*/

    char expression[1024];                                                      // Create character array with a max number of characters.
    char *e = expression;                                                           // Create a pointer to that array.
    char *program = argv[0];                                                        // Create a pointer to the input characters.
    char *plav[2];                                                                  // Create an array of pointers (the argument vector for Prolog).

  /* Combine all the arguments in a single string */
    for(int n=1; n<argc; n++)                                                   // Copy every character in argv to expression (via copying the address of every value in argv to the pointer e).
    { 
        if ( n != 1 )
        {
            *e++ = ',';                                                             // Add spaces between each character after the first one.
            *e++ = ' ';
        }
        strcpy(e, argv[n]);                                                         // Copy every address of argv[n] to e.
        e += strlen(e);                                                             // Move e to the next location in memory which is free to store stuff.
    }

    /* Make the argument vector for Prolog */
    plav[0] = program;                                                          // The first argv for Prolog is location of the first argv passed from the terminal.
    plav[1] = NULL;                                                             // NULL ends the execution.

    /*-------------------------------------------------------*/
    /* Section for debugging inputs before they reach Prolog */
    /*-------------------------------------------------------*/

    /*
    printf("\n");
    printf(expression);
    printf("\n");
    printf("Calling Prolog!\n\n");
    */

    /*-----------------------*/
    /*     Prolog Parts      */                                                     
    /*-----------------------*/

    /* Initialise Prolog */
    if ( !PL_initialise(1, plav) )                                              // Kill Prolog if it doesn't initialize successfully.
    {
        PL_halt(1);
    }
    
    /* Define the function(s) we wish to call from Prolog. */
    predicate_t pred = PL_predicate("traverseDownList", 2, "user");            // Call traverseDownList/2 with user settings.

    /* Define the argument(s) we wish to pass to the function(s). */
    term_t h0 = PL_new_term_refs(2);                                            // Create term h0.
    PL_put_atom_chars(h0, expression);                                          // Put the string "expression" as an atom in h0. Expression itself is not used by Prolog.

    /* Call Prolog and execute the function. */
    int ret_val = PL_call_predicate(NULL, PL_Q_NORMAL, pred, h0);               // Call pred with input h0, and return the ret_val, with NULL context module and normal flags

    PL_halt(ret_val ? 0 : 1);                                                   // Close Prolog (return 0 if good, or return 1 if error)

  return 0;
}