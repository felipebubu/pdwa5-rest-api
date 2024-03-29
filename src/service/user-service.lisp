(defpackage user-service
  (:use :cl))
(in-package :rest-api)

(defun map-param-to-property (param params)
  (cdr (assoc param params :test #'string=)))

(defun map-params-to-user (params)
  (make-instance 'user 
                 :name (map-param-to-property "name" params)
                 :email (map-param-to-property "email" params)
                 :password (hash-password 
                            (map-param-to-property "password" params))
                 :status "active"
                 :kind (map-param-to-property "kind" params)
                 :id (cdr (assoc :id params))))

(defun user-create (params)
  (let ((user (mito:insert-dao (map-params-to-user params))))
    (let ((user-created (mito:find-dao 'user :email (user-email user))))
      (if (string= (map-param-to-property "kind" params) "admin")
          (admin-create (user-id user-created) 
                        (map-param-to-property "area-of-expertise" params)))
      user-created)))

(defun user-read (params)
  (mito:find-dao 'user :id (cdr (assoc :id params))))

(defun user-update (params)
  (mito:update-dao (map-params-to-user params)))

(defun user-soft-delete (params)
  (let ((entity (mito:find-dao 'user :id (cdr (assoc :id params)))))
    (setf (slot-value entity 'status) "inactive")
    (mito:save-dao entity)))

(defun hash-password (password)
  (ironclad:pbkdf2-hash-password-to-combined-string (babel:string-to-octets password)))

(defun user-login (params)
  (let ((user-entity  
          (mito:find-dao 'user :email 
                         (map-param-to-property "email" params))))
    (when (check-password 
           (map-param-to-property "password" params) 
           (user-password user-entity))
      (jose:encode :hs256 *key* 
                   `(("id" . ,(user-id user-entity))
                     ("kind" . ,(user-kind user-entity)))))))