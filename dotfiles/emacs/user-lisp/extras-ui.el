;;; ui.el -*- lexical-binding: t; -*-
;; Set up doom-modeline
(use-package
  doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-icon t)
  (doom-modeline-bar-width 4)
  (doom-modeline-project-name t)
  (doom-modeline-workspace-name t)
  ;; NOTE: doom-modeline only supports `persp-mode', NOT `perspective'.
  ;; These two are no-ops with the `perspective' package — leave disabled
  ;; unless you switch to `persp-mode'.
  ;; (doom-modeline-persp-name t)
  ;; (doom-modeline-persp-icon t)
  (doom-modeline-buffer-file-name-style 'file-name)
  (doom-modeline-position-column-line-format '("%l:%c"))
  (doom-modeline-minor-modes t)
  (doom-modeline-indent-info t)
  (doom-modeline-vcs-icon t)
  (doom-modeline-vcs-max-length 15)
  (doom-modeline-check 'auto)
  (doom-modeline-lsp t)
  (doom-modeline-time t)
  (doom-modeline-time-analogue-clock t))

(use-package minions :ensure t :config (minions-mode 1))

;; Git gutter, similar to gitsigns.nvim.
;; Use git-gutter instead of diff-hl because vc-handled-backends is disabled.
(use-package
  git-gutter
  :ensure t
  :hook ((prog-mode . git-gutter-mode) (text-mode . git-gutter-mode))
  :custom
  (git-gutter:update-interval 0.5)
  (git-gutter:added-sign "▎")
  (git-gutter:modified-sign "▎")
  (git-gutter:deleted-sign "▁")
  :custom-face
  (git-gutter:added
    ((t (:foreground "#98be65" :background "#98be65"))))
  (git-gutter:modified
    ((t (:foreground "#ECBE7B" :background "#ECBE7B"))))
  (git-gutter:deleted
    ((t (:foreground "#ff6c6b" :background "#ff6c6b")))))

;; tab-bar
(use-package
  centaur-tabs
  :ensure t
  :init (setq centaur-tabs-enable-key-bindings t)
  :config
  (setq
    centaur-tabs-style "bar"
    centaur-tabs-height 32
    centaur-tabs-set-icons t
    centaur-tabs-show-new-tab-button t
    centaur-tabs-set-modified-marker t
    centaur-tabs-show-navigation-buttons t
    centaur-tabs-set-bar 'under
    centaur-tabs-show-count nil
    ;; centaur-tabs-label-fixed-length 15
    ;; centaur-tabs-gray-out-icons 'buffer
    ;; centaur-tabs-plain-icons t
    x-underline-at-descent-line t
    centaur-tabs-left-edge-margin nil)
  (centaur-tabs-headline-match)
  ;; (centaur-tabs-enable-buffer-alphabetical-reordering)
  ;; (setq centaur-tabs-adjust-buffer-order t)
  (centaur-tabs-mode t)
  (setq uniquify-separator "/")
  (setq uniquify-buffer-name-style 'forward)
  (defun centaur-tabs-buffer-groups ()
    "`centaur-tabs-buffer-groups' control buffers' group rules.

Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
All buffer name start with * will group to \"Emacs\".
Other buffer group by `centaur-tabs-get-group-name' with project name."
    (list
      (cond
        ;; ((not (eq (file-remote-p (buffer-file-name)) nil))
        ;; "Remote")
        (
          (or (string-equal "*" (substring (buffer-name) 0 1))
            (memq
              major-mode
              '
              (magit-process-mode
                magit-status-mode
                magit-diff-mode
                magit-log-mode
                magit-file-mode
                magit-blob-mode
                magit-blame-mode)))
          "Emacs")
        ((derived-mode-p 'prog-mode)
          "Editing")
        ((derived-mode-p 'dired-mode)
          "Dired")
        ((memq major-mode '(helpful-mode help-mode))
          "Help")
        (
          (memq
            major-mode
            '
            (org-mode
              org-agenda-clockreport-mode
              org-src-mode
              org-agenda-mode
              org-beamer-mode
              org-indent-mode
              org-bullets-mode
              org-cdlatex-mode
              org-agenda-log-mode
              diary-mode))
          "OrgMode")
        (t
          (centaur-tabs-get-group-name (current-buffer))))))
  :hook
  (dashboard-mode . centaur-tabs-local-mode)
  (term-mode . centaur-tabs-local-mode)
  (calendar-mode . centaur-tabs-local-mode)
  (org-agenda-mode . centaur-tabs-local-mode)
  :bind
  ("C-<prior>" . centaur-tabs-backward)
  ("C-<next>" . centaur-tabs-forward)
  ("C-S-<prior>" . centaur-tabs-move-current-tab-to-left)
  ("C-S-<next>" . centaur-tabs-move-current-tab-to-right))

;; Colorize color names in buffers
(use-package
  colorful-mode
  :ensure t
  :diminish
  :hook (after-init . global-colorful-mode)
  :init (setq colorful-use-prefix t)
  :config
  (dolist
    (mode
      '(html-mode php-mode emacs-lisp-mode help-mode helpful-mode))
    (add-to-list 'global-colorful-modes mode)))


;; ─── Dashboard ──────────────────────────────────────────────────────────────
;;
;; An extensible Emacs startup screen (like Doom Emacs's dashboard).
;; https://github.com/emacs-dashboard/dashboard
;;

;; Helper: insert a page break (^L) that page-break-lines renders as a line.
(defun dashboard-insert-page-break ()
  "Insert a page break separator for `dashboard'."
  (insert "\n\f\n\n"))

(use-package dashboard
  :ensure t
  :custom
  ;; ── Banner ──────────────────────────────────────────────────────────────
  (dashboard-startup-banner
   "~/.config/emacs/assets/GNUEmacs.png")
  (dashboard-banner-logo-title "♦ Do what I mean")
  (dashboard-image-banner-max-width 600)
  (dashboard-image-banner-max-height 300)

  ;; ── Layout ──────────────────────────────────────────────────────────────
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-show-shortcuts t)
  (dashboard-navigation-cycle t)

  ;; ── Items ───────────────────────────────────────────────────────────────
  (dashboard-items '((recents   . 5)
                     (bookmarks . 5)
                     (projects  . 5)))
  (dashboard-item-shortcuts '((recents   . "r")
                              (bookmarks . "m")
                              (projects  . "p")))
  (dashboard-heading-shorcut-format " [%s]")

  ;; ── Icons (nerd-icons) ──────────────────────────────────────────────────
  (dashboard-display-icons-p t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)

  ;; ── Projects ────────────────────────────────────────────────────────────
  ;; Use the built-in `project' package (configured in dev.el) instead of
  ;; `projectile', which is not installed.
  (dashboard-projects-backend 'project-el)

  ;; ── Path display ────────────────────────────────────────────────────────
  (dashboard-path-max-length 60)

  ;; ── Widget order ────────────────────────────────────────────────────────
  (dashboard-startupify-list
   '(dashboard-insert-banner
     dashboard-insert-banner-title
     dashboard-insert-page-break
     dashboard-insert-items
     dashboard-insert-page-break
     dashboard-insert-footer
     dashboard-insert-init-info))
  :config
  (setq initial-buffer-choice 'dashboard-open)
  (dashboard-setup-startup-hook))

;; Display ugly ^L page breaks as tidy horizontal lines
(use-package
  page-break-lines
  :ensure t
  :defer t
  :diminish
  :hook (after-init . global-page-break-lines-mode)
  :config
  (dolist (mode '(dashboard-mode emacs-news-mode))
    (add-to-list 'page-break-lines-modes mode)))

(provide 'extras-ui)
