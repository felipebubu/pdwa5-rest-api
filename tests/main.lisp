(defpackage rest-api/tests/main
  (:use :cl
        :rest-api
        :rove))
(in-package :rest-api/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :rest-api)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
