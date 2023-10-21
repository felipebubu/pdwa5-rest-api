(defpackage admin
  (:use :cl))
(in-package :rest-api)

(mito:deftable admin ()
  ((start-date :col-type (:datetime))
   (area-of-expertise :col-type (or (:varchar 64) :null))
   (user-id :references user)))

(mito:table-definition 'admin)