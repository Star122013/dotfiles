;;; typescript.el --- TypeScript configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'major-mode-remap-alist '(typescript-mode . typescript-ts-mode)))

(provide 'lang-typescript)
;;; typescript.el ends here
