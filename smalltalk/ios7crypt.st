"exec" "gst" "-f" "$0" "$0" "$@"

"Requires quicksmash."
"https://github.com/mcandre/quicksmash"

PackageLoader fileInPackage: 'QuickSmash'.

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
		| seed hash ciphertext |

		seed := random between: 0 and: 15.

		hash := seed printString.

		[ hash size < 2 ] whileTrue: [
			hash := '0', hash.
		].

		ciphertext := 0 to: (password size - 1) collect: [ :i |
			| plainbyte keybyte cipherbyte formatted |

			plainbyte := password byteAt: (i + 1).

			keybyte := xlat byteAt: (((seed + i) \\ xlat size) + 1).

			cipherbyte := plainbyte bitXor: keybyte.

			formatted := (cipherbyte printString: 16) asLowercase.

			[ formatted size < 2] whileTrue: [
				formatted := '0', formatted.
			].

			formatted.
		].

		hash := hash, (ciphertext join: '').

		^hash
	]

	IOS7Crypt class >> decrypt: hash [
		| seed hashbytes password |

		seed := hash copyFrom: 1 to: 2.
		seed := Number readFrom: (ReadStream on: seed) radix: 10.

		hashbytes := hash copyFrom: 3.

		((hashbytes size) odd) ifTrue: [
			hashbytes := hashbytes copyFrom: 1 to: (hashbytes size - 1).
		].

		hashbytes := 1 to: (hashbytes size) by: 2 collect: [ :i |
			| h |

			h := hashbytes copyFrom: i to: (i + 1).
			h := Number readFrom: (ReadStream on: h) radix: 16.
		].

		password := 0 to: (hashbytes size - 1) collect: [ :i |
			| cipherbyte keybyte plainbyte |

			cipherbyte := hashbytes at: (i + 1).
			keybyte := xlat byteAt: (((seed + i) \\ xlat size) + 1).

			plainbyte := cipherbyte bitXor: keybyte.
		].

		password := (password asByteArray) asString.

		^password
	]

	IOS7Crypt class >> test [
		| propReversible result |

		propReversible := [ :password | password = (IOS7Crypt decrypt: (IOS7Crypt encrypt: password)). ].

		result := QuickSmash testProperty: propReversible withGenerators: { [ QuickSmash genString. ] }.

		^result
	]
]

| main |

main := [
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
].

(((Smalltalk getArgc) > 0) and: [ ((Smalltalk getArgv: 1) endsWith: 'ios7crypt.st') ]) ifTrue: [
	main value.
].
