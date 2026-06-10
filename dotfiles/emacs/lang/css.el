;;; css.el --- CSS configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'major-mode-remap-alist '(css-mode . css-ts-mode)))

(provide 'lang-css)
;;; css.el ends here
