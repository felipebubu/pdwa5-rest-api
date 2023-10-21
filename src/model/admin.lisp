(defpackage admin
  (:use :cl))
(in-package :rest-api)

(mito:deftable admin ()
  ((start-date :col-type (:datetime))
   (area-of-expertise :col-type (:varchar 64))
   (user-id :references user)))

(mito:table-definition 'admin)