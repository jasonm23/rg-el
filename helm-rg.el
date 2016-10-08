;;; helm-rg.el --- Helm interface for rg ('ripgrep')  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Chunyang Xu

;; Author: Chunyang Xu <xuchunyang.me@gmail.com>
;; Keywords: tools, processes
;; Package-Requires: ((emacs "24.4") (helm "2.0"))
;; Version: 0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'helm)

(defun helm-rg--candidates-process ()
  (let* ((query helm-pattern)
         (cmd-args (list "rg" "--vimgrep --no-heading" query))
         (proc (apply 'start-file-process "helm-rg" nil cmd-args)))
    (prog1 proc
      (set-process-sentinel
       proc
       (lambda (process event)
         (helm-process-deferred-sentinel-hook
          process event (helm-default-directory)))))))

(defvar helm-rg-source
  (helm-build-async-source "ripgrep (rg)"
    :candidates-process 'helm-rg--candidates-process
    :action 'helm-grep-actions
    :nohighlight t
    :filter-one-by-one 'helm-grep-filter-one-by-one
    :requires-pattern 2
    :candidate-number-limit 9999))

;;;###autoload
(defun helm-rg ()
  (interactive)
  (helm :sources 'helm-rg-source
        :buffer "*helm rg*"))

(provide 'helm-rg)
;;; helm-rg.el ends here
