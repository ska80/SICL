(cl:in-package #:sicl-new-boot-phase-4)

(defun finalize-all-classes (boot)
  (format *trace-output* "Finalizing all classes.~%")
  (let* ((e3 (sicl-new-boot:e3 boot))
         (finalization-function
           (sicl-genv:fdefinition 'sicl-clos:finalize-inheritance e3)))
    (do-all-symbols (var)
      (let ((class (sicl-genv:find-class var e3)))
        (unless (null class)
          (funcall finalization-function class)))))
  (format *trace-output* "Done finalizing all classes.~%"))

(defun boot-phase-4 (boot)
  (format *trace-output* "Start of phase 4~%")
  (with-accessors ((e3 sicl-new-boot:e3)
                   (e4 sicl-new-boot:e4)
                   (e5 sicl-new-boot:e5)) boot
    (change-class e4 'environment)
    (enable-class-finalization boot)
    (finalize-all-classes boot)
    (enable-defmethod-in-e4 boot)
    (enable-object-initialization boot)
    ;; (enable-method-combinations-in-e4 boot)
    ;; (enable-generic-function-invocation boot)
    ;; (define-accessor-generic-functions boot)
    ;; (enable-class-initialization-in-e4 e3 e4 e5)
    ;; (create-mop-classes boot)
    ))
