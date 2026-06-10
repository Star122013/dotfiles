;;; yaml.el --- YAML configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'major-mode-remap-alist '(yaml-mode . yaml-ts-mode)))

(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml\\'")

(provide 'lang-yaml)
;;; yaml.el ends here
