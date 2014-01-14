#!/bin/bash
#|
exec clisp -q -q $0 $0 ${1+"$@"}
exit
|#

;;;; IOS7Crypt
;;;;
;;;; Andrew Pennebaker
;;;; andrew.pennebaker@gmail.com
;;;; 1 Dec 2010
;;;;
;;;; Requirements:
;;;;  - Quicklisp
;;;;  - getopt
;;;;  - cl-quickcheck

;;; Hide stupid Quicklisp warnings
(handler-bind ((warning #'muffle-warning))
  ;;; Load Quicklisp.
  (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
    (when (probe-file quicklisp-init)
      (load quicklisp-init))))

;;; Hide stupid warnings from dependencies
(handler-bind ((warning #'muffle-warning))
  ;;; Load dependencies.
  (asdf:oos 'asdf:load-op 'getopt :verbose nil)
  (asdf:oos 'asdf:load-op 'cl-quickcheck :verbose nil)
  (use-package :cl-quickcheck))

(defparameter *xlat*
  (list #x64 #x73 #x66 #x64 #x3b #x6b #x66 #x6f
        #x41 #x2c #x2e #x69 #x79 #x65 #x77 #x72
        #x6b #x6c #x64 #x4a #x4b #x44 #x48 #x53
        #x55 #x42 #x73 #x67 #x76 #x63 #x61 #x36
        #x39 #x38 #x33 #x34 #x6e #x63 #x78 #x76
        #x39 #x38 #x37 #x33 #x32 #x35 #x34 #x6b
        #x3b #x66 #x67 #x38 #x37))

;;; Initialize random-state.
(setq *random-state* (make-random-state t))

(defun key (seed len)
  (loop for i from 0 to (- len 1) collect
    (nth (mod (+ seed i) (length *xlat*)) *xlat*)))

; From Pascal Costanza
; http://coding.derkeiler.com/Archive/Lisp/comp.lang.lisp/2007-11/msg00971.html
(defun string-join (list &optional (delim ""))
  (with-output-to-string (s)
   (when list
    (format s "~a" (first list))
    (dolist (element (rest list))
    (format s "~a~a" delim element)))))

(defun only-pairs (text)
  (let ((len (length text)))
    (cond ((< len 2) (list ""))
          ((equal len 2) (list text))
          ((equal len 3) (list (subseq text 0 2)))
          (t (cons (subseq text 0 2)
                   (only-pairs (subseq text 2 len)))))))

(defun string-truncate (s n)
  (if (<= (length s) n)
      s
      (subseq s 0 n)))

(defun ios7-encrypt (password)
  (let* ((seed (random 16))
        (p (map 'list
                #'char-code
                (string-truncate password 11)))
        (k (key seed (length p))))
    (concatenate 'string
                 (format nil "~2,'0d" seed)
                 (string-join (map 'list
                              #'(lambda (x) (format nil "~(~2,'0x~)" x))
                              (mapcar #'logxor p k))))))

(defun ios7-decrypt (hash)
  (if (< (length hash) 4)
      ""
      (let* ((seed (parse-integer (subseq hash 0 2) :radix 10))
             (h (map 'list
                     #'(lambda (x) (parse-integer x :radix 16))
                     (only-pairs (subseq hash 2 (length hash)))))
             (k (key seed (length h))))
        (map 'string #'code-char (mapcar #'logxor h k)))))

(defun prop-reversible (password)
  (equalp (ios7-decrypt (ios7-encrypt password)) (string-truncate password 11)))

(defun test-prop-reversible ()
  (quickcheck (for-all ((p #'a-string))
    (test (prop-reversible p)))))

(defun ios7-usage (program)
  (format t "~&Usage: ~a~%" program)
  (format t "--encrypt -e <password>~%")
  (format t "--decrypt -d <hash>~%")
  (format t "--test -t~%")
  (format t "--help -h~%")

  (quit))

(defun string-assoc-get (key lst default)
  (let* ((entry (assoc key lst :test #'equal))
         (value (cdr entry)))
    (if entry
        (if value value t)
        default)))

(defun ios7-main (args)
  (multiple-value-bind (free argp) (getopt:getopt args '(("encrypt" :required)
                                                        ("decrypt" :required)
                                                        ("test" :none)
                                                        ("help" :none)))

    (if (member '("help") argp :test #'equal)
        (ios7-usage (car args)))

    (let* ((encrypt-command (string-assoc-get "encrypt" argp nil))
           (decrypt-command (string-assoc-get "decrypt" argp nil))
           (test-command (string-assoc-get "test" argp nil)))

      (cond (encrypt-command (format t "~a~%" (ios7-encrypt encrypt-command)))
            (decrypt-command (format t "~a~%" (ios7-decrypt decrypt-command)))
            (test-command (test-prop-reversible))
            (t (ios7-usage (car args))))

      (quit))))

;;; With help from Francois-Rene Rideau
;;; http://tinyurl.com/cli-args
(let ((args
       #+clisp ext:*args*
       #+sbcl sb-ext:*posix-argv*
       #+clozure (ccl::command-line-arguments)
       #+gcl si:*command-args*
       #+ecl (loop for i from 0 below (si:argc) collect (si:argv i))
       #+cmu extensions:*command-line-strings*
       #+allegro (sys:command-line-arguments)
       #+lispworks sys:*line-arguments-list*
     ))

  (if (member (pathname-name *load-truename*)
              args
              :test #'(lambda (x y) (search x y :test #'equalp)))
    (ios7-main args)))
