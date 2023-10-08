(defpackage auth-service
  (:use :cl))
(in-package :rest-api)

(defun authenticate (request) 
  (handler-case 
      (jose:decode :hs256 *key* 
                   (gethash "authorization" 
                            (getf 
                             (lack.request:request-env request) 
                             :headers)))
    (error ()
      nil)))

(defmacro with-authentication (request &body body)
  `(if (authenticate ,request)
       (progn ,@body)
       (make-json-object-key-value "error" "invalid token")))

(defmacro with-user-permission-validation (request params &body body)
  `(let ((jwt (authenticate ,request)))
     (if (or (string= 
              (write-to-string (cdr (assoc "id" jwt :test #'string=))) 
                (cdr (assoc :id ,params)))
             (eq (cdr (assoc "kind" jwt :test #'string=)) "admin"))
          (progn ,@body)
          (make-json-object-key-value 
           "error" "only admins may update other users settings"))))