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

(define (lower-layer-x-times image layer steps)
  (cond ((> steps 1)
	 (gimp-image-lower-layer image layer)
	 (lower-layer-x-times image layer (- steps 1)))))

(define (script-fu-pingus-reverse-layer-order inImage inDraw)
  (let ((num-layers (car (gimp-image-get-layers inImage)))
	(layers (cadr (gimp-image-get-layers inImage)))
	(layer-count 0))
    
    (gimp-undo-push-group-start image)
    (while (< layer-count num-layers)
	   (lower-layer-x-times inImage (aref layers layer-count)
				(- num-layers layer-count))
	   (set! layer-count (+ layer-count 1)))

    (gimp-undo-push-group-end image)
    (gimp-displays-flush)))

(script-fu-register
 "script-fu-pingus-reverse-layer-order"
 "<Image>/Filters/Pingus/Reverse Layer Order"
 "Reverse the layer order"
 "Ingo Ruhnke"
 "Copyright (C) 2011 Ingo Ruhnke <grumbel@gmail.com>"
 "September 13, 2011"
 "RGBA RGB INDEXED*"
 SF-IMAGE    "Image"    0
 SF-DRAWABLE "Drawable" 0)

;; EOF ;;
