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

(define (script-fu-pingus-unflatten-animation image drawable num-frames multi-directional)
  (let* ((width  (car (gimp-image-width image)))
	 (height (car (gimp-image-height image)))
         (frame-width (/ width num-frames))
         (frame-height (if (= multi-directional 1)
                           (/ height 2)
                           height)))

    (gimp-undo-push-group-start image)

    (let ((layers (list drawable)))
      (let ((frame 0))
        (while (< frame (- num-frames 1))
               (let ((new-layer (car (gimp-layer-copy drawable FALSE))))
                 (gimp-image-add-layer image new-layer 0)

                 (set! layers (cons new-layer layers))
                 (set! frame (+ frame 1)))))

      (set! layers (reverse layers))

      (let ((frame 0))
        (while (< frame num-frames)
               (let ((layer (list-ref layers frame)))
                 (gimp-layer-resize layer
                                    frame-width frame-height 
                                    (- (* frame frame-width))
                                    0)
                 (gimp-layer-translate layer 
                                       (- (* frame frame-width))
                                       0)
                 (set! frame (+ frame 1))))))   

    (gimp-image-resize image frame-width frame-height 0 0)

    (gimp-undo-push-group-end image)

    (gimp-displays-flush)))

;; Register the function with the GIMP:
(script-fu-register
 "script-fu-pingus-unflatten-animation"
 "<Image>/Filters/Pingus/Unflatten Animation" ; menu entry
 "Unflatten an animation consisting of a single image." ; description
 "Ingo Ruhnke"
 "Copyright (C) 2011 Ingo Ruhnke <grumbel@gmail.com>"
 "September 12, 2011"
 "RGBA RGB INDEXED*"
 SF-IMAGE    "Image"    0
 SF-DRAWABLE "Drawable" 0
 SF-VALUE "Frames" "10"
 SF-TOGGLE "Multi Directional" FALSE)

;; EOF ;;
