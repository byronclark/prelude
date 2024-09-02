(defvar byronc/emacs-local-init-dir (expand-file-name "init" byronc/emacs-local-dir))

(when (file-exists-p byronc/emacs-local-init-dir)
  (message "[byronc] Loading local configuration files in %s..." byronc/emacs-local-init-dir)
  (mapc 'load (directory-files byronc/emacs-local-init-dir 't "^[^#\.].*\\.el$")))
