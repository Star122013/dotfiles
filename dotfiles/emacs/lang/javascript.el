;;; javascript.el --- JavaScript configuration -*- lexical-binding: t; -*-

(with-eval-after-load 'treesit
  (add-to-list 'major-mode-remap-alist '(js2-mode . js-ts-mode)))

(provide 'lang-javascript)
;;; javascript.el ends here
