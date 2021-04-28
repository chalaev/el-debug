;;; el-debug.el --- emacs-lisp debug helper  -*- lexical-binding: t; -*-

;; Copyright (C) 2021 Oleg Shalaev <oleg@chalaev.com>

;; Author:     Oleg Shalaev <oleg@chalaev.com>
;; Version:    0.0.0

;; Package-Requires: (shalaev)
;; Keywords:   debug
;; URL:        https://github.com/chalaev/el-debug

;;; Commentary:

;; This package contains several tools helpfull for debugging elisp code
;; The documentation is (or will be) available on
;; https://github.com/chalaev/el-debug
  
;;; Code:

(mapcar #'require '(shalaev))

(defmacro debug-log-var(VN &optional val-type)
"reporting a variable"
`(clog :debug ,(concat(symbol-name VN) "= %" (or val-type "s")) ,VN))

(defmacro set-list(var-names values)
"sets values from the list to variables"
  (let((i -1)(vs(s-gensym)))
    `(let((,vs ,values))
       ,@(mapcar #'(lambda(VN) `(setf ,VN  (nth ,(cl-incf i) ,vs))) var-names))))

(defmacro debug-set(debug-conf &rest var-names)
  (let((result(s-gensym "res"))(i(s-gensym "i")))
    `(progn
       (clog :debug "debug-set:old values -->")
       ,@(mapcar #'(lambda(VN) `(debug-log-var ,VN)) var-names)
       (let((,result (letc ,debug-conf ,var-names (list ,@var-names))))
	 (set-list ,var-names ,result))
       (clog :debug "updated values -->")
       ,@(mapcar #'(lambda(VN) `(clog :debug "%s = %s" (symbol-name (quote ,VN)) ,VN)) var-names))))

(defvar *debug-depth* 0)
(defmacro defun (name arglist &optional docstring &rest body)
"updating standard definition"
  (declare (doc-string 3) (indent 2))
  (or name (error "Cannot define '%s' as a function" name))
  (if (null
       (and (listp arglist)
            (null (delq t (mapcar #'symbolp arglist)))))
      (error "Malformed arglist: %s" arglist))
  (let ((decls (cond
                ((eq (car-safe docstring) 'declare)
                 (prog1 (cdr docstring) (setq docstring nil)))
                ((and (stringp docstring)
		      (eq (car-safe (car body)) 'declare))
                 (prog1 (cdr (car body)) (setq body (cdr body)))))))
    (if docstring (setq body (cons docstring body))
      (if (null body) (setq body '(nil))))
    (let ((declarations
           (mapcar
            #'(lambda (x)
                (let ((f (cdr (assq (car x) defun-declarations-alist))))
                  (cond
                   (f (apply (car f) name arglist (cdr x)))
                   ;; Yuck!!
                   ((and (featurep 'cl)
                         (memq (car x)  ;C.f. cl-do-proclaim.
                               '(special inline notinline optimize warn)))
                    (push (list 'declare x)
                          (if (stringp docstring)
                              (if (eq (car-safe (cadr body)) 'interactive)
                                  (cddr body)
                                (cdr body))
                            (if (eq (car-safe (car body)) 'interactive)
                                (cdr body)
                              body)))
                    nil)
                   (t (message "Warning: Unknown defun property `%S' in %S"
                               (car x) name)))))
                   decls))
          (def (list 'defalias
                     (list 'quote name)
                     (list 'function
                           (cons 'lambda
(cons arglist ; my changes begin here
(list `(progn
(space-log *debug-depth* ,(format "entering %S" name))
(cl-incf *debug-depth*)
(prog1
 (progn ,@body)
 (space-log (cl-decf *debug-depth*) ,(format "leaving %S" name))))) ; end of my changes
))))))
      (if declarations
          (cons 'prog1 (cons def declarations))
          def))))

(provide 'el-debug)
;;; el-debug.el ends here
