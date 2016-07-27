;; See the file LICENSE for the full license governing this code.
;;
;; $Id: pkg.lisp,v 2.7 2007/04/17 21:45:54 layer Exp $

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

(in-package :tk-silica)
