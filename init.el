                                        ; Default settings
(setq inhibit-startup-message t)
(setq backup-directory-alist `(("." . , (expand-file-name "~/.tmp/emacs"))))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "~/.tmp/emacs"))))
(setq make-backup-files nil)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)
(setq show-paren-delay 0)
(setq show-paren-when-point-inside-paren t)
(show-paren-mode 1)
(setq mouse-autoselect-window t)
(setq tramp-ssh-controlmaster-options "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")
(set-default 'truncate-lines t)
(menu-bar-mode -1)
(global-auto-revert-mode 1)
(setq auto-revert-check-vc-info t)
(setq vc-follow-symlinks t)
;; Show current line and column number in mode line
(setq column-number-mode t)

                                        ; Performance improvement
(setq redisplay-dont-pause t)
(byte-recompile-directory (expand-file-name "~/.emacs.d"))

                                        ; Package configuration
(setq use-package-always-ensure t)
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)
(require 'use-package)

                                        ; use-package statements
(use-package linum-relative)
;; color-theme-solarized depends on color-theme
(use-package color-theme)
(use-package color-theme-solarized)

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package evil
  :config
  (evil-mode 1))

(use-package evil-mc
  :config
  (global-evil-mc-mode  1))

(use-package projectile)
(use-package helm
  :init
  (setq helm-display-header-line nil)
  (setq helm-buffer-max-length nil)
  (setq helm-display-header-line nil)
  (setq helm-ff-skip-boring-files t)
  (setq projectile-completion-system 'helm)
  (setq helm-boring-buffer-regexp-list '("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*tramp" "\\*Minibuf" "\\*Messages" "\\*"))
  (defun helm-display-mode-line (source &optional force) (setq mode-line-format nil))
  (defadvice helm-display-mode-line (after undisplay-header activate)
    (setq header-line-format nil))
  :config
  (projectile-global-mode)
  (helm-autoresize-mode 1)
  (helm-projectile-on))

(use-package helm-projectile)
(use-package helm-ag)
(use-package mo-git-blame)

(use-package git-gutter
  :init
  '(custom-set-variables
    :init
    '(ccm-ignored-commands
      (quote
       (mouse-drag-region mouse-set-point widget-button-click scroll-bar-toolkit-scroll evil-goto-line)))
    '(git-gutter:window-width 2)
    '(git-gutter:added-sign "+ ")
    '(git-gutter:deleted-sign "- ")
    '(git-gutter:modified-sign "~ ")
    '(package-selected-packages
      (quote
       (less-css-mode tide whitespace-cleanup-mode web-mode use-package sublimity spaceline solarized-theme scss-mode relative-line-numbers powerline-evil php-mode mo-git-blame magit linum-relative jsx-mode json-mode indent-guide helm-projectile helm-ag git-gutter flycheck-typescript-tslint flycheck-flow flycheck-css-colorguard evil-terminal-cursor-changer evil-multiedit evil-mc evil-easymotion evil-commentary evil-args ensime emacs-eclim editorconfig-core editorconfig company-tern column-marker color-theme-solarized color-theme-sanityinc-solarized cider centered-cursor-mode ag ac-js2))))
  :config
  (global-git-gutter-mode +1)
  (git-gutter:linum-setup))

(use-package column-marker
  :init
  (setq fill-column 20)
  :config
  (column-marker-1 20))

(defun my-dev-hooks ()
  (linum-relative-mode 1)
  (whitespace-cleanup-mode))

(use-package whitespace
  :init
  (setq whitespace-style '(face empty tabs lines-tail trailing))
  (setq whitespace-line-column 120)
  :config
  (global-whitespace-mode t))

(use-package centered-cursor-mode
  :init
  (setq scroll-step 1)
  (setq scroll-margin 0)
  :config
  (global-centered-cursor-mode +1))

(use-package sublimity
  :config
  (sublimity-mode 1))

(use-package company
  :init
  (setq company-dabbrev-downcase nil)
  (setq company-idle-delay 0)
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (add-to-list 'company-backends 'company-tern)
  (company-mode 1))

(use-package tern
  :init
  (setq tern-command '("tern" "--no-port-file"))
  :config
  (tern-mode 1))

(use-package tide
  :init
  (setq company-tooltip-align-annotations t)
  (setq tide-tsserver-executable "node_modules/typescript/bin/tsserver")
  ;; /Users/tbo/.nvm/versions/node/v6.8.1/bin/tsserver
  (setq tide-format-options '())
  :config
  ;; (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode))

(use-package company-tern)

(use-package indent-guide
  :config
  (indent-guide-global-mode))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

(use-package web-mode
  :init
  (setq web-mode-enable-auto-closing t)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
                ;; (setq tide-tsserver-directory "/home/tbo/rebelle/node_modules/typescript/lib")
                ;; (setq tide-tsserver-executable "/home/tbo/rebelle/node_modules/typescript/bin/tsserver")
                (setup-tide-mode)
                (setq flycheck-check-syntax-automatically '(save mode-enabled))
                (eldoc-mode +1))))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode)))

(use-package editorconfig
         :config
         (editorconfig-mode 1))

(use-package evil-commentary
  :config
  (evil-commentary-mode))

(use-package avy
  :init
  (define-key evil-normal-state-map (kbd "c") 'avy-goto-word-or-subword-1))

(use-package flycheck
  :init
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  :config
  ;; disable jshint since we prefer eslint checking
  (setq-default flycheck-disabled-checkers (append flycheck-disabled-checkers '(javascript-jshint)))
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (global-flycheck-mode))

(use-package evil-args)

(use-package whitespace-cleanup-mode)

(use-package intero
  :config
  (add-hook 'haskell-mode-hook 'intero-mode)
  (add-hook 'intero-mode-hook 'my-dev-hooks))

(use-package lua-mode)

(add-hook 'emacs-lisp-mode-hook 'my-dev-hooks)
(add-hook 'latex-mode-hook 'my-dev-hooks)
(add-hook 'java-mode-hook 'my-dev-hooks)
(add-hook 'js-mode-hook 'my-dev-hooks)
(add-hook 'clojure-mode-hook 'my-dev-hooks)
(add-hook 'web-mode-hook 'my-dev-hooks)
(add-hook 'web-mode-hook (lambda () (tern-mode t)))
(add-hook 'scss-mode-hook 'my-dev-hooks)
(add-hook 'feature-mode-hook 'my-dev-hooks)
(add-hook 'less-css-mode-hook 'my-dev-hooks)
(add-hook 'haskell-mode-hook 'my-dev-hooks)
(add-hook 'lua-mode-hook 'my-dev-hooks)
(add-hook 'typescript-mode-hook
          (lambda ()
            (setq web-mode-tag-auto-close-style 1)
            (tide-setup)
            (my-dev-hooks)
            (eldoc-mode +1)))

                                        ;key bindings
(define-key evil-normal-state-map (kbd "f") 'helm-buffers-list)

;; bind evil-args text objects
(define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
(define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

;; bind evil-forward/backward-args
(define-key evil-normal-state-map "L" 'evil-forward-arg)
(define-key evil-normal-state-map "H" 'evil-backward-arg)
(define-key evil-motion-state-map "L" 'evil-forward-arg)
(define-key evil-motion-state-map "H" 'evil-backward-arg)

;; bind evil-jump-out-args
(define-key evil-normal-state-map "K" 'evil-jump-out-args)
(define-key evil-normal-state-map (kbd "s") 'save-buffer)

;; (define-key evil-normal-state-map "m" nil)
(define-key evil-normal-state-map (kbd "SPC") nil)
;; (define-key evil-normal-state-map (kbd "mm") (lambda () (interactive) (evil-force-normal-state) (keyboard-quit)))
;; (define-key evil-normal-state-map (kbd "mj") 'evil-mc-resume-cursors)
;; (define-key evil-normal-state-map (kbd "mk") 'evil-mc-undo-all-cursors)
                                        ;l (define-key evil-normal-state-map (kbd "mn") 'evil-mc-make-all-cursors)
(define-key evil-normal-state-map (kbd "t") 'helm-projectile-ag)
;; (define-key evil-normal-state-map (kbd "SPC") 'helm-projectile)
(define-key evil-normal-state-map (kbd ";") 'evil-ex)
(define-key evil-normal-state-map (kbd "SPC") 'projectile-find-file)
(define-key helm-map (kbd "SPC") 'helm-keyboard-quit)

(server-start)

(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

                                        ; Graphical improvements
(set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?┃))
(setq linum-relative-format "%2s \u2502 ")
;; Truncate all messages in echo line (no more jumping)
(setq message-truncate-lines t)
;; Removes flicker when using recenter
(setq recenter-redisplay nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(frame-background-mode (quote dark))
 '(package-selected-packages
   (quote
    (undo-tree smartparens evil-smartparens tide ensime markdown-mode whitespace-cleanup-mode web-mode use-package tidy sublimity spaceline solarized-theme scss-mode scala-mode2 relative-line-numbers powerline-evil php-mode mo-git-blame magit linum-relative less-css-mode jsx-mode json-mode indent-guide helm-projectile helm-ag git-gutter flycheck-typescript-tslint flycheck-flow flycheck-css-colorguard feature-mode evil-terminal-cursor-changer evil-multiedit evil-mc evil-easymotion evil-commentary evil-args emacs-eclim editorconfig-core editorconfig company-tern column-marker color-theme-solarized color-theme-sanityinc-solarized cider centered-cursor-mode ag ac-js2))))
(load-theme 'solarized t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(linum ((t (:inherit (shadow default) :background nil))))
 '(linum-relative-current-face ((t (:inherit (shadow default) :background nil)))))

(global-hl-line-mode +1)
(make-face 'mode-line-inverted-face)
(make-face 'mode-line-face)
(set-face-attribute 'mode-line-face nil
                    :foreground "#93a1a1" :background "black")
(set-face-attribute 'mode-line-inverted-face nil
                    :foreground "black" :background "brightcyan")
(defadvice vc-mode-line (after strip-backend () activate)
  (when (stringp vc-mode)
    (let ((noback (replace-regexp-in-string
                   (format "^ %s[-:!]" (vc-backend buffer-file-name))
                   "  " vc-mode)))
      (setq vc-mode noback))))
(setq-default mode-line-format
              '(" %e"
                ;; Standard info about the current buffer
                mode-line-position
                (:propertize (vc-mode vc-mode) face mode-line-inverted-face)
                (:propertize " " face mode-line-inverted-face)
                " "
                mode-line-buffer-identification
                ))
