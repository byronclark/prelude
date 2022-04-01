;; *** Additional Packages ***
(prelude-require-packages
 '(use-package
    catppuccin-theme
    direnv
    eat
    ef-themes
    elfeed
    embark
    embark-consult
    exec-path-from-shell
    fennel-mode
    fish-mode
    fontaine
    forge
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
      `((:source ,(expand-file-name "secrets/.authinfo.gpg" byronc/emacs-local-dir))))

(direnv-mode)
(setq help-window-select t)

;; *** Appearance ***
;; Default italic face sets underline if the font supports it
;; (custom-set-faces
;;  '(italic ((t (:slant italic)))))

(setopt fontaine-presets
        '((regular
           :default-family "Inconsolata"
           :default-height 160
           :fixed-pitch-family "Inconsolata"
           :variable-pitch-family "Source Sans 3"
           :variable-pitch-height 1.0
           :italic-slant italic)
          (regular-iosevka-comfy
           :default-family "Iosevka Comfy"
           :default-height 150
           :fixed-pitch-family "Iosevka Comfy"
           :variable-pitch-family "Iosevka Comfy Duo"
           :italic-slant italic)
          (regular-shared
           :inherit regular-inconsolata
           :default-height 190)
          (macbook
           :default-family "Inconsolata"
           :default-height 170
           :fixed-pitch-family "Inconsolata"
           :variable-pitch-family "Source Sans 3"
           :italic-slant italic)
          (macbook-iosevka-comfy
           :default-family "Iosevka Comfy"
           :default-height 160
           :fixed-pitch-family "Iosevka Comfy"
           :variable-pitch-family "Iosevka Comfy Duo"
           :italic-slant italic)
          (macbook-shared
           :inherit macbook-inconsolata
           :default-height 210)))

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

;; Scrolling time
(scroll-bar-mode -1)
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

(setopt display-buffer-base-action
        '((display-buffer-reuse-window display-buffer-same-window)
          (reusable-frames . t))
        even-window-sizes nil)

(use-package perspective
  :ensure t
  :after (consult)
  :custom
  (persp-mode-prefix-key (kbd "C-x x"))
  (persp-modestring-short t)
  (persp-initial-frame-name "plan")
  :config
  (consult-customize consult--source-buffer :hidden t :default nil)
  (add-to-list 'consult-buffer-sources persp-consult-source)
  :init (persp-mode))

;; casual porcelains
(use-package casual
  :ensure t
  :bind
  (:map calc-mode-map
        ("C-o" . #'casual-calc-tmenu))
  (:map dired-mode-map
        ("C-o" . #'casual-dired-tmenu)
        ("s" . #'casual-dired-sort-by-tmenu)))

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

(setq save-interprogram-paste-before-kill t)

;; Disable undo-tree mode in favor of the built-in undo system.
;; There are some terrible behaviors with ellama and occasionally XML files that aren't
;; worth the pain.
(global-undo-tree-mode -1)

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

;; ensure we have eat terminfo files in a place that macos will see them
(setq eat-term-terminfo-directory (expand-file-name "~/.terminfo"))
(require 'eat)
(eat-compile-terminfo)

;; utf-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; magit
(setopt magit-list-refs-sortby "-creatordate")
(with-eval-after-load 'magit
  (require 'forge))

;; projectile
(setq projectile-create-missing-test-files t)

;; yasnippet
(yas-global-mode +1)

;; consult and friends
(setq consult-project-function (lambda (_) (projectile-project-root)))
(with-eval-after-load 'consult
  (consult-customize consult-ripgrep :initial (thing-at-point 'symbol)))

(defun byronc/projectile-ripgrep ()
  (interactive)
  (consult-ripgrep (projectile-project-root) (thing-at-point 'symbol)))

(with-eval-after-load 'projectile
  (define-key projectile-mode-map (kbd "C-c p s r") #'byronc/projectile-ripgrep))

;; *** Org Mode ***
(setopt
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
 org-agenda-block-separator ?─

 ;; org-modern checkboxes only work well with iosevka fonts
 org-modern-checkbox nil)

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
  (visual-line-mode)
  (variable-pitch-mode))

(setopt verb-auto-kill-response-buffers t)
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
  :after (transient)
  :demand t                             ;Adding the binding for the menu makes this
                                        ;deferred by default.
  :config
  (require 'llm-claude)
  (require 'llm-openai)
  (setopt llm-warn-on-nonfree nil
          ellama-keymap-prefix "C-c m"
          ellama-sessions-directory (expand-file-name "~/org/ellama-sessions")
          ellama-provider (make-llm-claude
                           :key (auth-source-pick-first-password :host "claude.api")
                           :chat-model "claude-3-5-sonnet-latest")
          ellama-providers
          '(("openai" . (make-llm-openai
                         :key (auth-source-pick-first-password :host "openai.api")
                         :chat-model "gpt-4o"))))

  :bind
  (("C-c M" . ellama-transient-main-menu)))

;; *** Languages ***
;; set byronc/copilot-enabled in preload to use copilot
(when (bound-and-true-p byronc/copilot-enabled)
  (use-package copilot
    :ensure t
    :custom
    (copilot-indent-offset-warning-disable t)

    :hook
    (prelude-prog-mode . (lambda ()
                           (unless (string-prefix-p " *temp*-" (buffer-name))
                             (copilot-mode))))

    :bind (:map copilot-completion-map
                ("<tab>" . 'copilot-accept-completion)
                ("TAB" . 'copilot-accept-completion)
                ("C-<tab>" . 'copilot-accept-completion-by-word)
                ("C-TAB" . 'copilot-accept-completion-by-word)
                ("M-n" . 'copilot-next-completion)
                ("M-p" . 'copilot-previous-completion)))

  (use-package copilot-chat
    :ensure t
    :config
    (setopt copilot-chat-model "claude-3.5-sonnet")))

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

(defun byronc/clojure-mode-settings ()
  (lsp-deferred))

(add-hook 'clojure-mode-hook #'byronc/clojure-mode-settings)

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

;; **** Typescript ****
(add-hook 'typescript-mode-hook #'lsp-deferred)

;; **** Terraform ****
(add-hook 'terraform-mode-hook #'lsp-deferred)

;; **** Zig ****
(add-hook 'zig-mode-hook #'lsp-deferred)


;; *** OS Specific Settings ***
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)

  ;; Use GNU coreutils where needed on macOS
  (setopt insert-directory-program "gls")

  ;; macOS builds of emacs have a strict limit of 1024 files that can
  ;; be _watched_ before they start spewing errors about too many open
  ;; files. lsp-mode is especially good at watching lots of files.
  (setq lsp-enable-file-watchers nil))

(setopt exec-path-from-shell-arguments nil)
(when (memq window-system '(mac ns x pgtk))
  (exec-path-from-shell-initialize))

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
(global-set-key (kbd "s-,") 'avy-goto-char-timer)
(global-set-key (kbd "M-g l") 'avy-goto-line)
