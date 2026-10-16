;; count-length.lsp - Total length of the selected curves
;; Command: CLEN
(defun c:CLEN ( / ss i en len total )
  (vl-load-com)
  (setq ss (ssget '((0 . "LINE,LWPOLYLINE,POLYLINE,ARC,CIRCLE,ELLIPSE,SPLINE"))))
  (if ss
    (progn
      (setq i 0 total 0.0)
      (repeat (sslength ss)
        (setq en (ssname ss i))
        (setq len (vlax-curve-getDistAtParam en (vlax-curve-getEndParam en)))
        (if len (setq total (+ total len)))
        (setq i (1+ i))
      )
      (princ (strcat "\nObjects: " (itoa (sslength ss))
                     "  Total length: " (rtos total 2 4)))
    )
    (princ "\nNothing selected.")
  )
  (princ)
)
