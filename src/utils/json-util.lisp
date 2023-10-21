(defpackage json-util
  (:use :cl))
(in-package :rest-api)

(defun make-json-object-key-value (key value) 
  (yason:with-output-to-string* ()
    (yason:with-object ()
      (yason:encode-object-element key value))))

(defun encode-if-not-nil (entity)
  `(let ((element ,entity))
     (if (eq element nil)
         (make-json-object-key-value
          "error" "entity not found")
         element)))

