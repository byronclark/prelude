(defvar byronc/emacs-local-dir (expand-file-name "~/.emacs.local/"))

(defvar byronc/emacs-local-early-dir (expand-file-name "early-init" byronc/emacs-local-dir))

(when (file-exists-p byronc/emacs-local-early-dir)
  (message "[byronc] Loading local early configuration files in %s..." byronc/emacs-local-early-dir)
  (mapc 'load (directory-files byronc/emacs-local-early-dir 't "^[^#\.].*\\.el$")))
