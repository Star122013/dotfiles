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
;;;  - Language modules
;;;  - Eglot, the built-in LSP client for Emacs
;;;  - Templating

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Built-in config for developers
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :hook
  ;; Auto parenthesis matching
  ((prog-mode . electric-pair-mode)))

(use-package
  envrc
  :vc (:url "https://codeberg.org/pastor/envrc")
  :bind (:map envrc-mode-map ("C-c e" . envrc-command-map))
  :config (setq envrc-indicator '(" [" (:eval (envrc--status)) "]"))
  :init (add-hook 'after-init-hook #'envrc-global-mode 99))

(use-package
  project
  :custom
  (when (>= emacs-major-version 30)
    (project-mode-line t))) ; show project name in modeline

(use-package
  rainbow-delimiters
  :ensure t
  :init (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Version Control
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ban vc-git for remote 
;; (setq vc-handled-backends nil)
;; Magit: best Git client to ever exist
(use-package magit :ensure t :bind (("C-x g" . magit-status)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Language modules
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Per-language configuration lives in dotfiles/emacs/lang/*.el.
;; Keep this file focused on shared development tools.
(defvar language-config-directory
  (expand-file-name "lang/" user-emacs-directory)
  "Directory containing per-language Emacs configuration files.")

(defun load-language-configs ()
  "Load all language configuration files from `language-config-directory'."
  (when (file-directory-p language-config-directory)
    (dolist (file (directory-files language-config-directory t "\\.el\\'"))
      (load-file file))))

(load-language-configs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Eglot, the built-in LSP client for Emacs
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Helpful resources:
;;
;;  - https://www.masteringemacs.org/article/seamlessly-merge-multiple-documentation-sources-eldoc

(use-package
  eglot
  ;; no :ensure t here because it's built-in
  :commands (eglot eglot-ensure)
  :bind (:map eglot-mode-map ("C-c f" . eglot-format-buffer))
  :custom
  (eglot-send-changes-idle-time 0.1)
  (eglot-extend-to-xref t) ; activate Eglot in referenced non-project files
  :config
  (fset #'jsonrpc--log-event #'ignore)) ; massive perf boost---don't log every event

;; Flymake diagnostics backend. Keep inline diagnostics off; popup is handled by flymake-popon.
(use-package flymake
  :ensure nil
  :custom
  (flymake-show-diagnostics-at-end-of-line nil)
  (flymake-no-changes-timeout 0.3)
  ;; Use margin signs, closer to nvim-lsp signcolumn than default fringe bitmaps.
  (flymake-indicator-type 'margins)
  (flymake-margin-indicator-position 'left-margin)
  ;; Avoid Nerd icon clipping in Emacs margins; use single-column signs.
  (flymake-margin-indicators-string
    '((error "✖" compilation-error)
      (warning "▲" compilation-warning)
      (note "●" compilation-info))))

;; Diagnostic popup at point, similar to `vim.diagnostic.open_float()`.
(use-package flymake-popon
  :ensure t
  :after flymake
  :hook (flymake-mode . flymake-popon-mode)
  :custom
  (flymake-popon-delay 0.2)
  (flymake-popon-method 'posframe)
  :custom-face
  (flymake-popon ((t (:background "#1e2228" :foreground "#bbc2cf")))))

;; Manual LSP hover/docs popup. Keep it manual to avoid fighting with Flymake popups.
(use-package
  eldoc-box
  :ensure t
  :bind
  (:map
    prog-mode-map
    ("M-h" . eldoc-box-help-at-point)
    ("M-n" . eldoc-box-scroll-up)
    ("M-p" . eldoc-box-scroll-down))
  :config
  (setq eldoc-box-clear-with-buffer-switch t)
  (setq eldoc-box-max-pixel-width 600
        eldoc-box-max-pixel-height 400)
  ;; LSP hover/docs popup. Diagnostics should not be shown here.
  (set-face-attribute 'eldoc-box-border nil
                      :background "#1c1f24")
  (set-face-attribute 'eldoc-box-body nil
                      :background "#1e2228"
                      :foreground "#bbc2cf")

  (defun my/eldoc-box-hide-flymake-diagnostics ()
    "Keep eldoc-box focused on LSP hover/docs, not Flymake diagnostics."
    (remove-hook 'eldoc-documentation-functions #'flymake-eldoc-function t))

  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (setq-local eldoc-documentation-strategy #'eldoc-documentation-compose)
              (my/eldoc-box-hide-flymake-diagnostics)))
  (add-hook 'flymake-mode-hook #'my/eldoc-box-hide-flymake-diagnostics 100)
  (add-hook 'eldoc-box-buffer-hook
            (lambda ()
              (setq-local header-line-format nil)
              (setq-local mode-line-format nil)
              (when (fboundp 'centaur-tabs-local-mode)
                (centaur-tabs-local-mode +1)))))
(global-set-key (kbd "<f1>") #'eldoc)

(use-package
  flycheck-package
  :ensure t
  :defer t
  :config (eval-after-load 'flycheck '(flycheck-package-setup)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Templating
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package
  tempel
  :ensure t
  ;; By default, tempel looks at the file "templates" in
  ;; user-emacs-directory, but you can customize that with the
  ;; tempel-path variable:
  ;; :custom
  ;; (tempel-path (concat user-emacs-directory "custom_template_file"))
  :bind
  (("M-*" . tempel-insert)
    ("M-+" . tempel-complete)
    :map
    tempel-map
    ("C-c RET" . tempel-done)
    ("C-<down>" . tempel-next)
    ("C-<up>" . tempel-previous)
    ("M-<down>" . tempel-next)
    ("M-<up>" . tempel-previous))
  :init
  ;; Make a function that adds the tempel expansion function to the
  ;; list of completion-at-point-functions (capf).
  (defun tempel-setup-capf ()
    (add-hook 'completion-at-point-functions #'tempel-expand
      -1
      'local))
  ;; Put tempel-expand on the list whenever you start programming or
  ;; writing prose.
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

;; perspective tab or workspace
(use-package
  perspective
  :bind
  ("C-x C-b" . persp-list-buffers) ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p")) ; pick your own prefix key here
  :init (persp-mode)
  :config
  (with-eval-after-load 'perspective
    (consult-customize consult-source-buffer :hidden t :default nil)
    (add-to-list 'consult-buffer-sources 'persp-consult-source)))

(use-package ghostel :ensure t :defer t)

(setq vc-handled-backends nil)

;; (use-package
;;   tramp-rpc
;;   :after tramp
;;   :vc
;;   (:url
;;     "https://github.com/ArthurHeymans/emacs-tramp-rpc"
;;     :rev
;;     :newest
;;     :lisp-dir "lisp"))

(use-package xterm-color
  :ensure t)

(setq compilation-environment '("TERM=xterm-256color"))

(defun my/advice-compilation-filter (f proc string)
  (funcall f proc (xterm-color-filter string)))

(advice-add 'compilation-filter :around #'my/advice-compilation-filter)
