(defpackage user-controller
  (:use :cl))
(in-package :rest-api)

(setf (ningle:route *app* "/user/sign-up" :method :POST)
      #'(lambda (params)
          (with-database-error-handling
            (user-create params)
            (setf (lack.response:response-status ningle:*response*) 201))))

(setf (ningle:route *app* "/user/:id" :method :GET)
      #'(lambda (params)
          (with-database-error-handling
            (with-user-permission-validation ningle:*request* params
                (yason:with-output-to-string* () 
                  (yason:encode-object (user-read params)))))))

(setf (ningle:route *app* "/user/login" :method :POST)
      #'(lambda (params)
          (with-database-error-handling
            (format nil "~A" (user-login params)))))

(setf (ningle:route *app* "/user/:id" :method :PUT)
      #'(lambda (params)
          (with-database-error-handling
            (with-user-permission-validation ningle:*request* params
              (user-update params)))))

(setf (ningle:route *app* "/user/:id" :method :DELETE)
      #'(lambda (params)
          (with-database-error-handling
            (with-user-permission-validation ningle:*request*
                (user-soft-delete params)))))