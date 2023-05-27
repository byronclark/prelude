;; *** Additional Packages ***
(prelude-require-packages
 '(catppuccin-theme
   dimmer
   direnv
   ef-themes
   fennel-mode
   fontaine
   jet
   ligature
   lsp-pyright
   mermaid-mode
   minions
   modus-themes
   ob-mermaid
   org-roam
   consult-org-roam
   pyvenv
   ripgrep
   terraform-mode
   yasnippet
   yasnippet-snippets))

(direnv-mode)
(setq help-window-select t)

;; *** Appearance ***
;; Default italic face sets underline if the font supports it
(custom-set-faces
 '(italic ((t (:slant italic)))))

;; Ligatures
(setq monolisa-v2-ligatures/coding
      '("<!---" "--->" "|||>" "<!--" "<|||" "<==>" "-->" "->>" "-<<" "..=" "!=="
        "#_(" "/==" "||>" "||=" "|->" "===" "==>" "=>>" "=<<" "=/=" ">->" ">=>"
        ">>-" ">>=" "<--" "<->" "<-<" "<||" "<|>" "<=" "<==" "<=>" "<=<" "<<-"
        "<<=" "<~>" "<~~" "~~>" ">&-" "<&-" "&>>" "&>" "->" "-<" "-~" ".=" "!="
        "#_" "/=" "|=" "|>" "==" "=>" ">-" ">=" "<-" "<|" "<~" "~-" "~@" "~="
        "~>" "~~"))

(setq monolisa-v2-ligatures/whitespace
      '("---" "'''" "\"\"\"" "..." "..<" "{|" "[|" ".?" "::" ":::" "::=" ":="
        ":>" ":<" "\;\;" "!!" "!!." "!!!"  "?." "?:" "??" "?=" "**" "***" "*>"
        "*/" "--" "#:" "#!" "#?" "##" "###" "####" "#=" "/*" "/>" "//" "/**"
        "///" "$(" ">&" "<&" "&&" "|}" "|]" "$>" ".." "++" "+++" "+>" "=:="
        "=!=" ">:" ">>" ">>>" "<:" "<*" "<*>" "<$" "<$>" "<+" "<+>" "<>" "<<"
        "<<<" "</" "</>" "^=" "%%"))

(setq monolisa-v2-ligatures/all (append monolisa-v2-ligatures/coding
                                        monolisa-v2-ligatures/whitespace))

(setq iosevka-ligatures/coding
      '("<---" "<--"  "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->" "<---->" "<!--"
        "<==" "<===" "<=" "=>" "=>>" "==>" "===>" ">=" "<=>" "<==>" "<===>" "<====>" "<!---"
        "<~~" "<~" "~>" "~~>" "::" ":::" "==" "!=" "===" "!=="
        ":=" ":-" ":+" "<*" "<*>" "*>" "<|" "<|>" "|>" "+:" "-:" "=:" "<******>" "++" "+++"))

