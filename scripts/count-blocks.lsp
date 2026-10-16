;; count-blocks.lsp - Count every block insert, grouped by block name
;; Command: CBCOUNT
(defun c:CBCOUNT ( / ss i en name pair lst total )
  (setq ss (ssget "_X" '((0 . "INSERT"))))
  (if ss
    (progn
      (setq i 0 lst nil)
      (repeat (sslength ss)
        (setq en (ssname ss i))
        (setq name (cdr (assoc 2 (entget en))))
        (if (setq pair (assoc name lst))
          (setq lst (subst (cons name (1+ (cdr pair))) pair lst))
          (setq lst (cons (cons name 1) lst))
        )
        (setq i (1+ i))
      )
      (setq total 0)
      (foreach item lst (setq total (+ total (cdr item))))
      (princ "\nBlock counts:")
      (foreach item lst
        (princ (strcat "\n  " (car item) ": " (itoa (cdr item))))
      )
      (princ (strcat "\nTotal inserts: " (itoa total)))
    )
    (princ "\nNo blocks found.")
  )
  (princ)
)
