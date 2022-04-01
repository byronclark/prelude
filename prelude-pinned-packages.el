;;; prelude-pinned-packages.el --- Control repository for specific packages

;;; Commentary:

;; melpa is often used for packages that don't have stable releases in
;; melpa-stable.  For packages we know have recent stable updates _and_ tracking
;; the bleeding edge has caused trouble, install from melpa-stable.

;;; Code:

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(setq package-pinned-packages
      '((modus-themes . "melpa-stable")
        (magit . "melpa-stable")
        (magit-section . "melpa-stable")
        (forge . "melpa-stable")))

(provide 'prelude-pinned-packages)
;;; prelude-pinned-packages.el ends here
