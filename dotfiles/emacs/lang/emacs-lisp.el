;;; emacs-lisp.el --- Emacs Lisp configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist
               '(elisp . ("https://github.com/Wilfred/tree-sitter-elisp")))
  (add-to-list 'major-mode-remap-alist '(elisp-mode . elisp-ts-mode)))

(use-package elisp-autofmt
  :ensure t
  :commands (elisp-autofmt-mode elisp-autofmt-buffer)
  :hook (emacs-lisp-mode . elisp-autofmt-mode)
  :config
  (setq elisp-autofmt-style 'fixed))

(provide 'lang-emacs-lisp)
;;; emacs-lisp.el ends here
