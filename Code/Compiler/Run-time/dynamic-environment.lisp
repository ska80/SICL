(cl:in-package #:sicl-run-time)

(defparameter *dynamic-environment* '())

(defclass entry () ())

(defgeneric invalidate-entry (entry))

(defmethod invalidate-entry (entry)
  (declare (ignore entry))
  nil)

(defclass exit-point (entry)
  ((%validp :initform t :accessor validp)))

(defmethod invalidate-entry ((entry exit-point))
  (setf (validp entry) nil))

(defclass block/tagbody-entry (exit-point)
  ((%stack-pointer :initarg :stack-pointer :reader stack-pointer)
   (%frame-pointer :initarg :frame-pointer :reader frame-pointer)
   (%identifier :initarg :identifier :reader identifier)))

(defmethod print-object ((object block/tagbody-entry) stream)
  (print-unreadable-object (object stream :type t :identity t)
    (format stream "~s" (frame-pointer object))))

(defclass catch-entry (exit-point)
  ((%tag :initarg :tag :reader tag)))

(defmethod print-object ((object catch-entry) stream)
  (print-unreadable-object (object stream :type t :identity t)
    (format stream "~s" (tag object))))

(defclass special-variable-entry (entry)
  ((%name :initarg :name :reader name)
   (%value :initarg :value :accessor value)))

(defmethod print-object ((object special-variable-entry) stream)
  (print-unreadable-object (object stream :type t :identity t)
    (format stream "~s ~s" (name object) (value object))))

(defclass unwind-protect-entry (entry)
  ((%thunk :initarg :thunk :reader thunk)))

(defmethod print-object ((object unwind-protect-entry) stream)
  (print-unreadable-object (object stream :type t :identity t)
    (format stream "~s" (thunk object))))

;;; Given the name (a symbol) of a special variable, return the most
;;; recently pushed SPECIAL-VARIABLE-ENTRY with that name.  If no such
;;; entry exists, then return NIL.
(defun find-special-variable-entry (dynamic-environment name)
  (loop for entry in dynamic-environment
        when (and (typep entry 'special-variable-entry)
                  (eq name (name entry)))
          return entry
        finally (return nil)))
