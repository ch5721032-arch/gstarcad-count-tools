;; count-by-layer.lsp - Count all objects, grouped by layer
;; Command: CLCOUNT
(defun c:CLCOUNT ( / ss i en lay pair lst total )
  (setq ss (ssget "_X"))
  (if ss
    (progn
      (setq i 0 lst nil)
      (repeat (sslength ss)
        (setq en (ssname ss i))
        (setq lay (cdr (assoc 8 (entget en))))
        (if (setq pair (assoc lay lst))
          (setq lst (subst (cons lay (1+ (cdr pair))) pair lst))
          (setq lst (cons (cons lay 1) lst))
        )
        (setq i (1+ i))
      )
      (setq total 0)
      (foreach item lst (setq total (+ total (cdr item))))
      (princ "\nObjects per layer:")
      (foreach item lst
        (princ (strcat "\n  " (car item) ": " (itoa (cdr item))))
      )
      (princ (strcat "\nTotal objects: " (itoa total)))
    )
    (princ "\nNothing found.")
  )
  (princ)
)
