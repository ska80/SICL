(cl:in-package #:common-lisp-user)

(defpackage #:cleavir-test-generate-ast
  (:use #:common-lisp))

(in-package #:cleavir-test-generate-ast)

(defgeneric same-p (ast1 ast2 table))

(defun same-ast-p (ast1 ast2)
  (same-p ast1 ast2 '()))

(defmethod same-p :around (ast1 ast2 table)
  (cond ((not (eq (class-of ast1) (class-of ast2)))
	 nil)
	((member (cons ast1 ast2) table :test #'equal)
	 t)
	(t
	 (call-next-method ast1 ast2 (cons (cons ast1 ast2) table)))))

(defmethod same-p ((ast1 cleavir-ast:constant-ast) ast2 table)
  (equalp (cleavir-ast:value ast1) (cleavir-ast:value ast2)))

(defmethod same-p ((ast1 cleavir-ast:lexical-ast) ast2 table)
  (equal (cleavir-ast:name ast1) (cleavir-ast:name ast2)))

(defmethod same-p ((ast1 cleavir-ast:symbol-value-ast) ast2 table)
  (eq (cleavir-ast:symbol ast1) (cleavir-ast:symbol ast2)))

(defmethod same-p ((ast1 cleavir-ast:set-symbol-value-ast) ast2 table)
  (and (eq (cleavir-ast:symbol ast1) (cleavir-ast:symbol ast2))
       (same-p (cleavir-ast:value-ast ast1) (cleavir-ast:value-ast ast2))))

(defmethod same-p ((ast1 cleavir-ast:fdefinition-ast) ast2 table)
  (equal (cleavir-ast:name ast1) (cleavir-ast:name ast2)))

(defmethod same-p ((ast1 cleavir-ast:call-ast) ast2 table)
  (and (same-p (cleavir-ast:callee-ast ast1) (cleavir-ast:callee-ast ast2))
       (every (lambda (a1 a2) (same-p a1 a2 table))
	      (cleavir-ast:argument-asts ast1)
	      (cleavir-ast:argument-asts ast2))))
