;;; rust.el --- Rust configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist
               '(rust . ("https://github.com/tree-sitter/tree-sitter-rust"))))

(provide 'lang-rust)
;;; rust.el ends here
