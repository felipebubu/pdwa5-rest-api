(defpackage admin-controller
  (:use :cl))
(in-package :rest-api)

(setf (ningle:route *app* "/admin/sign-up" :method :POST)
      #'(lambda (params)
          (user-create params)))

(setf (ningle:route *app* "/admin/users" :method :GET)
      #'(lambda (params)
          (yason:with-output-to-string* () (yason:encode-object (user-read params)))))