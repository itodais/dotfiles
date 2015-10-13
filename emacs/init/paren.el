;; show paren
(show-paren-mode 1)
(custom-set-variables
 '(show-paren-delay 0)
 '(show-paren-style 'expression)
 '(parens-require-spaces nil))

;;;; Paredit
(require 'paredit)

(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))
(add-hook 'geiser-repl-mode-hook      (lambda () (paredit-mode +1)))
(add-hook 'ielm-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'clojure-mode-hook          (lambda () (paredit-mode +1)))

(provide 'setup-paredit)

(with-eval-after-load 'paredit
  (define-key paredit-mode-map (kbd "C-c C-l") 'editutil-toggle-let)
  (define-key paredit-mode-map (kbd "DEL") 'editutil-paredit-backward-delete)
  (define-key paredit-mode-map (kbd "C-c C-q") 'paredit-reindent-defun)
  (define-key paredit-mode-map (kbd "M-q") 'nil)
  (define-key paredit-mode-map (kbd "M-)") 'move-past-close-and-reindent))
