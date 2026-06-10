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
  (doom-modeline-persp-name t)
  (doom-modeline-persp-icon t)
  (doom-modeline-buffer-file-name-style 'file-name)
  (doom-modeline-position-column-line-format '("%l:%c"))
  (doom-modeline-minor-modes nil)
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
(use-package git-gutter
  :ensure t
  :hook ((prog-mode . git-gutter-mode)
         (text-mode . git-gutter-mode))
  :custom
  (git-gutter:update-interval 0.5)
  (git-gutter:added-sign "▎")
  (git-gutter:modified-sign "▎")
  (git-gutter:deleted-sign "▁")
  :custom-face
  (git-gutter:added ((t (:foreground "#98be65" :background "#98be65"))))
  (git-gutter:modified ((t (:foreground "#ECBE7B" :background "#ECBE7B"))))
  (git-gutter:deleted ((t (:foreground "#ff6c6b" :background "#ff6c6b")))))

;; tabbar
(use-package
  centaur-tabs
  :ensure t
  :demand t
  :config
  (setq
    centaur-tabs-style "bar"
    centaur-tabs-set-bar 'under
    x-underline-at-descent-line t
    centaur-tabs-height 32
    centaur-tabs-icon-type 'nerd-icons
    centaur-tabs-set-icons t
    centaur-tabs-set-modified-marker t
    centaur-tabs-modified-marker "●")

  (defun my-centaur-tabs-hide-filter (buffer)
    (let ((name (buffer-name buffer)))
      (and (string-prefix-p "*" name)
        (not (string-match-p "ghostel" name)))))
  (setq centaur-tabs-hide-tab-function #'my-centaur-tabs-hide-filter)
  (setq uniquify-separator "/")
  (setq uniquify-buffer-name-style 'forward)

  (advice-add
    'centaur-tabs-get-buffers
    :filter-return
    (lambda (buffers)
      (seq-filter
        (lambda (buf)
          (let ((name (buffer-name buf)))
            (not
              (and (string-prefix-p "*" name)
                (not (string-match-p "ghostel" name))))))
        buffers)))

  ;; Centaur Tabs uses Emacs' tab-line/header-line, so it appears on every
  ;; split window.  Hide it while the frame has multiple windows to avoid a
  ;; repeated tabbar on each window, closer to Neovim's single global tabline.
  (defvar-local my-centaur-tabs-auto-hidden nil)

  (defun my-centaur-tabs-set-auto-hidden (hide)
    (when (bound-and-true-p centaur-tabs-mode)
      (cond
        ((and hide (not centaur-tabs-local-mode))
          (ignore-errors
            (centaur-tabs-local-mode 1)
            (setq my-centaur-tabs-auto-hidden t)))
        ((and (not hide) my-centaur-tabs-auto-hidden)
          (ignore-errors
            (centaur-tabs-local-mode -1)
            (setq my-centaur-tabs-auto-hidden nil))))))

  (defun my-centaur-tabs-update-window-visibility (&rest _)
    (let ((hide (> (length (window-list nil 'no-minibuf)) 1)))
      (dolist (buffer (buffer-list))
        (with-current-buffer buffer
          (my-centaur-tabs-set-auto-hidden hide)))))

  (add-hook 'window-configuration-change-hook #'my-centaur-tabs-update-window-visibility)
  (add-hook 'buffer-list-update-hook #'my-centaur-tabs-update-window-visibility)
  (centaur-tabs-mode t)
  (my-centaur-tabs-update-window-visibility)

  :bind
  ("M-<left>" . centaur-tabs-backward)
  ("M-<right>" . centaur-tabs-forward)
  :hook
  (dashboard-mode . centaur-tabs-local-mode)
  (navigel-tablist-mode . centaur-tabs-local-mode)
  ;; (eldoc-mode . centaur-tabs-local-mode)
  (mpdel-browser-mode . centaur-tabs-local-mode)
  (mpdel-song-mode . centaur-tabs-local-mode)
  (mpdel-tablist-mode . centaur-tabs-local-mode)
  (dirvish-directory-view-mode . centaur-tabs-local-mode)
  (dirvish-special-preview-mode . centaur-tabs-local-mode)
  (dired-mode . centaur-tabs-local-mode)
  (elfeed-show-mode . centaur-tabs-local-mode)
  (elfeed-search-mode . centaur-tabs-local-mode)
  (helpful-mode . centaur-tabs-local-mode)
  (mpdel-playlist-mode . centaur-tabs-local-mode)
  (magit-process-mode . centaur-tabs-local-mode)
  (magit-status-mode . centaur-tabs-local-mode)
  (magit-diff-mode . centaur-tabs-local-mode)
  (magit-log-mode . centaur-tabs-local-mode)
  (magit-file-mode . centaur-tabs-local-mode)
  (magit-blob-mode . centaur-tabs-local-mode)
  (magit-blame-mode . centaur-tabs-local-mode)
  (calendar-mode . centaur-tabs-local-mode)
  (org-agenda-mode . centaur-tabs-local-mode)
  (pdf-view-mode . centaur-tabs-local-mode)
  (ement-room-list-mode . centaur-tabs-local-mode)
  (ement-room-mode . centaur-tabs-local-mode)
  (ghostel-mode . centaur-tabs-local-mode)
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


;; Set up dashboard
(use-package
  dashboard
  :ensure t
  ;; :if my-use-dashboard
  :diminish dashboard-mode
  :bind
  (("<f2>" . open-dashboard)
    :map
    dashboard-mode-map
    ("q" . quit-dashboard)
    ("M-r" . restore-session))
  :hook (dashboard-mode . (lambda () (setq-local frame-title-format nil)))
  :init
  (add-hook 'window-setup-hook (lambda () (dashboard-refresh-buffer)))
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-navigator-buttons
    `
    (
      (
        (
          ,
          (if (fboundp 'nerd-icons-octicon)
            (nerd-icons-octicon "nf-oct-mark_github"))
          "GitHub"
          "Browse"
          (lambda (&rest _) (browse-url homepage-url)))
        (
          ,
          (if (fboundp 'nerd-icons-octicon)
            (nerd-icons-octicon "nf-oct-history"))
          "Restore"
          "Restore previous session"
          (lambda (&rest _) (persp-load-state-from-file)))
        (
          ,
          (if (fboundp 'nerd-icons-octicon)
            (nerd-icons-octicon "nf-oct-tools"))
          "Settings"
          "Open custom file"
          (lambda (&rest _) (find-file custom-file)))
        (
          ,
          (if (fboundp 'nerd-icons-octicon)
            (nerd-icons-octicon "nf-oct-download"))
          "Upgrade"
          "Upgrade packages synchronously"
          (lambda (&rest _) (package-upgrade-all nil))
          success))))
  (dashboard-setup-startup-hook)
  :config (defconst homepage-url "https://github.com/Star122013")

  ;; restore-session
  (defun restore-session ()
    "Restore the previous session."
    (interactive)
    (message "Restoring previous session...")
    (quit-window t)


    (message "Restoring previous session...done"))

  ;; recover layouts
  (defvar dashboard-recover-layout-p nil
    "Whether recovers the layout.")

  ;; open dashboard
  (defun open-dashboard ()
    "Open the *dashboard* buffer and jump to the first widget."
    (interactive)
    (if
      (length>
        (window-list-1)
        (if
          (and (fboundp 'treemacs-current-visibility)
            (eq (treemacs-current-visibility) 'visible))
          2
          1))
      (setq dashboard-recover-layout-p t))

    (delete-other-windows)

    (dashboard-refresh-buffer))

  (defun quit-dashboard ()
    "Quit dashboard window."
    (interactive)
    (quit-window t)


    (when dashboard-recover-layout-p
      (cond
        ((bound-and-true-p tab-bar-history-mode)
          (tab-bar-history-back))
        ((bound-and-true-p winner-mode)
          (winner-undo)))
      (setq dashboard-recover-layout-p nil)))
  :custom-face
  (dashboard-heading ((t (:inherit (font-lock-string-face bold)))))
  (dashboard-items-face ((t (:weight normal))))
  (dashboard-no-items-face ((t (:weight normal))))
  :custom
  (dashboard-icon-type 'nerd-icons)
  (dashboard-page-separator "\f\n")
  (dashboard-projects-backend 'projectile)
  (dashboard-path-style 'truncate-middle)
  (dashboard-path-max-length 60)
  (dashboard-startup-banner "~/.config/emacs/assets/GNUEmacs.png")
  (dashboard-image-banner-max-width 400)
  (dashboard-set-heading-icons t)
  ;; (dashboard-show-shortcuts nil)
  (dashboard-set-file-icons t)
  (dashboard-items '((recents . 10) (bookmarks . 5) (projects . 7)))
  (dashboard-startupify-list
    '
    (dashboard-insert-banner
      dashboard-insert-newline
      dashboard-insert-banner-title
      dashboard-insert-newline
      dashboard-insert-navigator
      dashboard-insert-newline
      dashboard-insert-init-info
      dashboard-insert-items
      dashboard-insert-newline
      dashboard-insert-footer)))

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
