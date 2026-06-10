;;; dockerfile.el --- Dockerfile configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist
               '(dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))))

(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'" "Containerfile\\'")
  :config
  (add-to-list 'major-mode-remap-alist
               '(dockerfile-mode . dockerfile-ts-mode)))

(provide 'lang-dockerfile)
;;; dockerfile.el ends here
