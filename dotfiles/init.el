;; (setq debug-on-error t)

;; term mode
(require 'term)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline 'query)

;; python-mode
(add-hook 'python-mode-hook
          '(lambda()
             (setq indent-tabs-mode nil)))

;; scheme-mode (gauche)
(setq scheme-program-name "/usr/local/bin/gosh -i")
(autoload 'scheme-mode "cmuscheme" "Major mode for Scheme." t)
(autoload 'run-scheme "cmuscheme" "Run an inferior Scheme process." t)

(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

(define-key global-map
  "\C-cS" 'scheme-other-window)

;; highlights ()
(show-paren-mode)

;; not backup
(setq make-backup-files nil)

;; Japanese
(prefer-coding-system 'utf-8-unix)
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8-unix)
(setq default-buffer-file-coding-system 'utf-8-unix)

;; Fonts
;;(create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakugo")
;;(set-fontset-font "fontset-menlokakugo" 'unicode (font-spec :family "Hiragino Kaku Gothic ProN" ) nil 'append)
;;(add-to-list 'default-frame-alist '(font . "fontset-menlokakugo"))
;;(setq face-font-rescale-alist '((".*Hiragino.*" . 1.0) (".*Menlo.*" . 1.0)))

;; window size
;;(setq initial-frame-alist
;;      (append
;;       '((width . 210)    ; フレーム幅(文字数)
;;	 (height . 70)   ; フレーム高(文字数)
;;	 ) initial-frame-alist))

;; highlight current line
(defface my-hl-line-face
  '((((class color)
      (background dark))
     (:background "#222244"))
    (((class color)
      (background light))
     (:background "#1A004D"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode t)

;; display linenum
(line-number-mode t)
(column-number-mode t)

;; system settings
(setq gc-cons-threshold (* 10 gc-cons-threshold))
(setq message-log-max 10000)
(setq history-length 1000)
(setq echo-keystrokes 0.1)

;; load-path
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/auto-install/")

;; color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-clarity)

;; auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

;; anything.el
(require 'anything-startup)
(global-set-key (kbd "M-;") 'anything-filelist+)
(setq anything-c-filelist-file-name "/Users/shiino.shunsuke/lib/filelist")

;; auto-install
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(setq auto-install-use-wget nil)
;; (setq auto-install-wget-command "/usr/bin/wget")
;; (auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

;; rsense
(setq rsense-home "/Users/shiino.shunsuke/opt/rsense-0.3")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)
(setq rsense-rurema-home (concat rsense-home "/ruby-doc/ruby-refm"))

;;;;  flymake for ruby
(require 'flymake)
;; I don't like the default colors :)
(set-face-background 'flymake-errline "red4")
(set-face-background 'flymake-warnline "dark slate blue")
;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))
(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook
 'ruby-mode-hook
 '(lambda ()
    ;; Don't want flymake mode for ruby regions in rhtml files
    (if (not (null buffer-file-name)) (flymake-mode))))

;; flymake 現在行のエラーをpopup.elのツールチップで表示する
(defun flymake-display-err-menu-for-current-line ()
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no))))
    (when line-err-info-list
      (let* ((count           (length line-err-info-list))
             (menu-item-text  nil))
        (while (> count 0)
          (setq menu-item-text (flymake-ler-text (nth (1- count) line-err-info-list)))
          (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
                 (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
            (if file
                (setq menu-item-text (concat menu-item-text " - " file "(" (format "%d" line) ")"))))
          (setq count (1- count))
          (if (> count 0) (setq menu-item-text (concat menu-item-text "\n")))
          )
        (popup-tip menu-item-text)))))

;; ruby-mode custom keybind
(add-hook 'ruby-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-rsense-method)
            (add-to-list 'ac-sources 'ac-source-rsense-constant)
	    (define-key ruby-mode-map (kbd "C-x .") 'ac-complete-rsense)
	    (define-key ruby-mode-map (kbd "C-x d") 'rsense-jump-to-definition)
	    (define-key ruby-mode-map (kbd "C-x e") 'flymake-display-err-menu-for-current-line)))

;;pry (run-pry)
(add-to-list 'load-path "~/.emacs.d/vendor/emacs-pry")
(require 'pry)

;; system config
(custom-set-variables
 '(safe-local-variable-values (quote ((encoding . utf-8)))))
(custom-set-faces
 )
