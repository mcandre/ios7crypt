#!/usr/bin/env io

# From StackOverflow
# http://stackoverflow.com/questions/4255123/how-do-i-convert-a-string-to-a-list-in-io/4256258#4256258
Sequence asList := method(
	result := list()
	self foreach(x,
		result append(x)
	)
)

IOS7Crypt := Object clone

IOS7Crypt XlatPrime := list(
	0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
	0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
	0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
	0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
	0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
	0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
	0x3b, 0x66, 0x67, 0x38, 0x37
)

IOS7Crypt Xlat := method(i, len,
	if(len < 1,
		list(),
		list(IOS7Crypt xlatPrime at(i % (xlatPrime size))) appendSeq(xlat (i + 1) (len - 1))
	)
)

IOS7Crypt Encrypt := method(password,
	seed := Random value(16) floor

	keys := Xlat(seed, password size)

	plaintext := password asList map(c, c(0))

	# ...

	"01234"
)

IOS7Crypt Decrypt := method(hash,
	# ...

	"monkey"
)

IOS7Crypt Test := method(
	# ...

	"success"
)

usage := method(program,
	"Usage: #{program} [options]" interpolate println
	"-e=<password>\tEncrypt" println
	"-d=<hash>\tDecrypt" println
	"-t\t\tUnit test" println
	"-h\t\tUsage info" println
)

main := method(
	mode := "encrypt"
	password := ""
	hash := ""

	args := System args
	program := args removeFirst

	if(args size < 1,
		usage(program)
	)

	valid := list("-e", "-d", "-t")

	options := System getOptions(args)
	options foreach(k, v,
		if(k == "-e",
			mode := "encrypt"
			if(v == nil,
				usage(program),
				password := v
			)
		)
		if(k == "-d",
			mode := "decrypt"
			if(v == nil,
				usage(program),
				hash := v
			)
		)
		if(k == "-t",
			mode := "test"
		)
		if(valid contains(k) not,
			usage(program)
		)
	)

	if(mode == "encrypt",
		IOS7Crypt Encrypt(password) println
	)
	if(mode == "decrypt",
		IOS7Crypt Decrypt(hash) println
	)
	if(mode == "test",
		IOS7Crypt Test
	)
)

if (System args size > 0 and System args at(0) containsSeq("IOS7Crypt"), main)