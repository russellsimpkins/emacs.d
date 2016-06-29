(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
(setq gc-cons-threshold 100000000)
(setq inhibit-startup-message t)

(defalias 'yes-or-no-p 'y-or-n-p)

(defconst demo-packages
  '(anzu
    company
    duplicate-thing
    ggtags
    helm
    helm-gtags
    helm-projectile
    helm-swoop
    ;; function-args
    clean-aindent-mode
    comment-dwim-2
    dtrt-indent
    ws-butler
    iedit
    yasnippet
    smartparens
    projectile
    volatile-highlights
    zygospore))

(defun install-packages ()
  "Install all required packages."
  (interactive)
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (package demo-packages)
    (unless (package-installed-p package)
      (package-install package))))

(install-packages)

;; this variables must be set before load helm-gtags
;; you can change to any prefix key of your choice
(setq helm-gtags-prefix-key "\C-cg")

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'setup-helm)
(require 'setup-helm-gtags)
;; (require 'setup-ggtags)
(require 'setup-cedet)
(require 'setup-editing)

(windmove-default-keybindings)

;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)

;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(delete 'company-semantic company-backends)
(define-key c-mode-map  [(tab)] 'company-complete)
(define-key c++-mode-map  [(tab)] 'company-complete)
;; (define-key c-mode-map  [(control tab)] 'company-complete)
;; (define-key c++-mode-map  [(control tab)] 'company-complete)

;; company-c-headers
(add-to-list 'company-backends 'company-c-headers)

;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)

;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq
 c-default-style "linux" ;; set style to "linux"
 )

(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET

;; activate whitespace-mode to view all whitespace characters
(global-set-key (kbd "C-x w") 'whitespace-mode)

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; set appearance of a tab that is represented by 4 spaces
(setq-default tab-width 4)

;; Compilation
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

;; setup GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

;; Package: clean-aindent-mode
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

;; Package: dtrt-indent
(require 'dtrt-indent)
(dtrt-indent-mode 1)

;; Package: ws-butler
(require 'ws-butler)
(add-hook 'prog-mode-hook 'ws-butler-mode)

;; Package: yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; Package: smartparens
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)

(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

;; Package: projejctile
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'alien)

;; Package zygospore
(global-set-key (kbd "C-x 1") 'zygospore-toggle-delete-other-windows)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; RUSS's Changes
;;(setq dotfiles-dir "/Users/202238/emacs-c/.emacs.d/")
(setq dotfiles-dir ".")
(setq custom-file (concat dotfiles-dir "custom.el"))
(load custom-file 'noerror)
(ac-config-default)

;; (standard-display-ascii ?\t "^I") ;; show tabs as ^I
;; let emacs find <> as well balanced parens as [] and () are
(modify-syntax-entry ?> "(<")
(modify-syntax-entry ?< ")>")

(setq-default c-basic-offset 4)
(setq-default js-indent-level 2)
(setq-default fill-column 9999)
;; (setq-default fill-column 72)


;; open with max frame
;;(require 'frame-cmds)
;;(maximize-frame)
;; functions to change the font size

(global-set-key (kbd "C-x C-m") 'execute-extended-command)
(global-set-key (kbd "C-x u") 'cua-mode)
;; for split frames
(global-set-key (kbd "C-x 6")  'enlarge-window)
(global-set-key (kbd "C-x 5") 'shrink-window)
(global-set-key (kbd "C-x }") 'enlarge-window-horizontally)
(global-set-key (kbd "C-x {") 'shrink-window-horizontally)
(global-set-key (kbd "C-x +") 'balance-windows)

;; search replace
(global-set-key (kbd "C-x C-g") 'query-replace)
(global-set-key (kbd "C-x C-z") 'query-replace-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-x C-r") 'revert-buffer)
(global-set-key (kbd "C-x C-l") 'describe-char)
(global-set-key (kbd "M-c") 'capitalize-word)

(global-set-key (kbd "C-x j b") 'js-beautify-region)

;; git push
(global-set-key (kbd "C-x p") 'magit-push)

(global-set-key (kbd "C-x m") 'maximize-frame)
(global-set-key (kbd "C-c r") 'redraw-display)
(global-set-key (kbd "C-x g") 'goto-line)

(global-set-key (kbd "M-g") 'helm-google-suggest)

;; show the column number in the bottom tray
(column-number-mode 1)

;; golang specifics
;; (setq gofmt-command "~/projects/go-projects/bin/goimports")
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))
(require 'go-autocomplete)
(require 'auto-complete-config)


;; run gofmt on go source
(add-hook 'before-save-hook 'gofmt-before-save)

;; remove whitespace before save
(add-hook 'before-save-hook 'whitespace-cleanup)

(add-hook 'php-mode-hook 'flycheck-mode)

(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)


(defun ww-next-gtag ()
  "Find next matching tag, for GTAGS."
  (interactive)
  (let ((latest-gtags-buffer
         (car (delq nil  (mapcar (lambda (x) (and (string-match "GTAGS SELECT" (buffer-name x)) (buffer-name x)) )
                                 (buffer-list)) ))))
    (cond (latest-gtags-buffer
           (switch-to-buffer latest-gtags-buffer)
           (forward-line)
           (gtags-select-it nil))
          ) ))
;; M-; cycles to next result, after doing M-. C-M-. or C-M-,
(global-set-key "\M-'" 'ww-next-gtag)

(ac-config-default)
(defun go-mode-setup ()
  (go-eldoc-setup))
(add-hook 'go-mode-hook 'go-mode-setup)


(defun terminal-init-screen ()
  "Terminal initialization function for screen."
  ;; Use the xterm color initialization code.
  ;; (xterm-register-default-colors)
  (tty-set-up-initial-frame-faces)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  )

(defun no-windows ()
  (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (terminal-init-screen)


  )

(defun window-settings()
  (require 'ansi-color)
  (tool-bar-mode 0)

  (defun sacha/increase-font-size ()
    (interactive)
    (set-face-attribute 'default
                        nil
                        :height
                        (ceiling (* 1.10
                                    (face-attribute 'default :height)))))
  (defun sacha/decrease-font-size ()
    (interactive)
    (set-face-attribute 'default
                        nil
                        :height
                        (floor (* 0.9
                                  (face-attribute 'default :height)))))
  ;; Original by Hirose Yuuji and Bob Wiener
  (defun my:resize-window (&optional arg)
    "*Resize window interactively."
    (interactive "p")
    (if (one-window-p) (error "Cannot resize sole window"))
    (or arg (setq arg 1))
    (let (c)
      (catch 'done
        (while t
          (message
           "w=heighten, s=shrink, d=widen, a=narrow (by %d);  1-9=unit, q=quit"
           arg)
          (setq c (read-char))
          (condition-case ()
              (cond
               ((= c ?w) (enlarge-window arg))
               ((= c ?s) (shrink-window arg))
               ((= c ?d) (enlarge-window-horizontally arg))
               ((= c ?a) (shrink-window-horizontally arg))
               ((= c ?o) (other-window 1))
               ((= c ?p) (other-window -1))
               ((= c ?\^G) (keyboard-quit))
               ((= c ?q) (throw 'done t))
               ((and (> c ?0) (<= c ?9)) (setq arg (- c ?0)))
               (t (beep)))
            (error (beep)))))
      (message "Done.")))

  ;; KEYBOARD COMMANDS
  (global-set-key (kbd "C-+") 'sacha/increase-font-size)
  (global-set-key (kbd "C--") 'sacha/decrease-font-size)
  (global-set-key (kbd "C-c w") 'my:resize-window)
  ;; run color-theme-initialize on a first run
  (color-theme-initialize)
  (color-theme-midnight)
  ;; setting the default font size
  (set-face-attribute 'default
                      nil
                      :height 180)
  (maximize-frame)
  (redraw-frame)
  (redraw-display)
  )
(if window-system
  (window-settings)
  (no-windows)
  )
(package-initialize)