;; Selected ligature sets must match the font in use.
;; MonoLisa
;; (ligature-set-ligatures 'prog-mode monolisa-v2-ligatures/all)
;; (ligature-set-ligatures 'org-mode monolisa-v2-ligatures/whitespace)
;; Iosevka
(ligature-set-ligatures 'prog-mode iosevka-ligatures/coding)
(global-ligature-mode 't)

(setq fontaine-presets
      '((regular
         :default-family "Iosevka"
         :default-weight normal
         :default-height 140
         :italic-family "Iosevka"
         :italic-slant italic)
        (macbook
         :default-family "Iosevka"
         :default-weight normal
         :default-height 160
         :italic-family "Iosevka"
         :italic-slant italic)
        (shared
         :default-family "MonoLisa"
         :default-weight normal
         :default-height 190
         :italic-family "MonoLisa"
         :italic-slant italic)))

(when (display-graphic-p)
  ;; Fonts only work in graphics mode.
  (fontaine-set-preset (or (fontaine-restore-latest-preset)
                           'regular))
  (add-hook 'kill-emacs-hook #'fontaine-store-latest-preset))

;; Turn off scroll bars
(scroll-bar-mode -1)

;; Keep a little more context when scrolling
(setq next-screen-context-lines 5)

;; Modeline setup
(minions-mode 1)

;; Window management
(setq aw-scope 'frame)

(setq frame-title-format
      '("[" invocation-name "] " (:eval (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))

;; dimmer
(customize-set-variable 'dimmer-fraction 0.2)
(customize-set-variable 'dimmer-adjustment-mode :foreground)
(customize-set-variable 'dimmer-use-colorspace :rgb)
(dimmer-mode +1)

;; lsp-mode
(setq lsp-lens-enable nil)
(setq lsp-headerline-breadcrumb-enable nil)
(setq read-process-output-max (* 1024 1024)) ;; LSP responses can be large.

;; whitespace-mode - only warn on longer lines
(setq whitespace-line-column 120)
(setq whitespace-style '(face tabs empty trailing lines-char))

;; utf-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; projectile
(setq projectile-create-missing-test-files t)

;; yasnippet
(yas-global-mode +1)

;; consult and friends
(setq consult-project-function (lambda (_) (projectile-project-root)))

;; *** Org Mode ***
(setq org-directory "~/org")
(setq org-roam-directory "~/org/notes")
(setq org-agenda-files (list "inbox.org"
                             "gtd.org"
                             "tickler.org"
                             "habits.org"
                             org-roam-directory))
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

(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))

(setq org-agenda-window-setup 'current-window)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((mermaid . t)))

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
(setq consult-org-roam-grep-func #'consult-ripgrep)
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
  (auto-fill-mode 1))

(add-hook 'prelude-org-mode-hook #'byronc/org-mode-settings t)
;; Prevent poor interaction between consult-org-roam, prelude whitespace cleanup
;; on save, and super-save. Otherwise we get to enter a space manually after
;; each use of org-roam-node-insert outside of a capture buffer.
;; The downside is that org buffers have to be saved explicitly.
(add-to-list 'super-save-predicates
             (lambda () (not (eq major-mode 'org-mode))))

;; *** Languages ***
(defun byronc/prog-mode-settings ()
  (setq fill-column 120))

(add-hook 'prelude-prog-mode-hook #'byronc/prog-mode-settings t)

;; **** Clojure ****
(setq cider-repl-display-help-banner nil)
(setq cider-eldoc-display-for-symbol-at-point nil)
(setq clojure-toplevel-inside-comment-form t)
(setq cider-nbb-command "npx nbb")      ; Prefer project version of nbb.

(add-hook 'clojure-mode-hook #'lsp-deferred)
(add-hook 'clojurescript-mode-hook #'lsp-deferred)
(add-hook 'clojurec-mode-hook #'lsp-deferred)

(add-hook 'cider-mode-hook
          (lambda ()
            (remove-hook 'completion-at-point-functions #'cider-complete-at-point)))

;; **** Fennel ****
(add-to-list 'auto-mode-alist '("\\.fnl\\'" . fennel-mode))

;; **** JavaScript
(setq-default js-indent-level 2)
(add-hook 'js-mode-hook #'lsp-deferred)

;; **** GraphQL ****
(setq-default graphql-indent-level 4)

;; **** Python ****
(defun byronc/python-mode-settings ()
  (setenv "WORKON_HOME" "~/.pyenv/versions")
  (pyvenv-mode)
  (require 'lsp-pyright)
  (lsp-deferred))

(add-hook 'python-mode-hook #'byronc/python-mode-settings)

;; **** Swift ****
(setq-default swift-mode:basic-offset 2)

;; **** Terraform ****
(add-hook 'terraform-mode-hook #'lsp-deferred)


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
(global-set-key (kbd "C-c *") 'isearch-forward-thing-at-point)
