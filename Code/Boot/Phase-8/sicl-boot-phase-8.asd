(cl:in-package #:asdf-user)

(defsystem #:sicl-boot-phase-8
  :depends-on (#:sicl-boot-base
               #:cl-unicode)
  :serial t
  :components
  ((:file "packages")
   (:file "utilities")
   (:file "load-arithmetic-functions")
   (:file "load-hash-table-functionality")
   (:file "load-sicl-utilities")
   (:file "define-compile")
   (:file "boot")
   (:file "patch-environment")
   (:file "check-environment")
   (:file "who-calls")
   (:file "load-sequence-functions")))
