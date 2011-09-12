;;  Pingus Gimp Scripts
;;  Copyright (C) 2011 Ingo Ruhnke <grumbel@gmail.com>
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;  
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.
;;  
;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <http:;;www.gnu.org/licenses/>.

(define (script-fu-pingus-flatten-animation image drawable)
  (let* ((layers (gimp-image-get-layers image))
	 (num-layers  (car layers))
	 (layer-array (cadr layers))
	 (width  (car (gimp-image-width image)))
	 (height (car (gimp-image-height image))))

    (gimp-undo-push-group-start image)

    (gimp-image-resize image (* width num-layers) height 0 0)

    (let ((idx 0))
      (while (< idx num-layers)
             (let ((layer (vector-ref layer-array idx)))
               (gimp-layer-translate layer 
                                     (* (- num-layers idx 1) width)
                                     0)
               (set! idx (+ idx 1)))))

    (gimp-image-merge-visible-layers image CLIP-TO-IMAGE)

    (gimp-undo-push-group-end image)

    (gimp-displays-flush)))

;; Register the function with the GIMP:
(script-fu-register
 "script-fu-pingus-flatten-animation"
 "<Image>/Filters/Pingus/Flatten Animation" ; menu entry
 "Flatten an animation consisting of one layer per frame" ; description
 "Ingo Ruhnke"
 "Copyright (C) 2011 Ingo Ruhnke <grumbel@gmail.com>"
 "September 12, 2011"
 "RGBA RGB INDEXED*"
 SF-IMAGE    "Image"    0
 SF-DRAWABLE "Drawable" 0)

;; EOF ;;
