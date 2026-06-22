;;; treesit.el --- Tree-sitter core configuration -*- lexical-binding: t; -*-

;; Centralised tree-sitter configuration.
;; All language grammar sources and major-mode remaps are declared here
;; rather than scattered across individual lang/*.el files.

;; ── Core tree-sitter settings ──────────────────────────────────────────────

(use-package treesit
  :custom
  (treesit-font-lock-level 4)
  (treesit-auto-install-grammar 'always)
  (treesit-enabled-modes t))


;; ── Language grammar sources & mode remaps ─────────────────────────────────

;; (with-eval-after-load 'treesit
;;   ;; Grammar download URLs (used by treesit-install-language-grammar)
;;   (dolist (src '((dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
;;                  (elisp     . ("https://github.com/Wilfred/tree-sitter-elisp"))
;;                  (json      . ("https://github.com/tree-sitter/tree-sitter-json"))
;;                  (nix       . ("https://github.com/nix-community/tree-sitter-nix"))
;;                  (rust      . ("https://github.com/tree-sitter/tree-sitter-rust"))
;;                  (toml      . ("https://github.com/tree-sitter/tree-sitter-toml"))
;;                  (zig       . ("https://github.com/tree-sitter-grammars/tree-sitter-zig"))))
;;     (add-to-list 'treesit-language-source-alist src))

;;   ;; Major-mode remappings (replace classic modes with their -ts-mode variants)
;;   (dolist (remap '((bash-mode        . bash-ts-mode)
;;                    (css-mode         . css-ts-mode)
;;                    (dockerfile-mode  . dockerfile-ts-mode)
;;                    (elisp-mode       . elisp-ts-mode)
;;                    (js2-mode         . js-ts-mode)
;;                    (json-mode        . json-ts-mode)
;;                    (nix-mode         . nix-ts-mode)
;;                    (python-mode      . python-ts-mode)
;;                    (typescript-mode  . typescript-ts-mode)
;;                    (yaml-mode        . yaml-ts-mode)
;;                    (zig-mode         . zig-ts-mode)))
;;     (add-to-list 'major-mode-remap-alist remap)))

(provide 'lang-treesit-core)
;;; treesit.el ends here
