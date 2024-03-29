(define (gimp-cubic-scale file ratio)
  (let* (
    (not-last (lambda (l) (reverse (cdr (reverse l)))))
    (normalized-file (if (string=? "./"  (substring file 0 2))
      (substring file 2)
      file))
    (file-parts (strbreakup normalized-file "."))
    (file-extn (car (last file-parts)))
    (file-base (apply string-append (not-last file-parts)))
    (new-file (string-append "zoom/" file-base "." file-extn))
    (image (car (gimp-file-load RUN-NONINTERACTIVE normalized-file normalized-file)))
    (width (inexact->exact (ceiling (* ratio (car (gimp-image-width image))))))
    (height (inexact->exact (ceiling (* ratio (car (gimp-image-height image))))))
    (drawable (car (gimp-image-get-active-layer image))))
    (gimp-image-scale-full image width height INTERPOLATION-CUBIC)
    (gimp-file-save RUN-NONINTERACTIVE image drawable new-file new-file)
    (gimp-image-delete image)))
