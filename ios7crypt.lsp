#!/usr/bin/env newlisp

;; Andrew Pennebaker
;; 31 Dec 2008 - 24 Mar 2009

(context 'IOS7)

(seed (date-value))

(setf *xlat* '(
	0x64 0x73 0x66 0x64 0x3b 0x6b 0x66 0x6f
	0x41 0x2c 0x2e 0x69 0x79 0x65 0x77 0x72
	0x6b 0x6c 0x64 0x4a 0x4b 0x44 0x48 0x53
	0x55 0x42 0x73 0x67 0x76 0x63 0x61 0x36
	0x39 0x38 0x33 0x34 0x6e 0x63 0x78 0x76
	0x39 0x38 0x37 0x33 0x32 0x35 0x34 0x6b
	0x3b 0x66 0x67 0x38 0x37))

(define (IOS7:encrypt password)
	(if (not password) ""
		(begin
			(setf s (rand 16))

			;; truncate
			(setf password (0 11 password))

			;; convert to ASCII values
			(setf password (map char (explode password)))

			;; XOR each password byte with a corresponding byte in the translation table
			(setf hash '())
			(for (i 0 (- (length password) 1))
				(setf hash (append hash (list (^ (*xlat* (% (+ s i) (length *xlat*))) (password i))))))

			;; format bytes in hexadecimal
			(format "%02d%s" s (join (map (lambda (e) (format "%02x" e)) hash) "")))))

(define (IOS7:decrypt hash)
	(if (not hash) ""
		(begin
			(setf s (0 2 hash))

			;; lisp doesn't like initial zero
			(if (= (s 0) "0") (setf s (s 1)))

			(setf s (int s))

			;; segment pure hash
			(setf hash (2 (- (length hash) 2) hash))

			;; remove odd ending
			(if (!= (% (length hash) 2) 0) (setf hash (chop hash)))

			;; split and parse hex pairs
			(setf hash (map (lambda (e) (int (append "0x" e))) (explode hash 2)))

			;; XOR each hash byte with a corresponding byte in the translation table
			(setf password '())
			(for (i 0 (- (length hash) 1))
				(setf password (append password (list (^ (*xlat* (% (+ s i) (length *xlat*))) (hash i))))))

			;; format bytes in ASCII
			(join (map char password) ""))))

(define (usage program)
	(println (append "Usage: " program " [options]"))
	(println "-e <password>")
	(println "-d <hash>")
	(exit))

(define (main)
	(setf program (main-args 1))

	(if (not (main-args 3)) (usage program)
	(case (main-args 2)
		("-e" (println (IOS7:encrypt (main-args 3))))
		("-d" (println (IOS7:decrypt (main-args 3))))
		(true (usage program))))

	(exit))

(if (find "ios7crypt" (main-args 1)) (main))

(context MAIN)