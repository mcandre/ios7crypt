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
open List

type mode = Encrypt | Decrypt | Help | Test

let mode = ref Help
and password = ref ""
and hash = ref ""

let xlat' : int list = [
	0x64; 0x73; 0x66; 0x64; 0x3b; 0x6b; 0x66; 0x6f;
	0x41; 0x2c; 0x2e; 0x69; 0x79; 0x65; 0x77; 0x72;
	0x6b; 0x6c; 0x64; 0x4a; 0x4b; 0x44; 0x48; 0x53;
	0x55; 0x42; 0x73; 0x67; 0x76; 0x63; 0x61; 0x36;
	0x39; 0x38; 0x33; 0x34; 0x6e; 0x63; 0x78; 0x76;
	0x39; 0x38; 0x37; 0x33; 0x32; 0x35; 0x34; 0x6b;
	0x3b; 0x66; 0x67; 0x38; 0x37
]

let rec xlat i len =
	if len < 1 then
		[]
	else
		append [nth xlat' (i mod (length xlat'))] (xlat (i + 1) (len - 1))

let encrypt password =
	password (* ... *)

let decrypt hash =
	hash (* ... *)

let prop_reversible password =
	decrypt (encrypt password) = password

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