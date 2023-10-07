(defsystem "rest-api"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (#:clack
               #:ningle
               #:mito
               #:yason
               #:ironclad
               #:jose)
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
