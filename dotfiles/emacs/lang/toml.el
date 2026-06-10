;;; toml.el --- TOML configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist
               '(toml . ("https://github.com/tree-sitter/tree-sitter-toml"))))

(provide 'lang-toml)
;;; toml.el ends here
