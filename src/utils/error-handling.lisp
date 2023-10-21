(defpackage error-handling
  (:use :cl))
(in-package :rest-api)

(defmacro with-database-error-handling (&body body)
  `(handler-case (progn ,@body)
     (error (database-error)
       (setf (lack.response:response-status ningle:*response*) 500)
       (make-json-object-key-value
        "error" (format nil "~A" database-error)))))

(defun auth-error ()
  (setf (lack.response:response-status ningle:*response*) 401)
  (make-json-object-key-value 
   "error" "only admins may read and update other users settings"))

(defun no-admin-error ()
  (setf (lack.response:response-status ningle:*response*) 401)
  (make-json-object-key-value
   "error" "you must be logged as an admin"))

(defmacro with-check-if-user-exists (entity)
  `(if (eq ,entity nil)
       (make-json-object-key-value
        "error" "entity not found")
       ,entity))

(defun encode-if-not-nill)