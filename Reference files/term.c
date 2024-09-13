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

    /*
    printf("\n");                                                               // Debug stuff being passed to C.
    printf("%d", sizeof(argv[1])/sizeof(int));
    printf("\n");
    printf("%d", argc);
    printf("\n");
    */

    char *program = argv[0];                                                        // Create a pointer to the input characters.
    char *plav[2];                                                                  // Create an array of pointers (the argument vector for Prolog).

    /* Input the arguments */
    FILE *argz = fopen("Input.praenuntio", "r");                            // Open the file
    
    if (argz == NULL)
    {
        printf("\nError: The Praenuntio was not heard!\n");                 // If the file could not be found, display an error message.
        return 0;
    }

    fseek(argz, 0, SEEK_END);                                               // Determine the length (for getting the amount of memory needed)
    long argsize = ftell(argz);                                             // Get the size of the file.
    fseek(argz, 0, SEEK_SET);                                               // Reset to start of file.

    char *string = malloc(argsize + 1);                                     // Allocate the memory

    char expression[argsize];                                               // Create new character array with enough room for all characters (Autosized).
    char *e = expression;                                                   // Move the pointer to this.

    fread(string, argsize, 1, argz);                                        // Read the data into string
    fclose(argz);                                                           // Close the file

    string[argsize] = 0;                                                    // C needs 0-terminated strings
    strcpy(e, string);                                                      // Copy the data from string to f

    free(string);                                                           // De-allocate the memory for string

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
    predicate_t pred = PL_predicate("traverseDownList", 2, "user");             // Call traverseDownList/2 with user settings.

    /* Define the argument(s) we wish to pass to the function(s). */
    term_t h0 = PL_new_term_refs(2);                                            // Create term h0.
    PL_put_atom_chars(h0, expression);                                          // Put the string "expression" as an atom in h0. Expression itself is not used by Prolog.
    
    /* Call Prolog and execute the function. */
    int ret_val = PL_call_predicate(NULL, PL_Q_NORMAL, pred, h0);               // Call pred with input h0, and return the ret_val, with NULL context module and normal flags

    PL_halt(ret_val ? 0 : 1);                                                   // Close Prolog (return 0 if good, or return 1 if error)

  return 0;
}