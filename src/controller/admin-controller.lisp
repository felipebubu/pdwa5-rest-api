(defpackage admin-controller
  (:use :cl))
(in-package :rest-api)

(setf (ningle:route *app* "/admin/login" :method :POST)
      #'(lambda (params)
          (format nil "~A" (admin-login params))))

(setf (ningle:route *app* "/admin/users" :method :GET)
      #'(lambda (params)
          (declare (ignore params))
          (with-logged-as-admin
              (yason:with-output-to-string* () 
                (yason:encode (admin-get-users))))))