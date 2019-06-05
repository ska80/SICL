(cl:in-package #:sicl-boot-phase-3)

(defun set-up-environments (boot)
  (with-accessors ((e3 sicl-boot:e3)
                   (e4 sicl-boot:e4))
      boot
    (sicl-boot:import-function-from-host 'funcall e4)
    (sicl-boot:import-function-from-host '(setf sicl-genv:function-lambda-list) e4)
    (sicl-boot:import-function-from-host '(setf sicl-genv:function-type) e4)
    (sicl-hir-to-cl:fill-environment e4)
    (setf (sicl-genv:fdefinition 'sicl-genv:global-environment e4)
          (constantly e4))
    (sicl-boot:import-function-from-host 'list e3)))
