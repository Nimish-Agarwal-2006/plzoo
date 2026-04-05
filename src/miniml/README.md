An implementation of an eager statically typed functional language with
a compiler and an abstract machine.

The language has the following constructs:

* Integers with arithmetic operations `+`, `-` and `*`.
* Booleans with conditional statement and comparison of integers
  `=` and `<`.
* Recursive functions and function application. The expression

        fun f (x : t) : s is e

  denotes a function of type `t -> s` which maps `x` to `e`. In `e`
  the function refers to itself as `f`.

* Toplevel definitions

        let x = e

  There are no local definitions.

Example interaction, see also the file `example.miniml`:

    MiniML. Press Ctrl-D to exit.
    MiniML> 3 + (if 5 < 6 then 10 else 100) ;;
    - : int = 13
    MiniML> let x = 14 ;;
    x : int = 14
    MiniML> let fact = fun f (n : int) : int is if n = 0 then 1 else n * f (n-1) ;;
    fact : int -> int = <fun>
    MiniML> fact 10 ;;
    - : int = 3628800
    MiniML>
    Good bye.

Now, added division `/` with exception handling for SDF_Project 2 :
  ## New features 
               -> try{...}with{|...->... |...->...}
               -> Exceptions : DivisionByZero
                             : GenericException -1 for Type_errors
               -> raise e where e is an exception.
  ## Limitations  : 
    Currently to add this features, we had to remove the static type checking in miniml.
    Which may in turn may break the code with errors. 
    And, try with would not be able to catch the generic exception since I have not added the required methodes to raise an exception thus will result in fatal errors. 
  
  ## Example testing :
       miniML> try{1/0}with{|GenericException -1 -> 1 |DivisionByZero -> 0};;
        - : int = 0
       miniML> try{1/true}with{|GenericException -1 -> 1 |DivisionByZero -> 0};;
        - : int = 1
       miniML> raise GenericException -1;;
        - : Exception = Generic exception -1

  ## Key learning :
      Understanding of how a programming language works. 
      Key understanding of what lexer and parser does
      How to define new types in syntax and grammars 
      How to create and execute instructuons in frames and stacks.
  
  ## Reference :
      Miniml_error : Helped with the addition of division and raise but gave a good foundation with how to go around exceptions 