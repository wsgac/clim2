;; -*- mode: common-lisp; package: tk -*-
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
;; $fiHeader: event.lisp,v 1.6 92/03/09 17:40:35 cer Exp Locker: cer $

(in-package :tk)


(defun simple-event-loop (context)
  (loop 
      (process-one-event context)))

(defconstant *xt-im-xevent*		1)
(defconstant *xt-im-timer*		2)
(defconstant *xt-im-alternate-input*	4)
(defconstant *xt-im-all* (logior *xt-im-xevent*  *xt-im-timer*  *xt-im-alternate-input*))

(defun process-one-event (context &key timeout wait-function)
  (let (mask
	(fds (mapcar #'(lambda (display)
			 (x11::display-fd display))
		     (application-context-displays context)))
	reason)
    
    (unwind-protect
	(progn (mapc #'multiprocessing::mpwatchfor fds)
	       (flet ((wait-function ()
				     (or (plusp (setq mask (app-pending context)))
					 (and wait-function
					      (funcall wait-function)
					      (setq reason :wait)))))
		     (if timeout
			 (multiprocessing:process-wait-with-timeout 
			  "Waiting for toolkit" 
			  timeout
			  #'wait-function)
		       (mp::process-wait 
			"Waiting for toolkit" 
			#'wait-function))))
      (mapc #'multiprocessing::mpunwatchfor fds))
    (cond ((plusp mask)
	   (app-process-event 
	    context 
	    ;; Because of a feature in the OLIT toolkit we need to
	    ;; give preference to events rather than timer events
	    (if (logtest mask *xt-im-xevent*) *xt-im-xevent* mask))
	   t)
	  (reason :wait-function)
	  (t :timeout))))


(defun app-pending (context)
  (app_pending context))

(defun app-process-event (context mask)
  (app_process_event context mask))



(defvar *event* nil)

(defun-c-callable event-handler ((widget :unsigned-long)
				 (client-data :unsigned-long)
				 (event :unsigned-long)
				 (continue-to-dispatch
				  :unsigned-long))
  (let* ((widget (find-object-from-address widget))
	 (eh-info (or (assoc client-data (widget-event-handler-data widget))
		      (error "Cannot find event-handler info ~S,~S"
			     widget client-data))))
    (destructuring-bind (ignore (fn &rest args))
	eh-info
      (declare (ignore ignore))
      (apply fn widget event args)
      0)))

(defvar *event-handler-address* (register-function 'event-handler))

(defun add-event-handler (widget events maskable function &rest args)
  (add_event_handler
   widget
   (encode-event-mask events)
   maskable
   *event-handler-address*
   (caar (push
	  (list (new-callback-id) (cons function args))
	  (widget-event-handler-data widget)))))

(defun build-event-mask (widget)
  (xt_build_event_mask widget))


