;; -*- mode: common-lisp; package: xm-silica -*-
;;
;;				-[]-
;; 
;; copyright (c) 1985, 1986 Franz Inc, Alameda, CA  All rights reserved.
;; copyright (c) 1986-1991 Franz Inc, Berkeley, CA  All rights reserved.
;;
;; The software, data and information contained herein are proprietary
;; to, and comprise valuable trade secrets of, Franz, Inc.  They are
;; given in confidence by Franz, Inc. pursuant to a written license
;; agreement, and may be stored and used only in accordance with the terms
;; of such license.
;;
;; Restricted Rights Legend
;; ------------------------
;; Use, duplication, and disclosure of the software, data and information
;; contained herein by any agency, department or entity of the U.S.
;; Government are subject to restrictions of Restricted Rights for
;; Commercial Software developed at private expense as specified in FAR
;; 52.227-19 or DOD FAR Supplement 252.227-7013 (c) (1) (ii), as
;; applicable.
;;
;; $fiHeader: ol-gadgets.lisp,v 1.11 92/05/07 13:13:51 cer Exp Locker: cer $


(in-package :xm-silica)

(defmethod make-pane-class ((framem openlook-frame-manager) class &rest options) 
  (declare (ignore options))
  (second (assoc class '((scroll-bar openlook-scroll-bar)
			 (slider openlook-slider)
			 (push-button openlook-push-button)
			 (label-pane openlook-label-pane)
			 (text-field openlook-text-field)
			 (toggle-button openlook-toggle-button)
			 (menu-bar openlook-menu-bar)
			 (viewport ol-viewport)
			 (radio-box openlook-radio-box)
			 (frame-pane openlook-frame-pane)
			 (top-level-sheet openlook-top-level-sheet)
			 ;; One day
			 (line-editor-pane)
			 (label-button-pane)
			 (radio-button-pane)
			 (horizontal-divider-pane)
			 (vertical-divider-pane)
			 (label-pane)
			 ;;
			 (list-pane)
			 (caption-pane)
			 (cascade-button)
			 ))))


;;;;;;;;;;;;;;;;;;;;

(defclass openlook-scroll-bar (scroll-bar
			       xt-leaf-pane)
	  ())

(defmethod find-widget-class-and-initargs-for-sheet ((port openlook-port)
						     (parent t)
						     (sheet openlook-scroll-bar))
  (with-accessors ((orientation gadget-orientation)) sheet
		  (values 'tk::scroll-bar
			  (list :orientation orientation))))

(defmethod (setf silica::scroll-bar-size) (nv (sb openlook-scroll-bar))
  ;; (tk::set-values (sheet-direct-mirror sb) :slider-size nv)
  nv)

(defmethod (setf silica::scroll-bar-value) (nv (sb openlook-scroll-bar))
  (tk::set-values (sheet-direct-mirror sb) :slider-value nv)
  nv)

(defmethod change-scroll-bar-values ((sb openlook-scroll-bar) &rest args 
				     &key slider-size value)
  (declare (ignore args))
  (tk::set-values
   (sheet-direct-mirror sb)
   :proportion-length slider-size
   :slider-value value))


(defmethod add-sheet-callbacks ((port openlook-port) (sheet openlook-scroll-bar) (widget t))
  (tk::add-callback widget
		    :slider-moved
		    'scroll-bar-changed-callback-1
		    sheet))

(defmethod scroll-bar-changed-callback-1 ((widget t) (sheet openlook-scroll-bar))
  (multiple-value-bind
      (value size)
      (tk::get-values widget :slider-value :proportion-length)
    (scroll-bar-value-changed-callback
     sheet
     (gadget-client sheet)
     (gadget-id sheet)
     value
     size)))

(defmethod compose-space ((m openlook-scroll-bar) &key width height)
  (let ((x 16))
    (ecase (gadget-orientation m)
      (:vertical
       (make-space-requirement :width x
			       :min-height x
			       :height (* 2 x)
			       :max-height +fill+))
      (:horizontal
       (make-space-requirement :height x
			       :min-width x
			       :width (* 2 x)
			       :max-width +fill+)))))

;;; Ol DrawArea Widgets require all of this

(defmethod add-sheet-callbacks ((port openlook-port) (sheet t) (widget tk::draw-area))
  (tk::add-callback widget 
		    :expose-callback 
		    'sheet-mirror-exposed-callback
		    sheet)
  (tk::add-event-handler widget
			 '(:key-press 
			   :key-release
			   :button-press 
			   :button-release
			   ;; 
			   :enter-window 
			   :leave-window
			   :pointer-motion-hint
			   :pointer-motion
			   :button1-motion
			   :button2-motion
			   :button3-motion
			   :button4-motion
			   :button5-motion
			   :button-motion
			   )
			 1
			 'sheet-mirror-event-handler
			 sheet))

;;; top level sheet

(defclass openlook-top-level-sheet (top-level-sheet) ())

(defmethod add-sheet-callbacks :after ((port openlook-port) 
				       (sheet openlook-top-level-sheet)
				       widget)
  (tk::add-callback widget 
		    :resize-callback 'sheet-mirror-resized-callback
		    sheet))

(defmethod find-widget-class-and-initargs-for-sheet ((port openlook-port)
						     (parent t)
						     (sheet openlook-top-level-sheet))
  (values 'tk::draw-area
	  (list :layout :ignore)))


;; OpenLook viewport

(defclass ol-viewport
	  (viewport
	   mirrored-sheet-mixin)
    ())

