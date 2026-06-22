;;; python.el --- Python configuration -*- lexical-binding: t; -*-

(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'python-ts-mode-hook #'eglot-ensure)

(provide 'lang-python)
;;; python.el ends here
