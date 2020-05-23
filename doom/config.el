;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.


;;  TEMP Clojure mode hacks
(add-hook 'clojure-mode-hook #'enable-paredit-mode)

;; burfin' / slurfin'
(define-key global-map (kbd "C-)") 'sp-forward-slurp-sexp)
(define-key global-map (kbd "C-(") 'sp-backward-slurp-sexp)
(define-key global-map (kbd "M-)") 'sp-forward-barf-sexp)
(define-key global-map (kbd "M-(") 'sp-backward-barf-sexp)

;; splittin' / splicin'
(define-key global-map (kbd "M-J") 'sp-join-sexp)
(define-key global-map (kbd "M-S") 'sp-split-sexp)

(define-key global-map (kbd "M-<up>") 'sp-splice-sexp-killing-backward)
(define-key global-map (kbd "M-<down>") 'sp-splice-sexp-killing-forward)

;; yankin'
(define-key global-map (kbd "C-M-y") 'sp-copy-sexp)

;; evalin'
(define-key global-map (kbd "C-M-x") 'cider-eval-last-sexp)

(setq default-directory "~/grid")

(require 'flycheck-clj-kondo)
(require 'direnv)
(direnv-mode)

(defun grfn/run-clj-or-cljs-test ()
  (interactive)
  (message "Running tests...")
  (cl-case (cider-repl-type-for-buffer)
    ('cljs
     (cider-interactive-eval
      "(with-out-str (cljs.test/run-tests))"
      (nrepl-make-response-handler
       (current-buffer)
       (lambda (_ value)
         (with-output-to-temp-buffer "*cljs-test-results*"
           (print
            (->> value
                 (s-replace "\"" "")
                 (s-replace "\\n" "\n")))))
       nil nil nil)))
    ('clj  (cider-test-run-ns-tests))))

(global-set-key (kbd "M-/") 'hippie-expand)