(defmethod find-widget-class-and-initargs-for-sheet ((port openlook-port)
						     (parent t)
						     (sheet ol-viewport))
  (values 'tk::draw-area
	  '(:layout :ignore)))

(defmethod add-sheet-callbacks  :after ((port openlook-port) (sheet ol-viewport) widget)
  ;; I wonder whether this is needed since it should not be resized by
  ;; the toolkit and only as part of the goe management code that will
  ;; recurse to children anyway
  (tk::add-callback widget 
		    :resize-callback 
		    'sheet-mirror-resized-callback
		    sheet)
;  (tk::add-callback widget 
;		    :expose-callback 
;		    'sheet-mirror-exposed-callback
;		    sheet)
;  (tk::add-callback widget 
;		    :input-callback 
;		    'sheet-mirror-input-callback
;		    sheet)
;  (tk::add-event-handler widget
;			 '(:enter-window 
;			   :leave-window
;			   :pointer-motion-hint
;			   :pointer-motion
;			   :button1-motion
;			   :button2-motion
;			   :button3-motion
;			   :button4-motion
;			   :button5-motion
;			   :button-motion
;			   )
;			 0
;			 'sheet-mirror-event-handler
;			 sheet)
  )

(defclass openlook-menu-bar (xt-leaf-pane) 
	  ((command-table :initarg :command-table)))

(defmethod find-widget-class-and-initargs-for-sheet ((port openlook-port)
						     (parent t)
						     (sheet openlook-menu-bar))
  (values 'tk::control nil))

(defmethod realize-mirror :around ((port openlook-port) (sheet openlook-menu-bar))

  ;; This code fills the menu-bar. If top level items do not have
  ;; submenus then it creates one with a menu of its own
  
  (let ((mirror (call-next-method)))
    (labels ((make-menu-for-command-table (command-table parent top)
	       (map-over-command-table-menu-items
		#'(lambda (menu keystroke item)
		    (declare (ignore keystroke))
		    (let ((type (command-menu-item-type item)))
		      (case type
			(:divider)
			(:function
			 ;;--- Do this sometime
			 )
			(:menu
			 (let* ((mb (make-instance 'tk::menu-button
						  :parent parent
						  :label menu)))
			   (make-menu-for-command-table
			    (find-command-table (second item))
			    (tk::get-values mb :menu-pane)
			    nil)))
			(t
			 (let ((button 
				(make-instance 'tk::oblong-button
					       :label menu
					       :managed t
					       :parent parent)))
			   (tk::add-callback
			    button
			    :select
			    'command-button-callback-ol
			    (slot-value sheet 'silica::frame)
			    item))))))
		command-table)))
      (make-menu-for-command-table
       (slot-value sheet 'command-table)
       mirror
       t))
    mirror))

(defun command-button-callback-ol (button frame item)
  (command-button-callback button nil frame item))


;;; Label pane

(defclass openlook-label-pane (label-pane xt-leaf-pane) 
	  ())

(defmethod find-widget-class-and-initargs-for-sheet ((port openlook-port)
						     (parent t)
						     (sheet openlook-label-pane))
  (with-accessors ((label gadget-label)
		   (alignment gadget-alignment)) sheet
    (values 'tk::static-text
	    (append
	     (list :alignment 
		   (ecase alignment
		     ((:left nil) :left)
		     (:center :center)
		     (:right :right)))
	     (and label (list :string label))))))
  
;;; Push button

(defclass openlook-push-button (push-button
				openlook-action-pane
				xt-leaf-pane) 
	  ())



(defmethod find-widget-class-and-initargs-for-sheet ((port openlook-port)
						     (parent t)
						     (sheet openlook-push-button))
  (declare (ignore port))
  (with-accessors ((label gadget-label)) sheet
    (values 'tk::menu-button 
	    (and label (list :label label)))))

;;


(defclass openlook-action-pane () ())

(defmethod add-sheet-callbacks :after ((port openlook-port) (sheet openlook-action-pane) (widget t))
  (tk::add-callback widget
		    :select
		    'queue-active-event-ol
		    sheet))

(defmethod queue-active-event-ol ((widget openlook-action-pane) sheet)
  (distribute-event
   (port sheet)
   (make-instance 'activate-gadget-event
		  :gadget sheet)))


;;; Text field

(defclass openlook-text-field (openlook-value-pane 
			       openlook-action-pane
			       text-field
			       xt-leaf-pane)
	  ())

(defmethod find-widget-class-and-initargs-for-sheet ((port openlook-port)
						     (parent t)
						     (sheet openlook-text-field))
  (with-accessors ((value gadget-value)) sheet
    (values 'tk::text
	    (append
	     (and value `(:string ,value))))))


;;; Value stuff
;;; I suspect that this is worthless

(defclass openlook-value-pane () ())

(defmethod add-sheet-callbacks :after ((port openlook-port) 
				       (sheet openlook-value-pane) (widget t))
  #+igore
  (tk::add-callback widget
		    :value-changed-callback
		    'queue-value-changed-event
		    sheet))

(defmethod gadget-value ((gadget openlook-value-pane))
  (if (sheet-direct-mirror gadget)
      (tk::get-values (sheet-mirror gadget) :value)
    (call-next-method)))

(defmethod (setf gadget-value) (nv (gadget openlook-value-pane) &key invoke-callback)
  (declare (ignore invoke-callback))
  (when (sheet-mirror gadget)
    (tk::set-values (sheet-mirror gadget) :value nv)))

(defmethod queue-value-changed-event (widget sheet)
  (declare (ignore widget))
  (distribute-event
   (port sheet)
   (make-instance 'value-changed-gadget-event
		  :gadget sheet
		  :value (gadget-value sheet))))
