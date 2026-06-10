;;; python.el --- Python configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode)))

(add-hook 'python-mode-hook #'eglot-ensure)
;; `python-mode' is remapped to `python-ts-mode' when available.
(add-hook 'python-ts-mode-hook #'eglot-ensure)

(provide 'lang-python)
;;; python.el ends here
