(*

Andrew Pennebaker
30 Sep 2011

Requirements:

 * Getopt (http://alain.frisch.fr/soft.html#Getopt)
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
module ArbString = Arbitrary_string ;;

module C = Check(Testable_fun (ArbString) (PShow_string) (Testable_bool))

let test () = C.quickCheck prop_reversible

let specs = [
	('e', "encrypt", None, Some (fun v -> mode := Encrypt; password := v));
	('d', "decrypt", None, Some (fun v -> mode := Decrypt; hash := v));
	('h', "help", (set mode Help), None);
	('t', "test", (set mode Test), None)
]

let usage program : string -> unit =
	print_endline ("Usage: " ^ program ^ " [options]");
	print_endline "-e --encrypt <password>\tEncrypt a password";
	print_endline "-d --decrypt <hash>\tDecrypt a hash";
	print_endline "-t --test\t\tRun unit tests";
	print_endline "-h --help\t\tUsage info"

let main program : string -> unit =
	parse_cmdline specs print_endline;

	match !mode with
		Help -> usage program |
		Encrypt -> print_endline (encrypt !password) |
		Decrypt -> print_endline (decrypt !hash) |
		Test -> print_endline (test ())

let _ =
	let program = Sys.argv.(0)
	and re = Str.regexp "ios7crypt" in
		try let _ = Str.search_forward re program 0 in
			main program
		with Not_found -> ()