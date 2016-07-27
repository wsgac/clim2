;; See the file LICENSE for the full license governing this code.
;;
;; $Id: load-xlib.lisp,v 2.7 2007/04/17 21:45:54 layer Exp $

(in-package :x11)

#+(and (not (version>= 5 0)) (not dlfcn))
(progn

  (defvar sys::*libx11-pathname* "X11")

  (unless (ff:get-entry-point (ff:convert-foreign-name "XAllocColor"))
    (load "clim2:;stub-x.o"
	  :system-libraries (list sys::*libx11-pathname*)
	  :print t))

  (unless (ff:get-entry-point (ff:convert-foreign-name "lisp_XDrawString"))
    (load "clim2:;xlibsupport.o"
	  :system-libraries (list sys::*libx11-pathname*)
	  :print t)))
