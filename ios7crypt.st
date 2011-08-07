"exec" "gst" "-f" "$0" "$0" "$@"
"exit"

Object subclass: IOS7Crypt [
	| random xlat |

	random := Random new.

	xlat := #[
		16r64 16r73 16r66 16r64 16r3B 16r6B 16r66 16r6F
		16r41 16r2C 16r2E 16r69 16r79 16r65 16r77 16r72
		16r6B 16r6C 16r64 16r4A 16r4B 16r44 16r48 16r53
		16r55 16r42 16r73 16r67 16r76 16r63 16r61 16r36
		16r39 16r38 16r33 16r34 16r6E 16r63 16r78 16r76
		16r39 16r38 16r37 16r33 16r32 16r35 16r34 16r6B
		16r3B 16r66 16r67 16r38 16r37
	].

	IOS7Crypt class >> xlat [ ^xlat ]

	IOS7Crypt class >> usage: program [
		Transcript
			show: 'Usage: ', program, ' [OPTIONS]'; cr;
			show: '-e <password> Encrypt'; cr;
			show: '-d <hash>     Decrypt'; cr;
			show: '-t            Run unit tests'; cr;
			show: '-h            Show usage'; cr.

		ObjectMemory quit: 0.
	]

	IOS7Crypt class >> encrypt: password [
		| seed hash cipherbytes |

		seed := random between: 0 and: 15.

		hash := seed printString.

		[ hash size < 2 ] whileTrue: [
			hash := '0', hash.
		].

		cipherbytes := 0 to: (password size - 1) collect: [ :i |
			| plainbyte keybyte cipherbyte ciphertext |

			plainbyte := password byteAt: (i + 1).

			keybyte := xlat byteAt: (((seed + i) \\ xlat size) + 1).

			cipherbyte := plainbyte bitXor: keybyte.

			ciphertext := (cipherbyte printString: 16) asLowercase.

			[ ciphertext size < 2] whileTrue: [
				ciphertext := '0', ciphertext.
			].

			ciphertext.
		].

		cipherbytes := cipherbytes join: ''.

		hash := hash, cipherbytes.

		^hash
	]

	IOS7Crypt class >> decrypt: hash [
		| password |

		"password := self collect: [ :c | c rot13 ]."

		password := 'Decrypting...'.

		^password
	]

	IOS7Crypt class >> test [
		| result |

		result := 'Testing...'.

		"..."

		^result
	]
]

[
	| prog args mode password hash |

	prog := Smalltalk getArgv: 1.

	"Drop the program name."
	args := (2 to: Smalltalk getArgc) collect: [ :i | Smalltalk getArgv: i. ].

	"(args size < 1) ifTrue: [ IOS7Crypt usage: prog. ]."

	Getopt parse: args with: '-e: -d: -t' do: [ :o :v |
		(o = $e) ifTrue: [ mode := #encrypt. password := v. ].
		(o = $d) ifTrue: [ mode := #decrypt. hash := v. ].
		(o = $t) ifTrue: [ mode := #test. ]
	] ifError: [ IOS7Crypt usage: prog. ].

	(mode = #encrypt) ifTrue: [
		Transcript show: (IOS7Crypt encrypt: password); cr.
	] ifFalse: [
		(mode = #decrypt) ifTrue: [
			Transcript show: (IOS7Crypt decrypt: hash); cr.
		] ifFalse: [
			(mode = #test) ifTrue: [
				IOS7Crypt test.
			] ifFalse: [
				IOS7Crypt usage: prog.
			].
		].
	].
	
] on: ExUserBreak do: [].