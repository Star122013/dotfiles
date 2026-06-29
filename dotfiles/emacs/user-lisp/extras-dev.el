;;; dev.el  -*- lexical-binding: t;-*- 
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
  :custom (envrc-indicator '(" [" (:eval (envrc--status)) "]"))
  :hook (after-init-hook . envrc-global-mode))

(use-package
  project
  :custom
  (project-mode-line t)) ; show project name in modeline

(use-package
  rainbow-delimiters
  :ensure t
  :hook (prog-mode-hook . rainbow-delimiters-mode))
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

;; Per-language configuration — all in user-lisp/lang-config.el
(require 'lang-config)

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
  (eglot-documentation-renderer 'markdown-ts-view-mode)
  (eglot-code-action-indications nil) 
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

(setopt eldoc-help-at-pt t)
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
  :ensure t
  :bind
  ("C-x C-b" . persp-list-buffers) ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p")) ; pick your own prefix key here
  :config
  (persp-mode)
  (with-eval-after-load 'perspective
    (eval-when-compile (declare-function consult-customize "consult"))
    (consult-customize consult-source-buffer :hidden t :default nil)
    (add-to-list 'consult-buffer-sources 'persp-consult-source)))

;; ghostel needs a native module; run M-x ghostel-download-module if you want it.
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

(provide 'extras-dev)
