;; -*- mode: common-lisp; package: tk -*-
;; copyright (c) 1985,1986 Franz Inc, Alameda, Ca.
;; copyright (c) 1986-1998 Franz Inc, Berkeley, CA  - All rights reserved.
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
;; Commercial Software developed at private expense as specified in
;; DOD FAR Supplement 52.227-7013 (c) (1) (ii), as applicable.
;;
;; $Id: ol-defs.lisp,v 1.11 1998/08/06 23:17:17 layer Exp $

;;
;; This file contains compile time only code -- put in clim-debug.fasl.
;;

(in-package :tk)

(provide :clim-debugol)

(def-c-type (ol-callback-struct :no-defuns) :struct
	    (reason :int))

(def-c-type (ol-expose-callback-struct :no-defuns) :struct
	    (reason :int)
	    (event * x11:xevent))


(def-c-type (ol-resize-callback-struct :no-defuns) :struct
	    (reason :int)
	    (x xt-position)
	    (y xt-position)
	    (width xt-dimension)
	    (height xt-dimension))

(def-c-type (ol-wm-protocol-verify :no-defuns) :struct
	    (message-type :int)
	    (event * x11:xevent))

(def-c-typedef ol-define :short)
(def-c-typedef ximage :long)
(def-c-typedef ol-bit-mask :unsigned-long)

(def-c-type (ol-list-item :no-defuns) :struct
	    (label-type ol-define)
	    (label xt-pointer)
	    (glyph * ximage)
	    (attr ol-bit-mask)
	    (user-data xt-pointer)
	    (mnemonic :unsigned-char))

(defconstant ol-string 63)

(defconstant ol_b_list_attr_appl	(byte 16 0))
(defconstant ol_b_list_attr_current	(byte 1 17))
(defconstant ol_b_list_attr_selected	(byte 1 18))
(defconstant ol_b_list_attr_focus	(byte 1 19))
(defconstant ol_widget_help 73)
(defconstant ol_transparent_source 69)

(def-c-type (ol-sw-geometries :no-defuns) :struct
	    (sw * xt-widget)
	    (vsb * xt-widget)
	    (hsb * xt-widget)
	    (bb-border-width xt-dimension)
	    (vsb-width xt-dimension)
	    (vsb-min-height xt-dimension)
	    (hsb-height xt-dimension)
	    (hsb-min-width xt-dimension)
	    (sw-view-width xt-dimension)
	    (sw-view-height xt-dimension)
	    (bbc-width xt-dimension)
	    (bbc-height xt-dimension)
	    (bbc-real-width xt-dimension)
	    (bbc-real-height xt-dimension)
	    (force-hsb boolean)
	    (force-vsb boolean)
	    )


(def-c-type (ol-scroll-bar-verify :no-defuns) :struct
	    (new-location :int)
	    (new-page :int)
	    (ok boolean)
	    (slider-min :int)
	    (slider-max :int)
	    (delta :int))
