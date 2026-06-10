;;; bash.el --- Bash configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'major-mode-remap-alist '(bash-mode . bash-ts-mode)))

(provide 'lang-bash)
;;; bash.el ends here
