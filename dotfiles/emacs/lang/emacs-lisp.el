;;; emacs-lisp.el --- Emacs Lisp configuration -*- lexical-binding: t; -*-

(use-package elisp-autofmt
  :ensure t
  :commands (elisp-autofmt-mode elisp-autofmt-buffer)
  :hook (emacs-lisp-mode . elisp-autofmt-mode)
  :config
  (setq elisp-autofmt-style 'fixed))

(provide 'lang-emacs-lisp)
;;; emacs-lisp.el ends here
