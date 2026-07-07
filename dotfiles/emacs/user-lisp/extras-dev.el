;;; extras-dev.el --- Development tools -*- lexical-binding: t; -*-

;;; Commentary:
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
;;;  - Workspace management (tab-bar-mode + tabspaces)

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Built-in config for developers
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package emacs
  :hook
  ;; Auto parenthesis matching
  ((prog-mode . electric-pair-mode)))

(use-package envrc
  :vc (:url "https://codeberg.org/pastor/envrc")
  :bind-keymap ("C-c e" . envrc-command-map)
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

;; Flycheck diagnostics backend.
(use-package
  flycheck
  :ensure t
  :hook (prog-mode . flycheck-mode)
  :custom
  (flycheck-temp-prefix ".flycheck")
  (flycheck-check-syntax-automatically '(save idle-change new-line mode-enabled))
  (flycheck-emacs-lisp-load-path 'inherit)
  (flycheck-indication-mode 'right-fringe))

;; Bridge Eglot diagnostics into Flycheck.
(use-package flycheck-eglot
  :ensure t
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

;; A beautiful inline overlay for Flycheck
(use-package flyover
  :ensure t
  :hook ((flycheck-mode . flyover-mode)
         (flymake-mode . flyover-mode))
  :custom
  ;; Checker settings
  (flyover-checkers '(flycheck flymake))
  (flyover-levels '(error warning info))

  ;; Appearance
  (flyover-use-theme-colors t)
  (flyover-background-lightness 45)

  ;; Text tinting
  (flyover-text-tint 'lighter)
  (flyover-text-tint-percent 75)

  ;; Icon tinting (foreground and background)
  (flyover-icon-tint 'lighter)
  (flyover-icon-tint-percent 50)
  (flyover-icon-background-tint 'darker)
  (flyover-icon-background-tint-percent 50)

  ;; Icons
  ;; (flyover-info-icon " ")
  ;; (flyover-warning-icon " ")
  ;; (flyover-error-icon " ")

  ;; Border styles: none, pill, arrow, slant, slant-inv, flames, pixels
  (flyover-border-style 'none)
  (flyover-border-match-icon t)

  ;; Display settings
  (flyover-hide-checker-name t)
  (flyover-show-at-eol t)
  (flyover-show-virtual-line nil)
  (flyover-line-position-offset 0)

  ;; Message wrapping
  (flyover-wrap-messages t)
  ;; (flyover-max-line-length 80)

  ;; Performance
  (flyover-debounce-interval 0.2)
  (flyover-cursor-debounce-interval 0.3)

  ;; Display mode (controls cursor-based visibility)
  (flyover-display-mode 'hide-on-same-line)

  ;; Completion integration
  (flyover-hide-during-completion t))

(global-set-key (kbd "<f1>") #'eldoc)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Workspace management (tab-bar-mode + tabspaces)
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Uses Emacs built-in tab-bar-mode with tabspaces for buffer-isolated
;; workspace tabs. Replaces persp-mode.
;;
;; Quick start:
;;   M-x workspace-menu   — open the transient menu
;;   Or bind it:  (global-set-key (kbd "C-c w") #'workspace-menu)
;;
;; From the menu:
;;   s    — switch workspace
;;   n/d/r — new / delete / rename
;;   1-9  — switch by number
;;   ←/→  — prev / next
;;   w/l  — save / load session

(eval-when-compile
  (require 'cl-lib))

(use-package transient
  :ensure t
  :demand t)

(defvar my-main-workspace "Home"
  "Name of the primary workspace, which cannot be deleted.")

;;; tab-bar configuration

(use-package tab-bar
  :ensure nil
  :commands (tab-bar-new-tab
             tab-bar-switch-to-tab
             tab-bar-switch-to-next-tab
             tab-bar-switch-to-prev-tab)
  :custom
  (tab-bar-show 1)
  (tab-bar-tab-hints t)
  (tab-bar-new-tab-choice "*scratch*")
  (tab-bar-close-tab-select 'recent)
  (tab-bar-new-tab-to 'rightmost)
  (tab-bar-close-last-tab-choice 'tab-bar-mode-disable)
  (tab-bar-auto-width nil)
  (tab-bar-format '(tab-bar-format-history
                    tab-bar-format-tabs))
  (tab-bar-tab-close-button-show nil)
  :config
  (defun my-tab-bar-select-dwim ()
    "Select a tab. If only one tab exists, create one first."
    (interactive)
    (let ((tabs (mapcar (lambda (tab) (alist-get 'name tab))
                        (tab-bar--tabs-recent))))
      (cond ((null tabs) (tab-new))
            ((= (length tabs) 1) (tab-next))
            (t (tab-bar-switch-to-tab
                (completing-read "Select tab: " tabs nil t)))))))

;;; tabspaces

(use-package tabspaces
  :ensure t
  :hook (emacs-startup . tabspaces-mode)
  :custom
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-default-tab my-main-workspace)
  (tabspaces-remove-to-default t)
  (tabspaces-include-buffers '("*scratch*" "*dashboard*"))
  (tabspaces-session t)
  (tabspaces-session-auto-restore nil)
  :config
  ;; Consult integration
  (defun my-consult-tabspaces ()
    (require 'consult)
    (cond (tabspaces-mode
           (plist-put consult-source-buffer :hidden t)
           (plist-put consult-source-buffer :default nil)
           (add-to-list 'consult-buffer-sources 'consult--source-workspace))
          (t
           (plist-put consult-source-buffer :hidden nil)
           (plist-put consult-source-buffer :default t)
           (setq consult-buffer-sources
                 (remove 'consult--source-workspace consult-buffer-sources)))))
  (add-hook 'tabspaces-mode-hook #'my-consult-tabspaces))

;;; Consult workspace source

(with-eval-after-load 'consult
  (plist-put consult-source-buffer :hidden t)
  (plist-put consult-source-buffer :default nil)
  (defvar consult--source-workspace
    (list :name     "Workspace Buffers"
          :narrow   ?w
          :history  'buffer-name-history
          :category 'buffer
          :state    #'consult--buffer-state
          :default  t
          :items    (lambda () (consult--buffer-query
                                :predicate #'tabspaces--local-buffer-p
                                :sort 'visibility
                                :as #'buffer-name)))
    "Workspace buffer source for consult-buffer."))

;;; Workspace commands

(defun my/workspace-current-name ()
  "Return the current workspace tab name."
  (tabspaces--current-tab-name))

(defun my/workspace-list-names ()
  "Return a formatted string of all workspace names, highlighting the current one."
  (let ((current (my/workspace-current-name)))
    (mapconcat
     (lambda (name)
       (if (string= name current)
           (propertize (format "[%s]" name) 'face 'transient-value)
         name))
     (tabspaces--list-tabspaces)
     "  ")))

(defun my/workspace-new (name)
  "Create a new workspace with NAME."
  (interactive "sWorkspace name: ")
  (tab-new)
  (tab-bar-rename-tab name)
  (message "Created workspace: %s" name))

(defun my/workspace-switch ()
  "Switch to a workspace with completion."
  (interactive)
  (let* ((names (tabspaces--list-tabspaces))
         (name (completing-read "Switch to: " names nil t)))
    (tab-bar-switch-to-tab name)))

(defun my/workspace-kill ()
  "Delete the current workspace. The main workspace cannot be deleted."
  (interactive)
  (let ((name (my/workspace-current-name)))
    (if (string= name my-main-workspace)
        (message "Cannot delete the main workspace \"%s\"" my-main-workspace)
      (tab-close)
      (message "Deleted workspace: %s" name))))

(defun my/workspace-rename (name)
  "Rename the current workspace to NAME."
  (interactive "sNew name: ")
  (let ((old (my/workspace-current-name)))
    (tab-bar-rename-tab name)
    (message "Renamed workspace: %s \u2192 %s" old name)))

(defun my/workspace-switch-by-number (n)
  "Switch to the Nth workspace (1-indexed)."
  (let ((names (tabspaces--list-tabspaces)))
    (if (nth (1- n) names)
        (tab-bar-switch-to-tab (nth (1- n) names))
      (message "No workspace #%d" n))))

;;; Transient suffix commands

(transient-define-suffix my/workspace-transient-new ()
  "Create a new workspace."
  :description "New workspace"
  (interactive)
  (let ((name (read-string "Workspace name: ")))
    (my/workspace-new name)))

(transient-define-suffix my/workspace-transient-switch ()
  "Switch to another workspace."
  :description "Switch workspace"
  (interactive)
  (my/workspace-switch))

(transient-define-suffix my/workspace-transient-kill ()
  "Delete the current workspace."
  :description "Delete workspace"
  (interactive)
  (let ((name (my/workspace-current-name)))
    (if (string= name my-main-workspace)
        (message "Cannot delete the main workspace \"%s\"" my-main-workspace)
      (when (yes-or-no-p (format "Delete workspace \"%s\"? " name))
        (my/workspace-kill)))))

(transient-define-suffix my/workspace-transient-rename ()
  "Rename the current workspace."
  :description "Rename workspace"
  (interactive)
  (let* ((old (my/workspace-current-name))
         (new (read-string (format "Rename \"%s\" to: " old))))
    (my/workspace-rename new)))

(transient-define-suffix my/workspace-transient-next ()
  "Switch to the next workspace."
  :description "Next workspace"
  (interactive)
  (tab-bar-switch-to-next-tab))

(transient-define-suffix my/workspace-transient-prev ()
  "Switch to the previous workspace."
  :description "Prev workspace"
  (interactive)
  (tab-bar-switch-to-prev-tab))

(transient-define-suffix my/workspace-transient-save ()
  "Save the current session."
  :description "Save session"
  (interactive)
  (tabspaces-save-session)
  (message "Session saved"))

(transient-define-suffix my/workspace-transient-load ()
  "Load a session."
  :description "Load session"
  (interactive)
  (tabspaces-restore-session)
  (message "Session loaded"))

(defmacro my/workspace-transient-define-switch-n (n)
  `(transient-define-suffix ,(intern (format "my/workspace-transient-switch-%d" n)) ()
     ,(format "Switch to workspace #%d" n)
     :description ,(format "#%d" n)
     (interactive)
     (my/workspace-switch-by-number ,n)))

(my/workspace-transient-define-switch-n 1)
(my/workspace-transient-define-switch-n 2)
(my/workspace-transient-define-switch-n 3)
(my/workspace-transient-define-switch-n 4)
(my/workspace-transient-define-switch-n 5)
(my/workspace-transient-define-switch-n 6)
(my/workspace-transient-define-switch-n 7)
(my/workspace-transient-define-switch-n 8)
(my/workspace-transient-define-switch-n 9)

;;; Transient menu definition

(transient-define-prefix workspace-menu ()
  "Workspace management menu (tabspaces)."
  [:description
   (lambda ()
     (format "Workspaces: %s" (my/workspace-list-names)))
   ""]
  ["Navigate"
   :class transient-row
   ("<left>"  "\u2190 Prev"   my/workspace-transient-prev)
   ("<right>" "\u2192 Next"   my/workspace-transient-next)
   ("s"       "Switch"        my/workspace-transient-switch)]
  ["Switch by number"
   :class transient-row
   ("1" "#1" my/workspace-transient-switch-1)
   ("2" "#2" my/workspace-transient-switch-2)
   ("3" "#3" my/workspace-transient-switch-3)
   ("4" "#4" my/workspace-transient-switch-4)
   ("5" "#5" my/workspace-transient-switch-5)
   ("6" "#6" my/workspace-transient-switch-6)
   ("7" "#7" my/workspace-transient-switch-7)
   ("8" "#8" my/workspace-transient-switch-8)
   ("9" "#9" my/workspace-transient-switch-9)]
  ["Manage"
   ("n" "New"    my/workspace-transient-new)
   ("r" "Rename" my/workspace-transient-rename)
   ("d" "Delete" my/workspace-transient-kill)]
  ["Session"
   ("w" "Save" my/workspace-transient-save)
   ("l" "Load" my/workspace-transient-load)])

;; Bind the workspace menu
(global-set-key (kbd "C-c w") #'workspace-menu)

;; ghostel needs a native module; run M-x ghostel-download-module if you want it.
(use-package ghostel :ensure t :defer t)

;; (setq vc-handled-backends nil)

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

(provide 'extras-dev)
;;; extras-dev.el ends here
