(*

Andrew Pennebaker
30 Sep 2011

Requirements:

 * Getopt (https://github.com/mcandre/ocaml-getopt)
 * QuickCheck (https://github.com/camlunity/ocaml-quickcheck)

*)

open Getopt
open QuickCheck

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
		[List.nth xlat' (i mod (List.length xlat'))] @ (xlat (i + 1) (len - 1))

(* Seed the random number generator. *)
let _ = Random.self_init ()

(*
From OCaml FAQ: What is the equivalent of explode : string -> char list and the converse implode : char list -> string ?
http://caml.inria.fr/pub/old_caml_site/FAQ/FAQ_EXPERT-eng.html#strings
*)

let explode s =
	let rec exp i l =
		if i < 0 then l else exp (i - 1) (s.[i] :: l) in
			exp (String.length s - 1) []

let implode l =
	let res = String.create (List.length l) in
	let rec imp i = function
		| [] -> res
		| c :: l -> res.[i] <- c; imp (i + 1) l in
			imp 0 l

let encrypt password =
	let seed = Random.int 16 in
	let keys = xlat seed (String.length password) in
	let plaintext = List.map Char.code (explode password) in
	let ciphertext = List.map2 (lxor) plaintext keys in
		(Printf.sprintf "%02d" seed) ^ (String.concat "" (List.map (Printf.sprintf "%02x") ciphertext))

let rec only_pairs text = [String.sub text 0 2] @ if String.length text <= 3 then
		[]
	else
		only_pairs (String.sub text 2 (String.length text - 2))

let decrypt hash =
	if String.length hash < 4 then
		Some ""
	else
		try
			let s = int_of_string (String.sub hash 0 2) in
			let keys = xlat s ((String.length hash - 2) / 2) in
			let ciphertext = List.map (fun x -> int_of_string ("0x" ^ x)) (only_pairs (String.sub hash 2 (String.length hash - 2))) in
			let plaintext = List.map2 (lxor) keys ciphertext in
			Some (implode (List.map (Char.chr) plaintext))
		with Failure "int_of_string" -> None

let prop_reversible password =
	decrypt (encrypt password) = Some password

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
		Decrypt -> (match decrypt !hash with
			Some password -> print_endline password |
			_ -> print_endline "Invalid hash.") |
		Test -> test ()

let _ =
	let program = Sys.argv.(0)
	and re = Str.regexp "ios7crypt" in
		try let _ = Str.search_forward re program 0 in
			main program
		with Not_found -> ()