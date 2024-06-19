;; Settings that influence package loading
(setq quelpa-checkout-melpa-p nil)      ;quelpa only used to install packages outside of MELPA

;; *** Additional Packages ***
(prelude-require-packages
 '(use-package
    quelpa-use-package
    casual-calc
    catppuccin-theme
    dimmer
    direnv
    eat
    ef-themes
    elfeed
    embark
    embark-consult
    fennel-mode
    fish-mode
    fontaine
    jet
    lsp-pyright
    logview
    mermaid-mode
    mood-line
    modus-themes
    ob-mermaid
    org-modern
    org-roam
    consult-org-roam
    python-black
    pyvenv
    ripgrep
    spacious-padding
    terraform-mode
    verb
    wgrep
    yasnippet
    yasnippet-snippets
    zig-mode))

(setq auth-sources
      '((:source "~/.emacs.d/personal/secrets/.authinfo.gpg")))

(direnv-mode)
(setq help-window-select t)

;; *** Appearance ***
;; Default italic face sets underline if the font supports it
(custom-set-faces
 '(italic ((t (:slant italic)))))

(setq fontaine-presets
      '((regular
         :default-family "Victor Mono"
         :default-weight medium
         :default-height 140
         :fixed-pitch-family "Victor Mono"
         :variable-pitch-family "Victor Mono"
         :italic-slant italic)
        (regular-berkeley
         :inherit regular
         :default-family "Berkeley Mono"
         :fixed-pitch-family "Berkeley Mono"
         :variable-pitch-family "Berkeley Mono")
        (regular-shared
         :inherit regular
         :default-height 180)
        (macbook
         :default-family "Victor Mono"
         :default-weight normal
         :default-height 150
         :fixed-pitch-family "Victor Mono"
         :variable-pitch-family "Victor Mono"
         :italic-slant italic)
        (macbook-berkeley
         :inherit macbook
         :default-family "Berkeley Mono"
         :fixed-pitch-family "Berkeley Mono"
         :variable-pitch-family "Berkeley Mono")
        (macbook-shared
         :inherit macbook
         :default-height 190)))

