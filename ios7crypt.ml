(*

Andrew Pennebaker
30 Sep 2011

Requirements:

 * Getopt (https://github.com/mcandre/ocaml-getopt)
 * QuickCheck (https://github.com/camlunity/ocaml-quickcheck)

Compile:

ocamlfind ocamlc -package str,getopt,quickcheck -linkpkg -o ios7crypt ios7crypt.ml

Run:

./ios7crypt [options]

*)

open Getopt
open QuickCheck

type mode = Encrypt | Decrypt | Help | Test

let mode = ref Help
and password = ref ""
and hash = ref ""

let encrypt : string -> string =
	fun password -> password (* ... *)

let decrypt : string -> string =
	fun hash -> hash (* ... *)

let prop_reversible : string -> bool =
	fun password -> decrypt (encrypt password) = password

(* for generating random strings *)
let arbstring = arbitrary_string

(* for printing out strings *)
let showstring = show_string

(* for being able to test (string -> bool) *)
let testable_string_to_bool = testable_fun arbstring showstring testable_bool

let test () = quickCheck testable_string_to_bool prop_reversible

let specs = [
	('e', "encrypt", None, Some (fun v -> mode := Encrypt; password := v));
	('d', "decrypt", None, Some (fun v -> mode := Decrypt; hash := v));
	('h', "help", (set mode Help), None);
	('t', "test", (set mode Test), None)
]

let usage program =
	print_endline ("Usage: " ^ program ^ " [options]");
	print_endline "-e --encrypt <password>\tEncrypt a password";
	print_endline "-d --decrypt <hash>\tDecrypt a hash";
	print_endline "-t --test\t\tRun unit tests";
	print_endline "-h --help\t\tUsage info"

let main program =
	parse_cmdline specs print_endline;

	match !mode with
		Help -> usage program |
		Encrypt -> print_endline (encrypt !password) |
		Decrypt -> print_endline (decrypt !hash) |
		Test -> test ()

let _ =
	let program = Sys.argv.(0)
	and re = Str.regexp "ios7crypt" in
		try let _ = Str.search_forward re program 0 in
			main program
		with Not_found -> ()