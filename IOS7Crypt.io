#!/usr/bin/env io

# ...

main := method(
	args := System args
	args removeFirst

	options := System getOptions(args)
	options foreach(k, v,
		"Key: #{k} Value: #{v}" interpolate println
	)

	# ...
)

if (System args size > 0 and System args at(0) containsSeq("IOS7Crypt"), main)