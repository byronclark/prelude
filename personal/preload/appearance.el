(require 'package)

(setopt
 prelude-minimalistic-ui t
 frame-resize-pixelwise t)

;; Theme setup

(when (package-installed-p 'ef-themes)
  (setq ef-themes-headings
        '((1 . (semibold 1.5))
          (2 . (semibold 1.3))
          (3 . (semibold 1.1))
          (t . (semibold))))
  (setq ef-themes-mixed-fonts t)
  (setq ef-themes-to-toggle '(ef-reverie ef-owl))
  (setq prelude-theme 'ef-owl)
  )

(setq modus-themes-headings
      '((1 . (semibold 1.5))
        (2 . (semibold 1.3))
        (3 . (semibold 1.1))
        (t . (semibold))))
(setq modus-themes-mixed-fonts t)
(setq modus-themes-italic-constructs t)
(setq modus-themes-to-toggle '(modus-vivendi-tinted modus-operandi-tinted))
;; (setq prelude-theme 'modus-operandi-tinted)

(when (package-installed-p 'catppuccin-theme)
  (setq catppuccin-flavor 'macchiato)
  (setq catppuccin-highlight-matches t)
  (setq catppuccin-italic-comments t)
  (setq byronc/catppuccin-toggle-themes '(macchiato latte))
  ;; (setq prelude-theme 'catppuccin)
  )

(defun byronc/-load-theme (theme)
  (disable-theme (car custom-enabled-themes))
  (load-theme theme :no-confirm))

(defun byronc/themes-toggle ()
  (interactive)
  (if (eq (car custom-enabled-themes) 'catppuccin)
      ;; Special handling for catppuccin as it uses a flavor variable instead of separate themes.
      (when-let* ((one (car byronc/catppuccin-toggle-themes))
		  (two (cadr byronc/catppuccin-toggle-themes)))
	(if (eq catppuccin-flavor one)
	    (setq catppuccin-flavor two)
	  (setq catppuccin-flavor one))
        (catppuccin-reload))
    (when-let* ((one (car byronc/themes-to-toggle))
                (two (cadr byronc/themes-to-toggle)))
      (if (eq (car custom-enabled-themes) one)
          (byronc/-load-theme two)
        (byronc/-load-theme one)))))
