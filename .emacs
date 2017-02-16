;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start Up ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Inhibit Start-up Screen
(setq-default inhibit-startup-screen t)

;; Menu Bar Mode
(menu-bar-mode 1)

;; Tool Bar(if found)
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

;; All in the same Emacs frame
(setq ns-pop-up-frames nil)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;; Backup Management ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Package Management ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Import packages and add additional package repositories
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives 
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
(package-initialize)

;; I want all the toys mommy!
(defvar matt/packages '(auto-complete
                        cider
                        clojure-mode
                        clojure-snippets
                        exec-path-from-shell
                        helm
                        helm-projectile
                        helm-themes
                        multiple-cursors
                        paredit
                        python-mode
                        skewer-mode
                        sr-speedbar))

;; Load all the packages!
(mapc (lambda (package)
        (when (not (package-installed-p package))
          (package-install package)))
      matt/packages)

;; Make emacs use shell environment vars
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; helm-config so you can, you know, use helm
(require 'helm)
(require 'helm-config)
(setq-default helm-split-window-in-side-p t)
(helm-mode 1)
(global-set-key [(meta x)] 'helm-M-x)
(global-set-key [(ctrl x) (ctrl f)] 'helm-find-files)
(global-set-key [(ctrl x) (b)] 'helm-buffers-list)

;; Start with speedbar

(setq-default speedbar-show-unknown-files t)
(setq-default sr-speedbar-default-width 20)
(setq-default sr-speedbar-width-x 20)
(setq-default sr-speedbar-width-console 20)
(sr-speedbar-open)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Custom Keys  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Make meta command for mac =)
(setq-default mac-command-modifier 'control)
(setq-default mac-command-key-is-meta t)
(setq-default mac-command-modifier 'meta)
(set-keyboard-coding-system nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Other ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Indent with spaces, not tabs.
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default indent-line-function 'insert-tab)

;; LOL who types out yes?
(fset 'yes-or-no-p 'y-or-n-p)

;; share OS clipboard, you know, for when you copy pasta stack overflow
(setq-default x-select-enable-clipboard t)

;; Highlight open and close parenthesis when the point is on them.
(show-paren-mode t)
(setq-default show-paren-delay 0)

;; Show Line & Column numbers
(line-number-mode 1)
(global-linum-mode 1)
(column-number-mode t)

;; Smooth Scrolling
(setq-default mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq-default mouse-wheel-progressive-speed t)
(setq-default mouse-wheel-follow-mouse 't)
(setq-default scroll-step 1)

;; Emacs Desktop!
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name "emacs-desktop")

;; Font
(set-frame-font "Chalkboard-15")

;; Open Emacs in maximized screen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Language Specifics ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;; C ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Change the offset to 4
(setq-default c-basic-offset 4)

;; Use linux style indents
(setq-default c-default-style "linux")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Paredit ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'paredit)

(defun maybe-map-paredit-newline ()
  (unless (or (memq major-mode '(inferior-emacs-lisp-mode cider-repl-mode))
              (minibufferp))
    (local-set-key (kbd "RET") 'paredit-newline)))

(add-hook 'paredit-mode-hook 'maybe-map-paredit-newline)
(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

(require 'eldoc)
(eldoc-add-command
 'paredit-backward-delete
 'paredit-close-round)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Clojure ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Cider
(require 'cider)
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'cider-repl-mode))

;; (defun set-auto-complete-as-completion-at-point-function ()
;;   (setq completion-at-point-functions '(auto-complete)))  
;; (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; (add-hook 'cider-repl-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; (add-hook 'clojure-mode-hook 'set-auto-complete-as-completion-at-point-function)
;; (add-hook 'cider-interaction-mode-hook 'set-auto-complete-as-completion-at-point-function)

;; C-c C-e to eval s-expression
(add-hook 'clojure-mode-hook 
    (lambda ()
      (local-set-key (kbd "C-c C-e") 'cider-pprint-eval-last-sexp)))

;; Stuart Sierra's refresh workflow
(defun cider-namespace-refresh ()
  (interactive)
  (cider-interactive-eval
   "(require 'clojure.tools.namespace.repl)
    (clojure.tools.namespace.repl/refresh)"))

(define-key clojure-mode-map (kbd "M-r") 'cider-namespace-refresh)
(add-to-list 'lisp-mode-hook 'enable-paredit-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Python-mode
(require 'python-mode)

;; Switch to the interpreter after executing code
(setq-default py-shell-switch-buffers-on-execute-p t)
(setq-default py-switch-buffers-on-execute-p t)

;; Don't split windows
(setq-default py-split-windows-on-execute-p nil)

;; Try to automagically figure out indentation
(setq-default py-smart-indentation t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Web Dev ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Skewer Mode
(setq-default skewer-mode t)
(add-hook 'html-mode-hook 'skewer-html-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'js2-mode-hook 'skewer-mode)

(require 'simple-httpd)
;; set root folder for httpd server
(setq httpd-root "/Users/matthewdunn/dunn-mat.github.io")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Custom Set Stuff ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (manoj-dark)))
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(package-selected-packages
   (quote
    (lua-mode sr-speedbar skewer-mode python-mode paredit multiple-cursors helm-themes helm-projectile helm exec-path-from-shell clojure-snippets cider auto-complete))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
