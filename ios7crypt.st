"exec" "gst" "-f" "$0" "$0" "$*"
"exit"

Object subclass: IOS7Crypt [
	IOS7Crypt class >> usage: program [
		Transcript
			show: 'Usage: ', program, ' [OPTIONS]'; cr;
			show: '-e <password> Encrypt'; cr;
			show: '-d <hash>     Decrypt'; cr;
			show: '-t            Run unit tests'; cr.
	]

	IOS7Crypt class >> e: password [
		| hash |

		"hash := self collect: [ :c | c rot13 ]."

		hash := 'Encrypting...'.

		^hash
	]

	IOS7Crypt class >> d: hash [
		| password |

		"password := self collect: [ :c | c rot13 ]."

		password := 'Decrypting...'.

		^password
	]

	IOS7Crypt class >> t: ignored [
		| result |

		result := 'Testing...'.

		"..."

		^result
	]
]

| prog args mode selector arguments result |

[
	prog := Smalltalk getArgv: 1.

	"Drop the program name."
	"The shebang joins the arguments; we must split them."
	args := (Smalltalk getArgv: 2) substrings: $ .

	[
		Getopt parse: args with: '-e: -d: -t' do: [ :opt :arg |
			selector := (opt asString, $: asString) asSymbol.
			arguments := { arg }.
		].
	] on: Error  do: [ IOS7Crypt usage: prog. ObjectMemory quit: 0. ].

	result := IOS7Crypt perform: selector withArguments: arguments.

	Transcript show: result; cr.
] on: ExUserBreak do: [].