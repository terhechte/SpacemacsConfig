;;; ob-swift.el --- org-babel functions for Swift evaluation

;; Copyright (C) 2012-2014 Free Software Foundation, Inc.

;; Author: Andrzej Lichnerowicz
;; Keywords: literate programming, reproducible research
;; Homepage: http://orgmode.org

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; Currently only supports the external execution.  No session support yet.

;;; Requirements:
;; - Swift language :: http://www.apple.com
;; - Swift major mode :: Can be installed from Github

;;; Code:
(require 'ob)
(eval-when-compile (require 'cl))

(defvar org-babel-tangle-lang-exts) ;; Autoloaded
(add-to-list 'org-babel-tangle-lang-exts '("swift" . "swift"))
(defvar org-babel-default-header-args:swift '())
(defvar org-babel-swift-command "swift"
  "Name of the command to use for executing Swift code.")

(defun org-babel-execute:swift (body params)
  "Execute a block of Swift code with org-babel.  This function is
called by `org-babel-execute-src-block'"
  (message "executing Swift source code block")
  (let* ((processed-params (org-babel-process-params params))
         (session (org-babel-swift-initiate-session (nth 0 processed-params)))
         (vars (nth 1 processed-params))
         (result-params (nth 2 processed-params))
         (result-type (cdr (assoc :result-type params)))
         (full-body (org-babel-expand-body:generic
                     body params))
         (result (org-babel-swift-evaluate
                  session full-body result-type result-params)))

    (org-babel-reassemble-table
     result
     (org-babel-pick-name
      (cdr (assoc :colname-names params)) (cdr (assoc :colnames params)))
     (org-babel-pick-name
      (cdr (assoc :rowname-names params)) (cdr (assoc :rownames params))))))


(defun org-babel-swift-table-or-string (results)
  "Convert RESULTS into an appropriate elisp value.
If RESULTS look like a table, then convert them into an
Emacs-lisp table, otherwise return the results as a string."
  results)


(defvar org-babel-swift-wrapper-method
  "
%s
")

(defun old-process-swift-eval-error (tmp)
  (replace-regexp-in-string "\/.*?\:" "line:" tmp))

;; ------

(defun source-to-final ()
  "Cut refs from the txt, but letting them appear as text properties."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward-regexp "line" nil 'noerror)
      (let ((ref (match-string 1)))
                                        ;(replace-match "xline") ;; cutting the ref text
        (message ref)
        (add-face-text-property (point) (+ (point) 5) '(:foreground "red"))
        ))))

(defun set-some-overlay-or-textproperty-here (text)
  (add-text-properties (point) (1+ (point))
    `(display ,(propertize text 'face 'font-lock-comment-face))))

(defun process-swift-eval-error (tmp)
  (let ((result tmp))
    (setq result (replace-regexp-in-string "\/.*?\:" "line:" result))
    (setq result (replace-regexp-in-string ":.?error:" ": error:\n" result))
    (with-temp-buffer
      (font-lock-mode)
      (insert result)
      (source-to-final)
      (buffer-string)
      )))

;; ------


(defun org-babel-eval-error-notify (exit-code stderr)
  "Open a buffer to display STDERR and a message with the value of EXIT-CODE."
  (let ((buf (get-buffer-create org-babel-error-buffer-name)))
    (with-current-buffer buf
      (goto-char (point-max))
      ;; Modify, remove all temp file paths
      (save-excursion (insert (process-swift-eval-error stderr))))
    (display-buffer buf))
  (message "Babel evaluation exited with code %S" exit-code))


(defun org-babel-swift-evaluate
  (session body &optional result-type result-params)
  "Evaluate BODY in external Swift process.
If RESULT-TYPE equals 'output then return standard output as a string.
If RESULT-TYPE equals 'value then return the value of the last statement
in BODY as elisp."
  (when session (error "Sessions are not (yet) supported for Swift"))
  (setq org-babel-error-buffer-name "*Emacs Swift Error Output*")
  (case result-type
    (output
     (let ((src-file (org-babel-temp-file "swift-")))
       (progn (with-temp-file src-file (insert body))
              (org-babel-eval
               (concat org-babel-swift-command " " src-file) ""))))
    (value
     (let* ((src-file (org-babel-temp-file "swift-"))
            (wrapper (format org-babel-swift-wrapper-method body)))
       (with-temp-file src-file (insert wrapper))
       (let ((raw (org-babel-eval
                   (concat org-babel-swift-command " " src-file) "")))
         (org-babel-result-cond result-params
	   raw
           (org-babel-swift-table-or-string raw)))))))


(defun org-babel-prep-session:swift (session params)
  "Prepare SESSION according to the header arguments specified in PARAMS."
  (error "Sessions are not (yet) supported for Swift"))

(defun org-babel-swift-initiate-session (&optional session)
  "If there is not a current inferior-process-buffer in SESSION
then create.  Return the initialized session.  Sessions are not
supported in Swift."
  nil)

(provide 'ob-swift)



;;; ob-swift.el ends here
