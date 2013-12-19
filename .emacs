; Disable menu bar
(menu-bar-mode -1)

; Enable syntax highlighting
(global-font-lock-mode 1)

; When a section is marked and you start typing, delete that section
(delete-selection-mode 1)

; Enable paren match highlighting
(show-paren-mode 1)

; Highlight entire bracket expression
(setq show-paren-style 'expression)

; Display line numbers in margin. Emacs 23 only.
(global-linum-mode 1)

; Show cursor's column position
(column-number-mode 1)

; Text wrapping on word break
(global-visual-line-mode 1)

; Disable audible bell
;(setq visible-bell t)

; one line at a time
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

; don't accelerate scrolling
(setq mouse-wheel-progressive-speed nil)

; scroll window under mouse
(setq mouse-wheel-follow-mouse 't)

; keyboard scroll one line at a time
(setq scroll-step 1)

; Disable suspend-frame (which closes Emacs without warnings)
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-x C-z"))

; Save Temp Files to temp dir
(setq backup-directory-alist
            `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
            `((".*" ,temporary-file-directory t)))

; Make the return key do a newline & indent, not just newline (like modern editors)
(define-key global-map (kbd "RET") 'newline-and-indent)

; Make delete delete the last word
(defun backward-delete-word (arg)
      "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
            (interactive "p")
	            (delete-region (point) (progn (backward-word arg) (point))))

(define-key global-map (kbd "C-k") 'backward-delete-word)

; C-k is now backspace
(define-key global-map (kbd "C-h") 'backward-delete-char)

; Make C-u undo
(define-key global-map (kbd "C-u") 'undo)

; ### CUSTOM FUNCTIONALITY ###

(defvar line-previous-column nil "Save the previous column position when deleting/moving lines")
(defvar line-previous-column-next nil "The current previous column, which will not become the previous column if the current line is empty")

(defvar few-lines-to-jump 3 "lines to jump up and down (lesser)")
(defvar more-lines-to-jump 8 "lines to jump up and down (greater)")
; Get OS X terminal to understand M-<up/down>
(define-key input-decode-map "\e\eOA" [(meta up)])
(define-key input-decode-map "\e\eOB" [(meta down)])

(defun last-command-column-should-remember ()
    (or
        (or
	     (or (eq last-command 'jump-up-one-line)
		 (eq last-command 'jump-down-one-line))
	         (or (eq last-command 'jump-up-a-few-lines)
		     (eq last-command 'jump-down-a-few-lines)))
	  (or (eq last-command 'jump-up-more-lines)
	            (eq last-command 'jump-down-more-lines))))
(defun remember-column-if-not-already ()
    (if
	      (last-command-column-should-remember)
	      ()
          (setq line-previous-column (current-column))))

(defun recall-last-column ()
    (move-to-column line-previous-column))

(defun jump-up-a-few-lines ()
    "Move up a few lines"
      (interactive)
        (remember-column-if-not-already)
	  (forward-line (* few-lines-to-jump -1))
	    (recall-last-column))
(global-set-key [(meta up)] 'jump-up-a-few-lines)

(defun jump-down-a-few-lines ()
    "Move down a few lines"
      (interactive)
        (remember-column-if-not-already)
	  (forward-line few-lines-to-jump)
	    (recall-last-column))
(global-set-key [(meta down)] 'jump-down-a-few-lines)

(defun jump-up-more-lines ()
    "Move up more lines"
      (interactive)
        (remember-column-if-not-already)
	  (forward-line (* more-lines-to-jump -1))
	    (recall-last-column))
(global-set-key (kbd "C-q") 'jump-up-more-lines)

(defun jump-down-more-lines ()
    "Move down more lines"
      (interactive)
        (remember-column-if-not-already)
	  (forward-line more-lines-to-jump)
	    (recall-last-column))
(global-set-key (kbd "C-j") 'jump-down-more-lines)

; Create delete line functionality
; REFACTOR THIS AND USE IT FOR THE LINE JUMPING ALSO
(defun delete-entire-line ()
    "Delete an entire line"
      (interactive)
        (setq line-previous-column-next (current-column)) ; Save the column position
	  (end-of-line) ; Move cursor to the end of the line
	    (if (= (current-column) 0) ; If there are no characters in the line, just delete the new line character
		      (delete-char 1) ; Delete the new line character
	          (progn
		          (setq line-previous-column line-previous-column-next)
			        (beginning-of-line)
				      (kill-line)
				            (delete-char 1)))
	      (recall-last-column))
; Bind delete-entire-line to key
(global-set-key (kbd "M-DEL") 'delete-entire-line)

;;;;;;;;;;;;; Packages ;;;;;;;;;;;;;;

(setq package-contents-not-refreshed t)
(defun ensure-package-contents-refreshed ()
    (if package-contents-not-refreshed
	      (progn
		(setq package-content-not-refreshed nil)
		(package-refresh-contents))
          ()))

; Load Packages
(require 'package)

(add-to-list 'package-archives
	          '("marmalade" .
		           "http://marmalade-repo.org/packages/"))
(package-initialize)

; Ensure monokai theme
(unless (require 'monokai-theme nil 'noerror)
    (progn
          (ensure-package-contents-refreshed)
	      (package-install 'monokai-theme)))

; Load monokai theme
(load-theme 'monokai t)

; Ensure org mode
(unless (require 'org nil 'noerror)
    (progn
          (ensure-package-contents-refreshed)
	      (package-install 'org)))

; Initialize org mode
(package-initialize 'org)

; Ensure yaml mode
(unless (require 'yaml-mode nil 'noerror)
    (progn
          (ensure-package-contents-refreshed)
	      (package-install 'yaml-mode)))

; Ensure haxe mode
(unless (require 'haxe-mode nil 'noerror)
    (progn
          (ensure-package-contents-refreshed)
	      (package-install 'haxe-mode)))

; Initialize yaml mode
(package-initialize 'yaml-mode)

(unless (require 'web-mode nil 'noerror)
    (progn
          (ensure-package-contents-refreshed)
	      (package-install 'web-mode)))

; Initialize and configure web mode
(require 'web-mode)

; Initialize quack (better scheme mode)
(package-initialize 'quack)

(unless (require 'quack nil 'noerror)
    (progn
          (ensure-package-contents-refreshed)
	      (package-install 'quack)))

; Initialize and configure quack
(require 'quack)

; Initialize haskell-mode
(package-initialize 'haskell-mode)

(unless (require 'haskell-mode nil 'noerror)
    (progn
          (ensure-package-contents-refreshed)
	      (package-install 'haskell-mode)))

    (custom-set-variables
     '(haskell-mode-hook '(turn-on-haskell-indentation)))


; Initialize and configure quack
(require 'haskell-mode)

; Initialize Auto Complete
(package-initialize 'auto-complete)

(unless (require 'auto-complete nil 'noerror)
    (progn
          (ensure-package-contents-refreshed)
	      (package-install 'auto-complete)))

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.svg\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

(set-face-attribute 'web-mode-html-tag-face nil :foreground "DarkSeaGreen")
(set-face-attribute 'web-mode-html-attr-name-face nil :foreground "IndianRed")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(quack-global-menu-p nil)
 '(quack-programs (quote ("mzscheme" "bigloo" "csi" "csi -hygienic" "gosh" "gracket" "gsi" "gsi ~~/syntax-case.scm -" "guile" "kawa" "mit-scheme" "racket" "racket -il typed/racket" "rs" "scheme" "scheme48" "scsh" "sisc" "stklos" "sxi"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "nil")))))
