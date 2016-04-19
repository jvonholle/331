#lang scheme
; evenitems.scm
; Jimmy Von Holle
; 4/19/2016
; CS 331
; A7b

(define (advance alist count)
  (if (null? alist) '()
      (if (= (remainder count 2) 0) `(list (car alist) (advance (cdr alist) (+ count 1)))
          (advance (cdr alist) (+ count 1)))))

; evenitems
; takes a list, returns all the items at an even index
(define (evenitems inlist)
  (list (car inlist) (advance (cdr inlist) 1)))
  
    
