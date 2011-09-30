(*

Andrew Pennebaker
30 Sep 2011

Requires Getopt.
http://alain.frisch.fr/soft.html#Getopt

Compile:

ocamlfind ocamlc -package str,getopt -linkpkg -o ios7crypt ios7crypt.ml

Run:

./ios7crypt [options]

*)

open Getopt

type mode = Encrypt | Decrypt | Help | Test

let mode = ref Help
and password = ref ""
and hash = ref ""

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
		Encrypt -> print_endline ("Encrypting " ^ !password ^ "...") |
		Decrypt -> print_endline ("Decrypting " ^ !hash ^ "...") |
		Test -> print_endline "Testing..."

let _ =
	let program = Sys.argv.(0)
	and re = Str.regexp "ios7crypt" in
		try let _ = Str.search_forward re program 0 in
			main program
		with Not_found -> ()