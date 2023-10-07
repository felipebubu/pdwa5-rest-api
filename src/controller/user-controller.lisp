(defpackage user-controller
  (:use :cl))
(in-package :rest-api)

(setf (ningle:route *app* "/user/sign-up" :method :POST)
      #'(lambda (params)
          (user-create params)))

(setf (ningle:route *app* "/user/:id" :method :GET)
      #'(lambda (params)
          (yason:with-output-to-string* () (yason:encode-object (user-read params)))))

(setf (ningle:route *app* "/user/login" :method :POST)
      #'(lambda (params)
          (format nil "~A" (user-login params))))

(setf (ningle:route *app* "/user/:id" :method :PUT)
      #'(lambda (params)
          (with-user-permission-validation ningle:*request* params
            (user-update params))))

(setf (ningle:route *app* "/user/:id" :method :DELETE)
      #'(lambda (params)
          (with-user-permission-validation ningle:*request*
              (user-soft-delete params))))