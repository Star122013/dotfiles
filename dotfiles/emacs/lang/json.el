;;; json.el --- JSON configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist
               '(json . ("https://github.com/tree-sitter/tree-sitter-json")))
  (add-to-list 'major-mode-remap-alist '(json-mode . json-ts-mode)))

(use-package json-mode
  :ensure t
  :mode "\\.jsonc?\\'")

(provide 'lang-json)
;;; json.el ends here
