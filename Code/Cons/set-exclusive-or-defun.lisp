(cl:in-package #:sicl-cons)

(defun |set-exclusive-or key=identity test=eql| (name list1 list2)
  (let ((result '()))
    (with-proper-list-elements (element list1 name)
      (unless (|member test=eql key=identity| name element list2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (|member test=eql key=identity| name element list1)
        (push element result)))
    result))

(defun |set-exclusive-or key=identity test=eq| (name list1 list2)
  (let ((result '()))
    (with-proper-list-elements (element list1 name)
      (unless (|member test=eq key=identity| name element list2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (|member test=eq key=identity| name  element list1)
        (push element result)))
    result))

(defun |set-exclusive-or key=other test=eql| (name list1 list2 key)
  (let ((result '()))
    (with-proper-list-elements (element list1 name)
      (unless (|member test=eql key=other| name (funcall key element) list2 key)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (|member test=eql key=other| name (funcall key element) list1 key)
        (push element result)))
    result))

(defun |set-exclusive-or key=other test=eq| (name list1 list2 key)
  (let ((result '()))
    (with-proper-list-elements (element list1 name)
      (unless (|member test=eq key=other| name (funcall key element) list2 key)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (|member test=eq key=other| name (funcall key element) list1 key)
        (push element result)))
    result))

(defun |set-exclusive-or key=identity test=other| (name list1 list2 test)
  (let ((result '()))
    (with-proper-list-elements (element1 list1 name)
      (unless (|member test=other key=identity| name element1 list2 test)
        (push element1 result)))
    ;; we need to use a member with a test with reversed order or arguments
    (with-proper-list-elements (element2 list2 name)
      (unless (|member reversed test=other key=identity| name element2 list1 test)
        (push element2 result)))
    result))

(defun |set-exclusive-or key=other test=other| (name list1 list2 key test)
  (let ((result '()))
    (with-proper-list-elements (element1 list1 name)
      (unless (|member test=other key=other| name (funcall key element1) list2 test key)
        (push element1 result)))
    ;; we need to use a member with a test with reversed order or arguments
    (with-proper-list-elements (element2 list2 name)
      (unless (|member reversed test=other key=other| name (funcall key element2) list1 test key)
        (push element2 result)))
    result))

(defun |set-exclusive-or key=identity test-not=other| (name list1 list2 test-not)
  (let ((result '()))
    (with-proper-list-elements (element1 list1 name)
      (unless (|member test-not=other key=identity| name element1 list2 test-not)
        (push element1 result)))
    ;; we need to use a member with a test with reversed order or arguments
    (with-proper-list-elements (element2 list2 name)
      (unless (|member reversed test-not=other key=identity| name element2 list1 test-not)
        (push element2 result)))
    result))

(defun |set-exclusive-or key=other test-not=other| (name list1 list2 key test-not)
  (let ((result '()))
    (with-proper-list-elements (element1 list1 name)
      (unless (|member test-not=other key=other| name (funcall key element1) list2 test-not key)
        (push element1 result)))
    ;; we need to use a member with a test with reversed order or arguments
    (with-proper-list-elements (element2 list2 name)
      (unless (|member reversed test-not=other key=other| name (funcall key element2) list1 test-not key)
        (push element2 result)))
    result))

(defun |set-exclusive-or key=identity test=eq hash| (name list1 list2)
  (let ((table1 (make-hash-table :test #'eq))
        (table2 (make-hash-table :test #'eq))
        (result '()))
    (with-proper-list-elements (element list1 name)
      (setf (gethash element table1) t))
    (with-proper-list-elements (element list2 name)
      (setf (gethash element table2) t))
    (with-proper-list-elements (element list1 name)
      (unless (gethash element table2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (gethash element table1)
        (push element result)))
    result))

(defun |set-exclusive-or key=identity test=eql hash| (name list1 list2)
  (let ((table1 (make-hash-table :test #'eql))
        (table2 (make-hash-table :test #'eql))
        (result '()))
    (with-proper-list-elements (element list1 name)
      (setf (gethash element table1) t))
    (with-proper-list-elements (element list2 name)
      (setf (gethash element table2) t))
    (with-proper-list-elements (element list1 name)
      (unless (gethash element table2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (gethash element table1)
        (push element result)))
    result))

(defun |set-exclusive-or key=identity test=equal hash| (name list1 list2)
  (let ((table1 (make-hash-table :test #'equal))
        (table2 (make-hash-table :test #'equal))
        (result '()))
    (with-proper-list-elements (element list1 name)
      (setf (gethash element table1) t))
    (with-proper-list-elements (element list2 name)
      (setf (gethash element table2) t))
    (with-proper-list-elements (element list1 name)
      (unless (gethash element table2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (gethash element table1)
        (push element result)))
    result))

(defun |set-exclusive-or key=identity test=equalp hash| (name list1 list2)
  (let ((table1 (make-hash-table :test #'equalp))
        (table2 (make-hash-table :test #'equalp))
        (result '()))
    (with-proper-list-elements (element list1 name)
      (setf (gethash element table1) t))
    (with-proper-list-elements (element list2 name)
      (setf (gethash element table2) t))
    (with-proper-list-elements (element list1 name)
      (unless (gethash element table2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (gethash element table1)
        (push element result)))
    result))

(defun |set-exclusive-or key=other test=eq hash| (name list1 list2 key)
  (let ((table1 (make-hash-table :test #'eq))
        (table2 (make-hash-table :test #'eq))
        (result '()))
    (with-proper-list-elements (element list1 name)
      (setf (gethash (funcall key element) table1) t))
    (with-proper-list-elements (element list2 name)
      (setf (gethash (funcall key element) table2) t))
    (with-proper-list-elements (element list1 name)
      (unless (gethash (funcall key element) table2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (gethash (funcall key element) table1)
        (push element result)))
    result))

(defun |set-exclusive-or key=other test=eql hash| (name list1 list2 key)
  (let ((table1 (make-hash-table :test #'eql))
        (table2 (make-hash-table :test #'eql))
        (result '()))
    (with-proper-list-elements (element list1 name)
      (setf (gethash (funcall key element) table1) t))
    (with-proper-list-elements (element list2 name)
      (setf (gethash (funcall key element) table2) t))
    (with-proper-list-elements (element list1 name)
      (unless (gethash (funcall key element) table2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (gethash (funcall key element) table1)
        (push element result)))
    result))

(defun |set-exclusive-or key=other test=equal hash| (name list1 list2 key)
  (let ((table1 (make-hash-table :test #'equal))
        (table2 (make-hash-table :test #'equal))
        (result '()))
    (with-proper-list-elements (element list1 name)
      (setf (gethash (funcall key element) table1) t))
    (with-proper-list-elements (element list2 name)
      (setf (gethash (funcall key element) table2) t))
    (with-proper-list-elements (element list1 name)
      (unless (gethash (funcall key element) table2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (gethash (funcall key element) table1)
        (push element result)))
    result))

(defun |set-exclusive-or key=other test=equalp hash| (name list1 list2 key)
  (let ((table1 (make-hash-table :test #'equalp))
        (table2 (make-hash-table :test #'equalp))
        (result '()))
    (with-proper-list-elements (element list1 name)
      (setf (gethash (funcall key element) table1) t))
    (with-proper-list-elements (element list2 name)
      (setf (gethash (funcall key element) table2) t))
    (with-proper-list-elements (element list1 name)
      (unless (gethash (funcall key element) table2)
        (push element result)))
    (with-proper-list-elements (element list2 name)
      (unless (gethash (funcall key element) table1)
        (push element result)))
    result))

(defun set-exclusive-or (list1 list2
                         &key key (test nil test-given) (test-not nil test-not-given))
  (when (and test-given test-not-given)
    (error 'both-test-and-test-not-given :name 'set-exclusive-or))
  (let ((use-hash (> (* (length list1) (length list2)) 1000)))
    (if key
        (if test-given
            (cond ((or (eq test #'eq) (eq test 'eq))
                   (if use-hash
                       (|set-exclusive-or key=other test=eq hash| 'set-exclusive-or list1 list2 key)
                       (|set-exclusive-or key=other test=eq| 'set-exclusive-or list1 list2 key)))
                  ((or (eq test #'eql) (eq test 'eql))
                   (if use-hash
                       (|set-exclusive-or key=other test=eql hash| 'set-exclusive-or list1 list2 key)
                       (|set-exclusive-or key=other test=eql| 'set-exclusive-or list1 list2 key)))
                  ((or (eq test #'equal) (eq test 'equal))
                   (if use-hash
                       (|set-exclusive-or key=other test=equal hash| 'set-exclusive-or list1 list2 key)
                       (|set-exclusive-or key=other test=other| 'set-exclusive-or list1 list2 key #'equal)))
                  ((or (eq test #'equalp) (eq test 'equalp))
                   (if use-hash
                       (|set-exclusive-or key=other test=equalp hash| 'set-exclusive-or list1 list2 key)
                       (|set-exclusive-or key=other test=other| 'set-exclusive-or list1 list2 key #'equalp)))
                  (t
                   (|set-exclusive-or key=other test=other| 'set-exclusive-or list1 list2 key test)))
            (if test-not-given
                (|set-exclusive-or key=other test-not=other| 'set-exclusive-or list1 list2 key test-not)
                (if use-hash
                    (|set-exclusive-or key=other test=eql hash| 'set-exclusive-or list1 list2 key)
                    (|set-exclusive-or key=other test=eql| 'set-exclusive-or list1 list2 key))))
        (if test-given
            (cond ((or (eq test #'eq) (eq test 'eq))
                   (if use-hash
                       (|set-exclusive-or key=identity test=eq hash| 'set-exclusive-or list1 list2)
                       (|set-exclusive-or key=identity test=eq| 'set-exclusive-or list1 list2)))
                  ((or (eq test #'eql) (eq test 'eql))
                   (if use-hash
                       (|set-exclusive-or key=identity test=eql hash| 'set-exclusive-or list1 list2)
                       (|set-exclusive-or key=identity test=eql| 'set-exclusive-or list1 list2)))
                  ((or (eq test #'equal) (eq test 'equal))
                   (if use-hash
                       (|set-exclusive-or key=identity test=equal hash| 'set-exclusive-or list1 list2)
                       (|set-exclusive-or key=identity test=other| 'set-exclusive-or list1 list2 #'equal)))
                  ((or (eq test #'equalp) (eq test 'equalp))
                   (if use-hash
                       (|set-exclusive-or key=identity test=equalp hash| 'set-exclusive-or list1 list2)
                       (|set-exclusive-or key=identity test=other| 'set-exclusive-or list1 list2 #'equalp)))
                  (t
                   (|set-exclusive-or key=identity test=other| 'set-exclusive-or list1 list2 test)))
            (if test-not-given
                (|set-exclusive-or key=identity test-not=other| 'set-exclusive-or list1 list2 test-not)
                (if use-hash
                    (|set-exclusive-or key=identity test=eql hash| 'set-exclusive-or list1 list2)
                    (|set-exclusive-or key=identity test=eql| 'set-exclusive-or list1 list2)))))))
