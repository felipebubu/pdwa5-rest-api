(defpackage rest-api
  (:use :cl))
(in-package :rest-api)

(mito:connect-toplevel :sqlite3 :database-name "rest-api.db")
(setf mito:*auto-migration-mode* t)
(setf mito:*migration-keep-temp-tables* nil)
(defvar *app* (make-instance 'ningle:app))

(defvar *key* (ironclad:ascii-string-to-byte-array "secret"))

(defvar *token* 
  (jose:encode :hs256 *key* '(("hello" . "world"))))

(setf (ningle:route *app* "/")
      "Welcome to ningle!")

(clack:clackup *app*)


;; blah blah blah.
