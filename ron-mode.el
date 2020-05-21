;;; ron-mode.el --- Rusty Object Notation (RON) mode -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Devin Schwab

;; Author: Devin Schwab <digidevin@gmail.com>
;; URL: TODO
;; Version: 0.1-pre
;; Package-Requires: ((emacs "26.1"))
;; Keywords: rust

;;; Commentary:

;; Provide syntax highlighting for Rusty Object Notation (RON) files
;; See https://github.com/ron-rs/ron for information on the file format
;;
;; These files are used by the Amethyst project:
;; https://www.amethyst.rs/

;;; Code:

;;;; Requirements

;;;; Customization

(defvar ron-mode-indent-offset 4
  "Indentation offset for `ron-mode'.")

(defvar ron-mode-hook '())

;;;; Variables

(setq ron-constants '("true" "false"))
(setq ron-keywords '("Some"))

(setq ron-comment-regexp "//.*")
(setq ron-extension-regexp "\\(#[[:space:]]*\\![[:space:]]*\\[[[:space:]]*enable[[:space:]]*\\)(\\([[:alpha:]]\\|[[:digit:]]\\|_\\)+\\(,[[:space:]]*\\([[:alpha:]]\\|[[:digit:]]\\|_\\)+\\)*[[:space:]]*)\\]")
(setq ron-constants-regexp (regexp-opt ron-constants 'words))
(setq ron-keywords-regexp (regexp-opt ron-keywords 'words))

(setq ron-font-lock-keywords
      `(
	(,ron-extension-regexp (1 font-lock-preprocessor-face))
	(,ron-constants-regexp . font-lock-constant-face)
	(,ron-keywords-regexp . font-lock-keyword-face)
	(,ron-comment-regexp . font-lock-comment-face)))

;;;; Keymaps

;;;; Functions

(defun ron-indent-line ()
  "Indent current line for `ron-mode'."
  (interactive)
  (let ((indent-col 0))
    (save-excursion
      (beginning-of-line)
      (condition-case nil
          (while t
            (backward-up-list 1)
            (when (looking-at "[[{\\(]")
              (setq indent-col (+ indent-col ron-mode-indent-offset))))
        (error nil)))
    (save-excursion
      (back-to-indentation)
      (when (and (looking-at "[]}\\)]") (>= indent-col ron-mode-indent-offset))
        (setq indent-col (- indent-col ron-mode-indent-offset))))
    (indent-line-to indent-col)))

;;;; Commands

;;;; Support

;;;; Footer

;;;###autoload
(define-derived-mode ron-mode prog-mode "ron-mode"
  "Major mode for editing RON files"
  (setq font-lock-defaults '((ron-font-lock-keywords)))
  (setq comment-start "//")
  (setq comment-end "")
  (setq tab-width ron-mode-indent-offset)
  (setq indent-line-function 'ron-indent-line)  
  (setq indent-tabs-mode nil))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.ron" . ron-mode))

(provide 'ron-mode)

;;; ron-mode.el ends here
