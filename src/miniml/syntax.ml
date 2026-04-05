(* Abstract syntax. *)

(* Variable names *)
type name = string

(* Types *)
type ty =
  | TInt              (* Integers *)
  | TBool             (* Booleans *)
  | TArrow of ty * ty (* Functions *)
  | TExn              (* Exceptions *)

(* Constructor with contains different types of exceptions *)
type exn = 
  | DivisionByZero
  | GenericException of int 

(* Expressions *)
type expr = expr' Zoo.located
and expr' =
  | Var of name          		(* Variable *)
  | Int of int           		(* Non-negative integer constant *)
  | Bool of bool         		(* Boolean constant *)
  | Times of expr * expr 		(* Product [e1 * e2] *)
  | Plus of expr * expr  		(* Sum [e1 + e2] *)
  | Minus of expr * expr 		(* Difference [e1 - e2] *)
  | Division of expr * expr             (* Division [e1/e2], may result in [Abort] *)
  | Equal of expr * expr 		(* Integer comparison [e1 = e2] *)
  | Less of expr * expr  		(* Integer comparison [e1 < e2] *)
  | If of expr * expr * expr 		(* Conditional [if e1 then e2 else e3] *)
  | Try of expr * (exn * expr) list  (* Exception handling e1 with exception e and e2*)
  | Raise of exn                      (* Raising an exception *)
  | Fun of name * name * ty * ty * expr (* Function [fun f(x:s):t is e] *)
  | Apply of expr * expr 		(* Application [e1 e2] *)


(* Toplevel commands *)
type command =
  | Expr of expr       (* Expression *)
  | Def of name * expr (* Value definition [let x = e] *)
