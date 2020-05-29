(cl:in-package #:sicl-boot-phase-8)

(defun boot (boot)
  (format *trace-output* "Start of phase 8~%")
  (with-accessors ((e5 sicl-boot:e5))
      boot
    (load-source "Conditionals/support.lisp" e5)
    (load-source "Cons/set-difference-defun.lisp" e5)
    (load-source "Cons/nset-difference-defun.lisp" e5)
    (load-source "Cons/adjoin-defun.lisp" e5)
    (load-source "Cons/append-defun.lisp" e5)
    (load-source "Cons/nth-defun.lisp" e5)
    (load-source "Cons/nthcdr-defun.lisp" e5)
    (load-source "Cons/copy-list-defun.lisp" e5)
    (import-function-from-host 'cleavir-code-utilities:parse-macro e5)
    (load-source "Cons/with-alist-elements-defmacro.lisp" e5)
    (load-source "Cons/assoc-defun.lisp" e5)
    (load-source "Cons/make-list-defun.lisp" e5)
    (load-source "Cons/last-defun.lisp" e5)
    (load-source "Cons/butlast-defun.lisp" e5)
    (load-source "Cons/union-defun.lisp" e5)
    (load-source "Cons/set-exclusive-or-defun.lisp" e5)
    (load-source "Cons/mapcar-defun.lisp" e5)))
