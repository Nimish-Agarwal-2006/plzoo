(** Type checking. *)

open Syntax
exception Type_error

let typing_error ~loc = Zoo.error ~kind:"Type error" ~loc

(** [check ctx ty e] verifies that expression [e] has type [ty] in
    context [ctx]. If it does, it returns unit, otherwise it raises the
    [Type_error] exception. *)

    let rec check ctx ty (e) =
      let ty' = type_of ctx e in
        if ty' <> ty then
          raise Type_error

(** [type_of ctx e] computes the type of expression [e] in context
    [ctx]. If [e] does not have a type it raises the [Type_error]
    exception. *)
and type_of ctx {Zoo.data=e; loc} =
  match e with
    | Var x ->
      (try List.assoc x ctx with
	  Not_found -> typing_error ~loc "unknown variable %s" x)
    | Int _ -> TInt
    | Bool _ -> TBool
    (* try ... with Type_error rasies a TExp which in machine is dynamically raised as Exception = GenericException -1 but it is not implemented for functions *)
    | Division (e1, e2) -> (try check ctx TInt e1 ; check ctx TInt e2 ; TInt with Type_error -> TExn )
    | Times (e1, e2) -> (try check ctx TInt e1 ; check ctx TInt e2 ; TInt with Type_error -> TExn )
    | Plus (e1, e2) -> (try check ctx TInt e1 ; check ctx TInt e2 ; TInt with Type_error -> TExn )
    | Minus (e1, e2) -> (try check ctx TInt e1 ; check ctx TInt e2 ; TInt with Type_error -> TExn )
    | Equal (e1, e2) -> (try check ctx TInt e1 ; check ctx TInt e2 ; TBool with Type_error -> TExn )
    | Less (e1, e2) -> (try check ctx TInt e1 ; check ctx TInt e2 ; TBool with Type_error -> TExn )
    | If (e1, e2, e3) ->( try
      check ctx TBool e1 ;
      let ty = type_of ctx e2 in
	check ctx ty e3 ; ty with
      Type_error -> TExn)
    (* This ensures that if e1 raises a Type_error then the system doesnt interupts *)
    | Try (e1, cases) ->(try
       let ty = type_of ctx e1 in
      let rec aux cases = match cases with
      | []-> ty
      | (_, exp) :: tl -> check ctx ty exp ; aux tl
    in aux cases 
  with Type_error -> TInt)
    | Raise _ -> TExn
    | Fun (f, x, ty1, ty2, e) ->
      check ((f, TArrow(ty1,ty2)) :: (x, ty1) :: ctx) ty2 e ;
      TArrow (ty1, ty2)
    | Apply (e1, e2) ->
      begin match type_of ctx e1 with
	  TArrow (ty1, ty2) -> check ctx ty1 e2 ; ty2
	| ty ->
	  typing_error ~loc
            "this expression is used as a function but its type is %t" (Print.ty ty)
      end
