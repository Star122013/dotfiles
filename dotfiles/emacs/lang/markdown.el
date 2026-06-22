;;; markdown.el --- Markdown configuration -*- lexical-binding: t; -*-

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :hook ((markdown-mode . visual-line-mode)))

(use-package markdown-ts-mode
  :ensure nil
  :defer t)

(provide 'lang-markdown)
;;; markdown.el ends here
