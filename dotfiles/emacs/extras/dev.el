;;; Emacs Bedrock
;;;
;;; Extra config: Development tools

;;; Usage: Append or require this file from init.el for some software
;;; development-focused packages.
;;;
;;; It is **STRONGLY** recommended that you use the base.el config if you want to
;;; use Eglot. Lots of completion things will work better.
;;;
;;; This will try to use tree-sitter modes for many languages. Please run
;;;
;;;   M-x treesit-install-language-grammar
;;;
;;; Before trying to use a treesit mode.

;;; Contents:
;;;
;;;  - Built-in config for developers
;;;  - Version Control
;;;  - Common file types
;;;  - Eglot, the built-in LSP client for Emacs
;;;  - Templating

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Built-in config for developers
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package treesit
  :config (setq treesit-font-lock-level 4)
  :init
  (setq treesit-language-source-alist
    '((elisp      . ("https://github.com/Wilfred/tree-sitter-elisp"))
      (rust       . ("https://github.com/tree-sitter/tree-sitter-rust"))
      (toml       . ("https://github.com/tree-sitter/tree-sitter-toml"))
      (json       . ("https://github.com/tree-sitter/tree-sitter-json"))
      (zig        . ("https://github.com/tree-sitter-grammars/tree-sitter-zig"))
      (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
      (nix        . ("https://github.com/nix-community/tree-sitter-nix")))))
  
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package emacs
  :config
  ;; Treesitter config

  ;; Tell Emacs to prefer the treesitter mode
  ;; You'll want to run the command `M-x treesit-install-language-grammar' before editing.
  (setq major-mode-remap-alist
        '((yaml-mode . yaml-ts-mode)
          (bash-mode . bash-ts-mode)
          (js2-mode . js-ts-mode)
          (typescript-mode . typescript-ts-mode)
          (json-mode . json-ts-mode)
          (css-mode . css-ts-mode)
	  (elisp-mode . elisp-ts-mode)
          (python-mode . python-ts-mode)))
  :hook
  ;; Auto parenthesis matching
  ((prog-mode . electric-pair-mode)))

(use-package envrc
  :vc (:url "https://codeberg.org/pastor/envrc")
  :bind
  (:map
   envrc-mode-map
   ("C-c e" . envrc-command-map))
  :config
  (setq envrc-indicator '(" [" (:eval (envrc--status)) "]"))
  :init
  (add-hook 'after-init-hook #'envrc-global-mode 99))

(use-package project
  :custom
  (when (>= emacs-major-version 30)
    (project-mode-line t)))         ; show project name in modeline

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Version Control
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Magit: best Git client to ever exist
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Common file types
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :hook ((markdown-mode . visual-line-mode)))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  :init
  (add-to-list 'major-mode-remap-alist '(nix-mode . nix-ts-mode)))
(use-package nix-ts-mode
  ;; :ensure t
  :after nix-mode
  :config)

(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'"
	 "Containerfile\\'")
  :config
  (add-to-list 'major-mode-remap-alist '(dockerfile-mode . dockerfile-ts-mode)))

(use-package yaml-mode
  :ensure t
  :mode "\\.ya?ml\\'")

(use-package json-mode
  :ensure t
  :mode "\\.jsonc?\\'")

(use-package zig-mode
  :ensure t
  :mode ("\\.zig\\'" 
         "\\.zon\\'")
  :init
  (add-to-list 'major-mode-remap-alist '(zig-mode . zig-ts-mode)))

(use-package zig-ts-mode
  :vc (:url "https://codeberg.org/meow_king/zig-ts-mode"
       :rev :newest)
  :after zig-mode
  :config)

;; Emacs ships with a lot of popular programming language modes. If it's not
;; built in, you're almost certain to find a mode for the language you're
;; looking for with a quick Internet search.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Eglot, the built-in LSP client for Emacs
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Helpful resources:
;;
;;  - https://www.masteringemacs.org/article/seamlessly-merge-multiple-documentation-sources-eldoc

(use-package eglot
  ;; no :ensure t here because it's built-in
  :bind (:map eglot-mode-map
	      ("C-c f" . eglot-format-buffer))
  ;; Configure hooks to automatically turn-on eglot for selected modes
  :hook
  (((python-mode ruby-mode elixir-mode zig-ts-mode nix-ts-mode) . eglot-ensure))

  :custom
  (eglot-send-changes-idle-time 0.1)
  (eglot-extend-to-xref t)              ; activate Eglot in referenced non-project files

  :config
  (fset #'jsonrpc--log-event #'ignore)  ; massive perf boost---don't log every event
  ;; Register language servers
  (add-to-list 'eglot-server-programs '(zig-ts-mode . ("zls")))
  (add-to-list 'eglot-server-programs '(nix-ts-mode . ("nixd" "--inlay-hints=false")))
  (add-to-list 'eglot-server-programs
               '(haskell-mode . ("haskell-language-server-wrapper" "--lsp")))
  (setq-default eglot-workspace-configuration
		'(:nixd (:options (:nixos (:expr "{}")
				  :home-manager (:expr "(builtins.getFlake (builtins.toString /var/home/cyrene/.config/home-manager)).homeConfigurations.cyrene.options")))
			:formatting (:command ["nixfmt"]))))


(use-package eldoc-box
  :ensure t
  :bind (:map prog-mode-map
              ("M-h" . eldoc-box-help-at-point)
	      ("M-n" . eldoc-box-scroll-up)
              ("M-p" . eldoc-box-scroll-down)))
(global-set-key (kbd "<f1>") #'eldoc)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Templating
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package tempel
  :ensure t
  ;; By default, tempel looks at the file "templates" in
  ;; user-emacs-directory, but you can customize that with the
  ;; tempel-path variable:
  ;; :custom
  ;; (tempel-path (concat user-emacs-directory "custom_template_file"))
  :bind (("M-*" . tempel-insert)
         ("M-+" . tempel-complete)
         :map tempel-map
         ("C-c RET" . tempel-done)
         ("C-<down>" . tempel-next)
         ("C-<up>" . tempel-previous)
         ("M-<down>" . tempel-next)
         ("M-<up>" . tempel-previous))
  :init
  ;; Make a function that adds the tempel expansion function to the
  ;; list of completion-at-point-functions (capf).
  (defun tempel-setup-capf ()
    (add-hook 'completion-at-point-functions #'tempel-expand -1 'local))
  ;; Put tempel-expand on the list whenever you start programming or
  ;; writing prose.
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

;; perspective tab or workspace
(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)         ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c p"))  ; pick your own prefix key here
  :init
  (persp-mode)
  :config
  (with-eval-after-load 'perspective
    (consult-customize consult-source-buffer :hidden t :default nil)
    (add-to-list 'consult-buffer-sources 'persp-consult-source)))

(use-package ghostel
  :ensure t
  :defer t)
