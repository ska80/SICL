(cl:in-package #:sicl-boot-phase-8)

(defun boot (boot)
  (format *trace-output* "Start of phase 8~%")
  (with-accessors ((e5 sicl-boot:e5))
      boot
    (load-source "Types/Typep/typep.lisp" e5)
    (load-source "Types/Typep/typep-atomic.lisp" e5)
    (load-source "Types/Typep/typep-compound.lisp" e5)
    (load-source "Types/Typep/typep-compound-integer.lisp" e5)
    (load-arithmetic-functions e5)
    (import-function-from-host 'sicl-genv:type-expander e5)
    (load-source "Conditionals/support.lisp" e5)
    (load-cons-related-functions e5)
    (load-source "Data-and-control-flow/not-defun.lisp" e5)
    (load-source "Loop/run-time-support.lisp" e5)
    (load-source "CLOS/defgeneric-support.lisp" e5)))
