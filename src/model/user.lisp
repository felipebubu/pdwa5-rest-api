(defpackage user
  (:use :cl))
(in-package :rest-api)

(mito:deftable user ()
  ((id :col-type (or (:integer) :null) 
       :auto-increment t
       :acessor user-id)
   (name :col-type (:varchar 64)
         :accessor user-name)
   (email :col-type (:varchar 64)
         :acessor user-email)
   (password :col-type (:varchar 1000)
             :acessor user-password)
   (status :col-type (:bool)
           :acessor user-status)
   (kind :col-type (:varchar 64)
         :acessor user-kind))
  (:primary-key id)
  (:auto-pk nil))

(defmethod yason:encode-slots progn ((user user))
  (yason:encode-object-element "name" (user-name user))
  (yason:encode-object-element "email" (user-email user))
  (yason:encode-object-element "password" (user-status user))
  (yason:encode-object-element "status" (user-status user))
  (yason:encode-object-element "kind" (user-status user)))

(mito:table-definition 'user)