;; -*- mode: common-lisp; package: cl-user -*-
;; 
;; copyright (c) 1985, 1986 Franz Inc, Alameda, Ca.  All rights reserved.
;; copyright (c) 1986-1991 Franz Inc, Berkeley, Ca.  All rights reserved.
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
;; $fiHeader: pkg.lisp,v 1.13 1994/12/05 00:01:52 colin Exp $

;;; --- the motif v openlook definitions should be in separate package
;;; definition files

(defpackage :tk-silica
  (:nicknames :xm-silica :xt-silica)
  (:use :clim-lisp :clim-utils :clim :silica :tk)
  (:import-from :excl #:if*)
  (:export
   *xt-font-families*
   *xt-logical-size-alist*
   *xt-cursor-type-alist*
   ))


(setf (package-definition-lock (find-package :tk-silica)) t)
