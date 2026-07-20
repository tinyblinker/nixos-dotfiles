;; minimal emacs config for Org note-taking and task managing
;; Using: straight.el + use-package
;; includes: org-mode,which-key,evil,evil-collection
;; targets: beginner-friendly,single file,easy to extend
;; emacs 29+

;; startup optimization
(setq gc-cons-threshold (* 50 1024 1024))
(setq read-process-out-max (* 1024 1024))
(setq package-enable-at-startup nil)
;; restore the gc after startup
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1024 1024))))

;; debug config
(setq debug-on-error t) ;; when find elisp errors then enter the backtrace
(setq init-file-debug t) ;; print more detailed *Messages* when startup

;; disable ui clutter
;; run different codes base on the platforms
(cond
 ((eq system-type 'gnu/linux)
  ;; Linux 专属配置
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (message "Running on GNU/Linux"))

 ((eq system-type 'darwin)
  ;; macOS 配置
  (message "Running on macOS"))

 ((eq system-type 'windows-nt)
  ;; Windows 配置
  (message "Running on Windows"))

 ((eq system-type 'android)
  ;; Android / Termux
  (menu-bar-mode -1)
  (message "Running on Android")))
(blink-cursor-mode -1)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

;; others
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(electric-pair-mode 1)
(show-paren-mode 1)
(setq org-hide-emphasis-markers t)

;; bootstrap the straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; set use-package for straight.el
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; which-key(keybinding discovery)
(use-package which-key
  :straight (:type built-in)
  :defer 0
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.5))

;; evil(vim emulation) and evil-collection
(use-package evil
  :init
  (setq evil-want-keybinding nil) ;; required for evil-collection
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; org-mode(note-taking and task manage)
(use-package org
  :straight (:type built-in)
  :config
  ;; basic org directory
  (setq org-directory (expand-file-name "~/documents/org"))
  (setq org-default-notes-file (expand-file-name "inbox.org" org-directory))

  ;; create directory is missing
  (unless (file-directory-p org-directory)
    (make-directory org-directory t))

  ;; agenda
  (setq org-agenda-files (list org-directory))
  (global-set-key (kbd "C-c a") #'org-agenda)

  ;; capture template
  (setq org-capture-templates
	'(("t" "Todo" entry
	   (file "inbox.org")
	   "* TODO %?\n  %U\n  %a")
	  ("n" "Note" entry
	   (file "notes.org")
	   "* %?\n  %U\n  %a")))
  (global-set-key (kbd "C-c c") #'org-capture)

  ;; TODO workflow
  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")))

  ;; visual tweaks
  (setq org-startup-indented t)
  (setq org-hide-emphasis-markers t))

;; quality of life defaults

(use-package recentf
  :init (recentf-mode 1)
  :config (setq recentf-max-menu-items 20))

(use-package savehist
  :init (savehist-mode 1))

(use-package saveplace
  :init (save-place-mode 1))

;; sensible editing defaults
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(global-set-key (kbd "C-x k") #'kill-current-buffer)
(global-visual-line-mode 1)
(setq-default word-wrap t)

;; i just need an eyes-friendly colorscheme to protect my fucking eyes
(use-package doom-themes
  :init
  :config
  (load-theme 'doom-one t))  ;; doom-one / doom-gruvbox / doom-tomorrow-night 等

;; elisp completions settings
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2))

(global-eldoc-mode 1)
(electric-pair-mode 1)

(setq tab-always-indent 'complete)