(when (display-graphic-p)
  ;; Fonts only work in graphics mode.
  (fontaine-set-preset (or (fontaine-restore-latest-preset)
                           'regular))
  (fontaine-mode 1))

;; Breathing room between windows
(spacious-padding-mode 1)
;; The tab bar in pgtk builds of Emacs 29 gets occluded when there is
;; an internal frame margin. Like the one added by spacious-padding.
(when (and (version< emacs-version "30")
           (bound-and-true-p pgtk-initialized))
  (setopt tab-bar-show nil))

;; Turn off scroll bars
(scroll-bar-mode -1)

;; Keep a little more context when scrolling
(setq next-screen-context-lines 5)

;; Modeline setup
(mood-line-mode)

;; Window management
(setq aw-scope 'frame)
(setq ediff-split-window-function 'split-window-horizontally)

(setq frame-title-format
      '("[" invocation-name "] " (:eval (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))

;; calculator
(define-key calc-mode-map (kbd "C-o") 'casual-calc-tmenu)

;; dimmer
(customize-set-variable 'dimmer-fraction 0.2)
(customize-set-variable 'dimmer-adjustment-mode :foreground)
(customize-set-variable 'dimmer-use-colorspace :rgb)
(dimmer-mode +1)

;; Spell checking with jinx
(setopt prelude-flyspell nil)
(use-package jinx
  :ensure t
  :after (vertico)
  :hook (emacs-startup . global-jinx-mode)
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :config (add-to-list 'vertico-multiform-categories
                       '(jinx grid (vertico-grid-annotate . 20))))

(vertico-multiform-mode 1)


;; lsp-mode
(setq lsp-lens-enable nil)
(setq lsp-headerline-breadcrumb-enable nil)
(setq read-process-output-max (* 1024 1024)) ;; LSP responses can be large.
(define-key lsp-mode-map (kbd "s-?") 'lsp-describe-thing-at-point)

;; Disable super-save in situations where it doesn't work well:
;; - org-mode: spaces removed after every org-roam-node-insert
;; - hexl-mode: saves the hexl format of the file
(add-to-list
 'super-save-predicates
 (lambda () (not (member major-mode '(org-mode hexl-mode)))))

;; whitespace-mode - only warn on longer lines
(setq whitespace-line-column 120)
(setq whitespace-style '(face tabs empty trailing lines-char))

;; use a posix shell for commands
(setq shell-file-name "bash")

;; utf-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; magit
(setopt magit-list-refs-sortby "-creatordate")

;; projectile
(setq projectile-create-missing-test-files t)

;; yasnippet
(yas-global-mode +1)

;; consult and friends
(setq consult-project-function (lambda (_) (projectile-project-root)))

;; *** Org Mode ***
(setq
 ;; Edit settings
 org-auto-align-tags nil
 org-tags-column 0
 org-catch-invisible-edits 'show-and-error
 org-special-ctrl-a/e t
 org-insert-heading-respect-content t

 ;; Babel settings
 org-src-preserve-indentation t
 org-src-window-setup 'current-window

 ;; Org styling, hide markup etc.
 org-hide-emphasis-markers t
 org-pretty-entities t
 org-ellipsis "…"

 ;; Agenda styling
 org-agenda-tags-column 0
 org-agenda-block-separator ?─)

(global-org-modern-mode)

(setq org-directory "~/org")
(setq org-roam-directory "~/org/notes")
(setq org-agenda-files (list "inbox.org"
                             "gtd.org"
                             "tickler.org"
                             "habits.org"))
(setq org-refile-targets '(("gtd.org" :maxlevel . 2)
                           ("someday.org" :level . 1)
                           ("tickler.org" :maxlevel . 2)))
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "tickler.org" "Tickler")
                               "* %i%? \n %U")))
(setopt org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}
")
           :unnarrowed t)
          ("b" "book notes" plain
           "\n\n- tags :: \n- author :: \n- series :: \n\n* Summary\n\n%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}
")
           :unnarrowed t)))

(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))

(setq org-agenda-window-setup 'current-window)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((mermaid . t)
   (python . t)))

(setq find-file-visit-truename t)
(setq org-roam-dailies-directory "daily/")
(setq org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))))

(when (version<= "29" emacs-version)
  (prelude-require-package 'emacsql-sqlite-builtin)
  (setq org-roam-database-connector 'sqlite-builtin))

(org-roam-db-autosync-enable)
(setopt consult-org-roam-grep-func #'consult-ripgrep)
(consult-org-roam-mode 1)

(global-set-key (kbd "C-c n f") 'consult-org-roam-file-find)
(global-set-key (kbd "C-c n s") 'consult-org-roam-search)
(global-set-key (kbd "C-c n j") 'org-roam-dailies-goto-today)

(defun byronc/org-mode-settings ()
  (define-key org-mode-map (kbd "C-c n i") 'org-roam-node-insert)
  (define-key org-mode-map (kbd "C-c n t") 'org-roam-tag-add)
  (define-key org-mode-map (kbd "C-c n a") 'org-roam-alias-add)
  (define-key org-mode-map (kbd "C-c n l") 'org-roam-buffer-toggle)
  (define-key org-mode-map (kbd "C-c n r") 'org-roam-refile)
  (auto-fill-mode -1)
  (whitespace-mode -1)
  (visual-line-mode))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(add-hook 'prelude-org-mode-hook #'byronc/org-mode-settings t)

;; *** Content ***
(global-set-key (kbd "C-x w") 'elfeed)
(setq-default elfeed-search-filter "@2-months-ago +unread ")
(setopt elfeed-sort-order 'ascending)
(add-hook 'kill-emacs-hook (lambda () (when (fboundp 'elfeed-db-compact)
                                        (elfeed-db-compact))))

(use-package ellama
  :ensure t
  :init
  (require 'llm-claude)
  (require 'llm-openai)
  (setopt llm-warn-on-nonfree nil
          ellama-keymap-prefix "C-c m"
          ellama-sessions-directory (expand-file-name "~/org/ellama-sessions")
          ellama-provider (make-llm-claude
                           :key (auth-source-pick-first-password :host "claude.api")
                           :chat-model "claude-3-sonnet-20240229")
          ellama-providers
          '(("openai" . (make-llm-openai
                         :key (auth-source-pick-first-password :host "openai.api")
                         :chat-model "gpt-4o")))))

;; *** Languages ***
(require 'quelpa-use-package)
;; set byronc/copilot-enabled in preload to use copilot
(when (bound-and-true-p byronc/copilot-enabled)
  (use-package copilot
    :quelpa (copilot :fetcher github
                     :repo "copilot-emacs/copilot.el"
                     :branch "main"
                     :files ("dist" "*.el"))
    :custom
    (copilot-indent-offset-warning-disable t)

    :hook
    (prelude-prog-mode . copilot-mode)

    :bind (:map copilot-completion-map
                ("<tab>" . 'copilot-accept-completion)
                ("TAB" . 'copilot-accept-completion)
                ("C-<tab>" . 'copilot-accept-completion-by-word)
                ("C-TAB" . 'copilot-accept-completion-by-word)
                ("M-n" . 'copilot-next-completion)
                ("M-p" . 'copilot-previous-completion))))

(defun byronc/prog-mode-settings ()
  (setq fill-column 90))

(add-hook 'prelude-prog-mode-hook #'byronc/prog-mode-settings t)

;; **** Clojure ****
(setopt cider-offer-to-open-cljs-app-in-browser nil
        cider-repl-display-help-banner nil
        cider-repl-display-in-current-window t
        cider-eldoc-display-for-symbol-at-point nil
        clojure-toplevel-inside-comment-form t
        cider-nbb-command "npx nbb"     ;Prefer project version of nbb.
        )

(add-to-list 'auto-mode-alist '("\\.fiddle\\'" . clojure-mode)) ;[Calva fiddle files](https://calva.io/fiddle-files/)

(add-hook 'clojure-mode-hook #'lsp-deferred)
(add-hook 'clojurescript-mode-hook #'lsp-deferred)
(add-hook 'clojurec-mode-hook #'lsp-deferred)

(add-hook 'cider-mode-hook
          (lambda ()
            (remove-hook 'completion-at-point-functions #'cider-complete-at-point)))

;; cider portal integration (see https://cljdoc.org/d/djblue/portal/0.55.1/doc/editors/emacs#cider)
(defun portal.api/open ()
  (interactive)
  (cider-nrepl-sync-request:eval
   "(do (ns dev) (def portal ((requiring-resolve 'portal.api/open) {:launcher :emacs})) (add-tap (requiring-resolve 'portal.api/submit)))"))

(defun portal.api/clear ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/clear)"))

(defun portal.api/close ()
  (interactive)
  (cider-nrepl-sync-request:eval "(portal.api/close)"))

;; **** Fennel ****
(add-to-list 'auto-mode-alist '("\\.fnl\\'" . fennel-mode))

;; **** Go ****
(add-hook 'go-mode-hook (lambda () (setq tab-width 4)))

;; **** JavaScript
(setq-default js-indent-level 2)
(add-hook 'js-mode-hook #'lsp-deferred)

;; **** Markdown ****
(setq markdown-command "pandoc")

;; ;; **** OCaml ****
;; (add-hook 'tuareg-mode-hook #'lsp-deferred)
;; ;; Disable super-save as it conflicts with formatting in OCaml when LSP is enabled.
;; (add-to-list 'super-save-predicates
;;              (lambda () (not (eq major-mode 'tuareg-mode))))

;; **** Python ****
(defun byronc/python-mode-settings ()
  (setenv "WORKON_HOME" "~/.pyenv/versions")
  (pyvenv-mode)
  (require 'lsp-pyright)
  (lsp-deferred)
  (python-black-on-save-mode-enable-dwim))

(add-hook 'python-mode-hook #'byronc/python-mode-settings)

;; **** Swift ****
(setq-default swift-mode:basic-offset 2)

;; **** Terraform ****
(add-hook 'terraform-mode-hook #'lsp-deferred)

;; **** Zig ****
(add-hook 'zig-mode-hook #'lsp-deferred)


;; *** OS Specific Settings ***
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)

  ;; macOS builds of emacs have a strict limit of 1024 files that can
  ;; be _watched_ before they start spewing errors about too many open
  ;; files. lsp-mode is especially good at watching lots of files.
  (setq lsp-enable-file-watchers nil))


;; *** Homegrown Functions ***
(defun byronc/kill-buffer-relative-name ()
  "Kill path relative to the projectile root of the file visited in the current buffer"
  (interactive)
  (if buffer-file-name
      (let ((relative-name (file-relative-name buffer-file-name (projectile-project-root))))
        (kill-new relative-name)
        (message "Added %s to kill ring." relative-name))
    (message "Buffer is not visiting a file.")))


;; *** Keybindings ***
(global-unset-key (kbd "C-z"))                  ; Bad habits and muscle memory mean I hit this key too often.
(define-key prelude-mode-map (kbd "C-c o") nil) ; This one doesn't seem useful and is too easy to hit inadvertently
(define-key prelude-mode-map (kbd "C-c n") nil) ; Replaced by personal org-roam bindings
(define-key prelude-mode-map (kbd "C-c t") nil) ; Replaced with eat
(global-set-key (kbd "C-c t") 'eat-project-other-window)
(global-set-key (kbd "C-c *") 'isearch-forward-thing-at-point)
(global-set-key (kbd "C-:") 'avy-goto-char-timer)
(global-set-key (kbd "M-g l") 'avy-goto-line)
