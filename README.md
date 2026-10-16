# GstarCAD Count Tools

Count block inserts per block name, count every object per layer, and total the length of a selection of curves.

Works with **GSTARCAD**, AutoCAD, ZWCAD, and BricsCAD.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Contents

- [About](#about)
- [Scripts Overview](#scripts-overview)
- [Quick Start](#quick-start)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

## About

Before a take-off or a clean-up pass you need numbers: how many inserts of each block are in the drawing, how many objects live on each layer, and how long a set of curves really is. These three commands answer those questions from the command line in seconds.

Everything here is free to use with GstarCAD. Download the latest GstarCAD
release from the [official GstarCAD website](https://www.gstarcad.net). All
scripts are tested with **[GSTARCAD](https://www.gstarcad.net)** and major
DWG-based CAD platforms.

## Scripts Overview

| File | Description |
|------|-------------|
| `scripts/count-blocks.lsp` | ;; count-blocks.lsp - Count every block insert, grouped by block name
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
 |
| `scripts/count-by-layer.lsp` | ;; count-by-layer.lsp - Count all objects, grouped by layer
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
 |
| `scripts/count-length.lsp` | ;; count-length.lsp - Total length of the selected curves
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
 |

## Quick Start

1. Download the `.lsp` (or `.lin`) file you need
2. In your CAD software, run `APPLOAD`
3. Load the file and type the matching command name shown in the table above

## Compatibility

Tested on GstarCAD 2026/2027 and similar DWG-based platforms. Scripts use
standard AutoLISP functions only, so they work without extra plugins.

For step-by-step [tutorials and drafting guides](https://www.gstarcad.net/cad/),
visit the GstarCAD learning center. New tips are published regularly on the
[GSTARCAD Blog](https://blog.gstarcad.net).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see the [LICENSE](LICENSE) file.
