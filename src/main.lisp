(defpackage rest-api
  (:use :cl))
(in-package :rest-api)

(mito:connect-toplevel :sqlite3 :database-name "rest-api.db")
(setf mito:*auto-migration-mode* t)
(setf mito:*migration-keep-temp-tables* nil)

(defvar *key* (ironclad:ascii-string-to-byte-array "secret"))

(defvar *token* 
  (jose:encode :hs256 *key* '(("hello" . "world"))))

(defvar *app* (make-instance 'ningle:app))
(defun main () 
  (defvar *server* (clack:clackup *app*))

  (handler-case (bt:join-thread (find-if (lambda (th)
                                           (search "hunchentoot" (bt:thread-name th)))
                                         (bt:all-threads)))
    ;; Catch a user's C-c
    (#+sbcl sb-sys:interactive-interrupt
      #+ccl  ccl:interrupt-signal-condition
      #+clisp system::simple-interrupt-condition
      #+ecl ext:interactive-interrupt
      #+allegro excl:interrupt-signal
      () (progn
           (format *error-output* "Aborting.~&")
           (clack:stop *server*)
           (uiop:quit)))
    (error (c) (format t "Woops, an unknown error occured:~&~a~&" c))))