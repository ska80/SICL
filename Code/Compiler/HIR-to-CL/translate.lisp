(cl:in-package #:sicl-hir-to-cl)

(defgeneric translate (instruction context))

(defmethod translate ((instruction cleavir-ir:assignment-instruction) context)
  (let* ((input (first (cleavir-ir:inputs instruction)))
         (output (first (cleavir-ir:outputs instruction)))
         (successor (first (cleavir-ir:successors instruction))))
    (cons `(setq ,(cleavir-ir:name output)
                 ,(if (typep input 'cleavir-ir:constant-input)
                      `',(cleavir-ir:value input)
                      (cleavir-ir:name input)))
          (translate successor context))))

(defmethod translate ((instruction cleavir-ir:funcall-instruction) context)
  (let ((inputs (cleavir-ir:inputs instruction))
        (successor (first (cleavir-ir:successors instruction))))
    (cons `(setq ,(values-location context)
                 (multiple-value-list
                  (funcall ,@(mapcar #'cleavir-ir:name inputs))))
          (translate successor context))))

(defmethod translate ((instruction cleavir-ir:return-instruction) context)
  `((return-from ,(block-name context)
      (apply #'values ,(values-location context)))))

(defmethod translate ((instruction cleavir-ir:enclose-instruction) context)
  (let ((name (cleavir-ir:name (first (cleavir-ir:outputs instruction))))
        (enter (cleavir-ir:code instruction))
        (successor (first (cleavir-ir:successors instruction))))
    `((setq ,name (funcall (aref ,*static-environment-variable* 1)
                           ,(gethash enter (function-names context))
                           ,@(mapcar #'cleavir-ir:name
                                     (cleavir-ir:inputs instruction))))
      (closer-mop:set-funcallable-instance-function
       ,name
       (lambda (&rest args)
         (funcall ,(gethash enter (function-names context))
                  args
                  (funcall ,(static-env-function-var context) ,name)
                  *dynamic-environment*)))
      ,@(translate successor context))))

(defmethod translate ((instruction cleavir-ir:fetch-instruction) context)
  (let* ((inputs (cleavir-ir:inputs instruction))
         (static-environment-input (first inputs))
         (static-environment-input-name (cleavir-ir:name static-environment-input))
         (index-input (second inputs))
         (index (cleavir-ir:value index-input))
         (output (first (cleavir-ir:outputs instruction)))
         (output-name (cleavir-ir:name output))
         (successor (first (cleavir-ir:successors instruction))))
    `((setq ,output-name
            (aref ,static-environment-input-name ,(+ index 2)))
      ,@(translate successor context))))

(defmethod translate ((instruction cleavir-ir:read-cell-instruction) context)
  (let* ((input (first (cleavir-ir:inputs instruction)))
         (input-name (cleavir-ir:name input))
         (output (first (cleavir-ir:outputs instruction)))
         (output-name (cleavir-ir:name output))
         (successor (first (cleavir-ir:successors instruction))))
    `((setq ,output-name
            (car ,input-name))
      ,@(translate successor context))))

(defmethod translate ((instruction cleavir-ir:create-cell-instruction) context)
  (let* ((output (first (cleavir-ir:outputs instruction)))
         (output-name (cleavir-ir:name output))
         (successor (first (cleavir-ir:successors instruction))))
    `((setq ,output-name (list nil))
      ,@(translate successor context))))

(defmethod translate ((instruction cleavir-ir:write-cell-instruction) context)
  (let* ((inputs (cleavir-ir:inputs instruction))
         (cons-input (first inputs))
         (object-input (second inputs))
         (cons-name (cleavir-ir:name cons-input))
         (object-name (cleavir-ir:name object-input))
         (successor (first (cleavir-ir:successors instruction))))
    `((rplaca ,cons-name ,object-name)
      ,@(translate successor context))))

(defmethod translate ((instruction cleavir-ir:nop-instruction) context)
  (let ((successor (first (cleavir-ir:successors instruction))))
    (translate successor context)))

(defmethod translate ((instruction cleavir-ir:eq-instruction) context)
  (destructuring-bind (input1 input2)
      (cleavir-ir:inputs instruction)
    (destructuring-bind (successor1 successor2)
        (cleavir-ir:successors instruction)
      (let ((else (gensym))
            (out (gensym)))
        `((when (eq ,input1 ,input2)
            (go ,else))
          ,@(translate successor1 context)
          (go ,out)
          ,else
          ,@(translate successor2 context)
          ,out)))))

(defmethod translate ((instruction cleavir-ir:consp-instruction) context)
  (let ((input (first (cleavir-ir:inputs instruction))))
    (destructuring-bind (successor1 successor2)
        (cleavir-ir:successors instruction)
      (let ((else (gensym))
            (out (gensym)))
        `((when (consp ,input)
            (go ,else))
          ,@(translate successor1 context)
          (go ,out)
          ,else
          ,@(translate successor2 context)
          ,out)))))

(defmethod translate ((instruction cleavir-ir:fixnump-instruction) context)
  (let ((input (first (cleavir-ir:inputs instruction))))
    (destructuring-bind (successor1 successor2)
        (cleavir-ir:successors instruction)
      (let ((else (gensym))
            (out (gensym)))
        `((when (typep ,input 'fixnum)
            (go ,else))
          ,@(translate successor1 context)
          (go ,out)
          ,else
          ,@(translate successor2 context)
          ,out)))))

(defmethod translate ((instruction cleavir-ir:characterp-instruction) context)
  (let ((input (first (cleavir-ir:inputs instruction))))
    (destructuring-bind (successor1 successor2)
        (cleavir-ir:successors instruction)
      (let ((else (gensym))
            (out (gensym)))
        `((when (characterp ,input)
            (go ,else))
          ,@(translate successor1 context)
          (go ,out)
          ,else
          ,@(translate successor2 context)
          ,out)))))

(defmethod translate :around (instruction context)
  (let* ((visited (visited context))
         (tag (gethash instruction visited)))
    (if (null tag)
        (progn (setf (gethash instruction visited) (gensym))
               (cons (gethash instruction visited)
                     (call-next-method)))
        `((go ,tag)))))
