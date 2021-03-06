;;;
;;; Copyright (c) 2016, Mihai Pomarlan <blandc@cs.uni-bremen.com>
;;; All rights reserved.
;;; 
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions are met:
;;; 
;;;     * Redistributions of source code must retain the above copyright
;;;       notice, this list of conditions and the following disclaimer.
;;;     * Redistributions in binary form must reproduce the above copyright
;;;       notice, this list of conditions and the following disclaimer in the
;;;       documentation and/or other materials provided with the distribution.
;;;     * Neither the name of Willow Garage, Inc. nor the names of its
;;;       contributors may be used to endorse or promote products derived from
;;;       this software without specific prior written permission.
;;; 
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
;;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;;; POSSIBILITY OF SUCH DAMAGE.
;;;

(in-package :kpml-ex)

(defclass kpml-example ()
  ((name :initarg :name :initform "Anonymous" :reader name)
   (set-name :initarg :set-name :initform "Unaffiliated" :reader set-name)
   (generatedform :initarg :generatedform :initform "" :accessor generatedform)
   (targetform :initarg :targetform :initform "" :reader targetform)
   (logicalform :initarg :logicalform :initform nil :reader logicalform)))

(defmacro example (&rest args)
  (let* ((args (cons 'kpml-example args))
         (name-pos (position :name args))
         (var-name (when name-pos
                     (nth (+ name-pos 1) args))))
    `(defparameter ,var-name (apply #'make-instance ',args))))

(defparameter kpml nil)

(defun replace-all (string part replacement &key (test #'char=))
  "Returns a new string in which all the occurences of the part 
is replaced with replacement."
  (when (and part (not (equal "" part)))
    (with-output-to-string (out)
      (loop with part-length = (length part)
            for old-pos = 0 then (+ pos part-length)
            for pos = (search part string
                              :start2 old-pos
                              :test test)
            do (write-string string out
                             :start old-pos
                             :end (or pos (length string)))
            when pos do (write-string replacement out)
            while pos))))

(defun init-connection (port &optional (host nil host-p))
  (if host-p
    (setf kpml (socket:socket-connect port host))
    (setf kpml (socket:socket-connect port))))

(defun send-line (stream line)
	   (princ line stream)
	   (princ (code-char 13) stream)
	   (princ (code-char 10) stream))

(defun run-example (example)
  (let* ((package-prefix (format nil "~S" 'a))
         (package-prefix (subseq package-prefix 0 (- (length package-prefix) 1)))
         (logicalform (replace-all (format nil "~S" (logicalform example)) package-prefix " "))
         (logicalform (substitute (code-char 32) (code-char 10) logicalform))
         (logicalform (substitute (code-char 32) (code-char 13) logicalform))
         (targetform (format nil "~a" (targetform example)))
         (generatedform (format nil "~a" (generatedform example)))
         (dummy (when kpml (format t "LOGICAL FORM:~%~a~%" logicalform)(send-line kpml logicalform)))
         (act-genform (when kpml (read-line kpml nil nil))))
    (declare (ignore dummy))
    (values act-genform generatedform targetform)))

;;(defparameter kpml (socket:socket-connect 4014))

;;(read-line kpml nil nil)


