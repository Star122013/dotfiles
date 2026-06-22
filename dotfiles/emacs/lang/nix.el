;;; nix.el --- Nix configuration -*- lexical-binding: t; -*-

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

(use-package nix-ts-mode
  :after nix-mode)

(add-hook 'nix-ts-mode-hook #'eglot-ensure)

(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs
   '(nix-ts-mode . ("nixd" "--inlay-hints=false")))
  (setq-default eglot-workspace-configuration
                '(:nixd
                  (:options
                   (:nixos
                    (:expr "{}")
                    :home-manager
                    (:expr
                     "(builtins.getFlake (builtins.toString /var/home/cyrene/.config/home-manager)).homeConfigurations.cyrene.options")))
                  :formatting (:command ["nixfmt"]))))

(provide 'lang-nix)
;;; nix.el ends here
