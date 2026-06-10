;;; zig.el --- Zig configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'treesit-language-source-alist
               '(zig . ("https://github.com/tree-sitter-grammars/tree-sitter-zig"))))

(use-package zig-mode
  :ensure t
  :mode ("\\.zig\\'" "\\.zon\\'")
  :init
  (add-to-list 'major-mode-remap-alist '(zig-mode . zig-ts-mode)))

(use-package zig-ts-mode
  :vc (:url "https://codeberg.org/meow_king/zig-ts-mode" :rev :newest)
  :after zig-mode)

;; Normal path: .zig -> zig-mode -> zig-ts-mode, then Eglot starts here.
(add-hook 'zig-ts-mode-hook #'eglot-ensure)

;; Fallback path: if tree-sitter remap is unavailable, still start Eglot in zig-mode.
(add-hook 'zig-mode-hook #'eglot-ensure)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(zig-ts-mode . ("zls")))
  (add-to-list 'eglot-server-programs '(zig-mode . ("zls"))))

(provide 'lang-zig)
;;; zig.el ends here
