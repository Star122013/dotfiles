;;; 00-treesit.el --- Tree-sitter core configuration -*- lexical-binding: t; -*-

(use-package treesit
  :config
  (setq treesit-font-lock-level 4))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(provide 'lang-treesit-core)
;;; 00-treesit.el ends here
