(defsystem "rest-api"
  :version "0.1.0"
  :defsystem-depends-on (:deploy
                         :clack-handler-hunchentoot)
  :build-operation "deploy-op"
  :build-pathname "rest-api"
  :entry-point "rest-api::main"
  :author ""
  :license ""
  :depends-on (#:quicklisp
               #:asdf
               #:clack
               #:ningle
               #:mito
               #:yason
               #:ironclad
               #:jose
               #:clack-handler-hunchentoot)
  :components ((:module "src"
                :components
                ((:file "main")
                 (:module "model"
                  :components ((:file "user")
                               (:file "admin")))
                 (:module "controller"
                  :components ((:file "user-controller")))
                 (:module "service"
                  :components ((:file "user-service")
                               (:file "auth-service")))
                 (:module "utils"
                  :components ((:file "json-util")))
                 )))
  :description ""
  :in-order-to ((test-op (test-op "rest-api/tests"))))

(defsystem "rest-api/tests"
  :author ""
  :license ""
  :depends-on ("rest-api"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for rest-api"
  :perform (test-op (op c) (symbol-call :rove :run c)))
