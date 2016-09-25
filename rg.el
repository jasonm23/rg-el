;;; rg.el --- A front-end for rg ('ripgrep')         -*- lexical-binding: t; -*-

;; Copyright (C) 2016  Chunyang Xu

;; Author: Chunyang Xu <xuchunyang.me@gmail.com>
;; Package-Requires: ((emacs "24.3"))
;; Keywords: tools, processes
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

(require 'compile)

(define-compilation-mode rg-mode "rg"
  "A compilation mode tailored for rg."
  (setq-local compilation-disable-input t)
  (setq-local compilation-error-face 'compilation-info))

;;;###autoload
(defun rg (string directory)
  (interactive
   (let* ((default
            (cond ((use-region-p)
                   (buffer-substring-no-properties
                    (region-beginning) (region-end)))
                  ((symbol-at-point)
                   (substring-no-properties
                    (symbol-name (symbol-at-point))))))
          (prompt (if default
                      (format "Search regexp (default %s): " default)
                    "Search regexp: "))
          (string (read-from-minibuffer
                   prompt nil nil nil nil default))
          (directory (read-directory-name "Directory: ")))
     (list string directory)))
  (let ((cmdline (format "rg '%s' %s" string directory)))
    (compilation-start cmdline 'rg-mode)))

(provide 'rg)
;;; rg.el ends here
