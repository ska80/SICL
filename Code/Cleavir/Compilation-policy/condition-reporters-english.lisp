(cl:in-package #:cleavir-compilation-policy)

(defmethod acclimation:report-condition
    ((condition bad-optimize-value) stream (language acclimation:english))
  (format stream "Bad optimize value for ~s: ~s~@
                  Expected ~s"
	  (first (specifier condition))
	  (second (specifier condition))
	  (expected-type condition)))

(defmethod acclimation:report-condition
    ((condition unknown-optimize-quality) stream (language acclimation:english))
  (format stream "Unknown OPTIMIZE quality ~s"
	  (first (specifier condition))))
