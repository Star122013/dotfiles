;;; haskell.el --- Haskell configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs
   '(haskell-mode . ("haskell-language-server-wrapper" "--lsp"))))

(provide 'lang-haskell)
;;; haskell.el ends here
