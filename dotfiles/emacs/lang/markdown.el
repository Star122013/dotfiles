;;; markdown.el --- Markdown configuration -*- lexical-binding: t; -*-

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :hook ((markdown-mode . visual-line-mode)))

(provide 'lang-markdown)
;;; markdown.el ends here
