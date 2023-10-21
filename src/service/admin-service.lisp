(defpackage admin-service
  (:use :cl))
(in-package :rest-api)

(defun admin-login (params)
  (let ((user-entity
          (mito:find-dao 'user :email 
                         (map-param-to-property "email" params))))
    (when (and (check-password
                (map-param-to-property "password" params) 
                (user-password user-entity))
               (string= (user-kind user-entity) "admin"))
      (jose:encode :hs256 *key* 
                   `(("id" . ,(user-id user-entity))
                     ("kind" . ,(user-kind user-entity))
                     ("has-logged-as-admin" . "true"))))))



(defun admin-create (user-id area-of-expertise)
  (mito:insert-dao
    (make-instance 'admin 
                   :area-of-expertise area-of-expertise
                   :user-id user-id
                   :start-date (local-time:format-timestring nil (local-time:now) :format '(:year "-" :month "-" :day)))))

(defun admin-get-users ()
  (mito:retrieve-dao 'user))