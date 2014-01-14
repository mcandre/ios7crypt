#!/usr/bin/env jconsole

load 'regex'

NB. Seed RNG with current time
NB. With help from Henry Rich.
ymdhmstojsec =. 13 : '0 24 60 60 #. ({: 3 {. y) , 3 }. y'
9!:0 ymdhmstojsec 6!:0 ''

xlatPrime =: 16b64 16b73 16b66 16b64 16b3b 16b6b 16b66 16b6f 16b41 16b2c 16b2e 16b69 16b79 16b65 16b77 16b72 16b6b 16b6c 16b64 16b4a 16b4b 16b44 16b48 16b53 16b55 16b42 16b73 16b67 16b76 16b63 16b61 16b36 16b39 16b38 16b33 16b34 16b6e 16b63 16b78 16b76 16b39 16b38 16b37 16b33 16b32 16b35 16b34 16b6b 16b3b 16b66 16b67 16b38 16b37

empty =: 0 $ 0

NB. index xlat len

xlat =: dyad : 0
	if. y < 1 do.
		empty
	elseif. 1 do.
		h =. ((#xlatPrime) | x) { xlatPrime
		t =. (x + 1) xlat (y - 1)

		h, t
	end.
)

xor =: 22 b.

NB. With help from Alan Stebbens and Bjorn Helgason.
hex =: [: ; [: > 1 # '0123456789abcdef' {~ 16 16 #: ]
dec =: [: ; [: > 1 # '0123456789' {~ 10 10 #: ]

NB. With help from Raul Miller.
join =: #@[ }. [:;,L:0

encrypt =: monad : 0
	seed =. ? 16

	plaintext =. 3 u: 7 u: y
	keys =. seed xlat (#plaintext)

	ciphertext =. plaintext xor keys

	'' join ((dec seed), (hex ciphertext))
)

NB. With help from Raul Miller
split =: <;._1@,

main =: monad : 0
	password =. 'monkey'
	hash =. encrypt password

	echo hash

	NB. ...

	exit ''
)

program =: monad : 0
	if. (#ARGV) > 1 do.
		> 1 { ARGV
	else.
		'Interpreted'
	end.
)

shouldrun =: monad : 0
	if. '.*ios7crypt.*' rxeq program 0 do.
		main 0
	end.
)

shouldrun 0