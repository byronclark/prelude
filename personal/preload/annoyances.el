(setq
 byte-compile-warnings '(not obsolete)
 warning-suppress-log-types '((comp) (bytecomp))
 native-comp-async-report-warnings-errors 'silent)

;; Disable undo-tree mode in favor of the built-in undo system.
;; There are some terrible behaviors with ellama and occasionally XML files that aren't
;; worth the pain.
(setopt prelude-undo-tree nil)
