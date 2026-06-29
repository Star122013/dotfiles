;;; lang-config.el --- Per-language configuration -*- lexical-binding: t; -*-

;; ── Tree-sitter core ──────────────────────────────────────────────────────

(use-package treesit
  :custom
  (treesit-font-lock-level 4)
  (treesit-auto-install-grammar 'always)
  (treesit-enabled-modes t))

;; ── Bash ──────────────────────────────────────────────────────────────────

;; (no extra config needed)

;; ── CSS ───────────────────────────────────────────────────────────────────

;; (no extra config needed)

;; ── Dockerfile ────────────────────────────────────────────────────────────

(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'" "Containerfile\\'"))

;; ── Elixir ────────────────────────────────────────────────────────────────

(add-hook 'elixir-mode-hook #'eglot-ensure)
(add-hook 'elixir-ts-mode-hook #'eglot-ensure)

;; ── Emacs Lisp ────────────────────────────────────────────────────────────

(use-package elisp-autofmt
  :ensure t
  :commands (elisp-autofmt-mode elisp-autofmt-buffer)
  :hook (emacs-lisp-mode . elisp-autofmt-mode)
  :config
  (setq elisp-autofmt-style 'fixed))

;; ── Haskell ───────────────────────────────────────────────────────────────

(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs
   '(haskell-mode . ("haskell-language-server-wrapper" "--lsp"))))

;; ── JavaScript ────────────────────────────────────────────────────────────

;; (no extra config needed)

;; ── JSON ──────────────────────────────────────────────────────────────────

(use-package json-mode
  :ensure t
  :mode "\\.jsonc?\\'")

;; ── Markdown ──────────────────────────────────────────────────────────────

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :hook ((markdown-mode . visual-line-mode)))

;; markdown-ts-mode is built-in in Emacs 31 (experimental).
;; (treesit-enabled-modes t) does NOT auto-enable it yet.
;; Uncomment to opt in:
;; (use-package markdown-ts-mode :ensure nil)

;; ── Nix ───────────────────────────────────────────────────────────────────

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

;; Emacs 31's (treesit-enabled-modes t) auto-remaps nix-mode → nix-ts-mode.
;; nix-ts-mode is built-in, no need to install separately.
;; Since TS modes don't inherit hooks (Emacs 30+), hook both variants.
(add-hook 'nix-mode-hook #'eglot-ensure)
(add-hook 'nix-ts-mode-hook #'eglot-ensure)

(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs
   '(nix-mode . ("nixd" "--inlay-hints=false")))
  (setq-default eglot-workspace-configuration
                '(:nixd
                  (:options
                   (:nixos
                    (:expr "{}")
                    :home-manager
                    (:expr
                     "(builtins.getFlake (builtins.toString /var/home/cyrene/.config/home-manager)).homeConfigurations.cyrene.options")))
                  :formatting (:command ["nixfmt"]))))

;; ── Python ────────────────────────────────────────────────────────────────

(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'python-ts-mode-hook #'eglot-ensure)

;; ── Ruby ──────────────────────────────────────────────────────────────────

(add-hook 'ruby-mode-hook #'eglot-ensure)
(add-hook 'ruby-ts-mode-hook #'eglot-ensure)

;; ── Rust ──────────────────────────────────────────────────────────────────

;; (no extra config needed)

;; ── TOML ──────────────────────────────────────────────────────────────────

;; (no extra config needed)

;; ── TypeScript ────────────────────────────────────────────────────────────

;; (no extra config needed)

;; ── YAML ──────────────────────────────────────────────────────────────────

(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml\\'")

;; ── Zig ───────────────────────────────────────────────────────────────────

(use-package zig-mode
  :ensure t
  :mode ("\\.zig\\'" "\\.zon\\'")
  :hook ((zig-mode . eglot-ensure)
         (zig-ts-mode . eglot-ensure)))

(use-package zig-ts-mode
  :vc (:url "https://codeberg.org/meow_king/zig-ts-mode" :rev :newest)
  :after zig-mode)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(zig-ts-mode . ("zls")))
  (add-to-list 'eglot-server-programs '(zig-mode . ("zls"))))

(provide 'lang-config)
;;; lang-config.el ends here
