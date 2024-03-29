;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "shooterfei"
      user-mail-address "shooterfei@163.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vibrant)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; 字体设置
(setq doom-font (font-spec :family "Hack Nerd Font Mono" :background "#282c34" :foreground "#bbc2cf" :size 20))

;; 软件源设置
(setq package-archives '(("gnu" . "http://mirrors.ustc.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.ustc.edu.cn/elpa/melpa/")
                         ("nongnu" . "http://mirrors.ustc.edu.cn/elpa/nongnu/")))

(add-load-path! "~/.doom.d/site-lisp")
;; 代理配置
(require 'init-proxy)

;; set zsh to default shell of vterm
(use-package! vterm
  :config
  (setq vterm-shell "zsh"))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))


;; docx 文档处理, 通过pandoc 转为org文档进行预览
(defun g-org-generate-docx-file()
  (interactive)
  (shell-command (concat "pandoc -o " (replace-regexp-in-string ".docx$" ".org" buffer-file-name) " " buffer-file-name " --extract-media=imgrefs")))

(global-set-key (kbd "<f9>") 'g-org-generate-docx-file)


;; 文件目录补全
(defun autocomplete-file-name ()
  (interactive)
  (comint-dynamic-complete-as-filename))

(global-set-key (kbd "C-c f") 'autocomplete-file-name)


;; go 文件运行指令
(defun go-run-file ()
  (interactive)
  (async-shell-command (concat "go run " buffer-file-name)))

(define-key evil-normal-state-map "Q" #'moon/query-relace-point)
(define-key evil-visual-state-map "Q" #'moon/query-replace-region)

;;;###autoload
(defun moon/query-replace-region ()
  "Query replace selected region."
  (interactive)
  (query-replace (buffer-substring-no-properties
                  (region-beginning)
                  (region-end))
                 (completing-read "Replace to: " ())
                 ))

;;;###autoload
(defun moon/query-relace-point ()
  "Query replace thing at point."
  (interactive)
  (let ((word (thing-at-point 'word t)))
    (query-replace word
                   (completing-read (format "Replace \"%s\" to: " word) ())
                   nil (beginning-of-line))))
