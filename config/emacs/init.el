;; minimal emacs config for Org note-taking and task managing
;; Using: straight.el + use-package
;; targets: beginner-friendly, single file, easy to extend
;; emacs 29+

;; startup optimization
(setq gc-cons-threshold (* 50 1024 1024))
(setq read-process-out-max (* 1024 1024))
(setq package-enable-at-startup nil)
;; restore the gc after startup
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 2 1024 1024))))

;; debug config — toggle to t when troubleshooting
(setq debug-on-error nil)
(setq init-file-debug nil)

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

;; editor basics
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(electric-pair-mode 1)
(show-paren-mode 1)

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

;; ── Keybinding Philosophy ────────────────────────────────────────────
;; Using Emacs native keybindings instead of evil (Vim emulation).
;; Long-term benefits:
;;   1. org-mode tutorials, docs, and community help all assume native keys —
;;      no mental translation layer when reading the manual or asking
;;      questions online.
;;   2. Third-party Emacs packages ship with native bindings only; with
;;      evil you are always dependent on evil-collection keeping up.
;;   3. The Emacs keybinding system is internally consistent (C-c for
;;      mode-specific commands, C-h prefix for help, C-u for prefix
;;      argument) — learning it once pays dividends across all modes.
;;   4. Org-mode's agenda, clocking, tables, and sparse-tree commands are
;;      designed around one-handed chord sequences that flow naturally
;;      once muscle memory sets in.
;;   5. Fewer packages = less that can break on upgrades, faster startup,
;;      simpler config. Native bindings are first-class citizens.
;; ──────────────────────────────────────────────────────────────────────

;; org-mode (note-taking and task management)
(use-package org
  :straight (:type built-in)
  :hook
  (org-mode . visual-line-mode)        ;; soft-wrap for readability
  :bind
  (("C-c a" . org-agenda)              ;; agenda dispatcher
   ("C-c c" . org-capture)             ;; quick capture from anywhere
   ("C-c l" . org-store-link))         ;; store link for later insertion
  :config
  ;; --- directories & files ---
  (setq org-directory (expand-file-name "~/documents/org"))
  (setq org-default-notes-file (expand-file-name "inbox.org" org-directory))
  (unless (file-directory-p org-directory)
    (make-directory org-directory t))

  ;; --- agenda ---
  (setq org-agenda-files (list org-directory))
  (setq org-agenda-start-on-weekday nil) ;; start from today, not Monday

  ;; --- TODO workflow ---
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")))
  (setq org-log-done 'time)             ;; timestamp when task is completed

  ;; --- capture templates ---
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file+headline "inbox.org" "Tasks")
           "* TODO %?\n  %U\n  %a")
          ("n" "Quick Note" entry
           (file+headline "inbox.org" "Notes")
           "* %?  :note:\n  %U\n  %a")
          ("j" "Journal" entry
           (file+datetree "journal.org")
           "* %?\n  %U")))

  ;; --- refile (move headings between files) ---
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

  ;; --- visual ---
  (setq org-startup-indented t)
  (setq org-hide-emphasis-markers t)
  (setq org-ellipsis " ⤵")             ;; nicer folded-heading indicator
  (setq org-pretty-entities t))        ;; Unicode entities (e.g. \alpha → α)

;; ── org-mode extras ──────────────────────────────────────────────────
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))  ;; prettier heading bullets

(use-package org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t       ;; reveal bold/italic on cursor
        org-appear-autolinks t          ;; show link description on cursor
        org-appear-autosubmarkers t))   ;; reveal sub/superscript markers

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
(global-visual-line-mode 1)
(setq-default word-wrap t)

;; i just need an eyes-friendly colorscheme to protect my fucking eyes
(use-package doom-themes
  :config
  (load-theme 'doom-one t))  ;; doom-one / doom-gruvbox / doom-tomorrow-night

;; elisp completions settings
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2))

(global-eldoc-mode 1)

(setq tab-always-indent 'complete)
