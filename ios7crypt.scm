#!/bin/sh
#|
exec csi -ss $0 ${1+"$@"}
exit
|#

(use cluckcheck)
(use fmt)

(use posix)
(use srfi-1) ; lists
(use srfi-13) ; strings
(import extras) ; random

(define (xlat-prime) '(
	#x64 #x73 #x66 #x64 #x3b #x6b #x66 #x6f
	#x41 #x2c #x2e #x69 #x79 #x65 #x77 #x72
	#x6b #x6c #x64 #x4a #x4b #x44 #x48 #x53
	#x55 #x42 #x73 #x67 #x76 #x63 #x61 #x36
	#x39 #x38 #x33 #x34 #x6e #x63 #x78 #x76
	#x39 #x38 #x37 #x33 #x32 #x35 #x34 #x6b
	#x3b #x66 #x67 #x38 #x37))

(define (xlat i len)
	(if (< len 1)
		'()
		(cons
			(list-ref (xlat-prime) (modulo i (length (xlat-prime))))
			(xlat (+ i 1) (- len 1)))))

(define (encrypt password)
	(let* (
		(seed (random 16))
		(keys (xlat seed (string-length password)))
		(plaintext (map char->integer (string->list password)))
		(ciphertext (map bitwise-xor keys plaintext)))
			(string-append
				(fmt #f (pad 2 "0" (num seed 10)))
				(string-join
					(map (lambda (x) (string-downcase (fmt #f (pad 2 "0" (num x 16)))))
						ciphertext)
					""))))

(define (decrypt hash)
	"abc"

	; ...

	)

(define (reversible? password)
	(string=? password (decrypt (encrypt password))))

(define (test)
	(for-all reversible? gen-string))

(define (main args)
	(let* (
		(password "monkey")
		(hash (encrypt password))
		(password2 (decrypt hash)))
				(display (format "Encrypted: ~a\n" hash))
				(display (format "Decrypted: ~a\n" password2)))

	; ...

	(exit))

(define (program)
	(if (string=? (car (argv)) "csi")
		(let ((s-index (list-index (lambda (x) (string-contains x "-s")) (argv))))
			(if (number? s-index)
				(cons 'interpreted (list-ref (argv) (+ 1 s-index)))
				(cons 'unknown "")))
		(cons 'compiled (car (argv)))))

(if (equal? (car (program)) 'compiled)
	(main (cdr (argv))))