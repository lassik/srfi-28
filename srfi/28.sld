;; Copyright 2002 Scott G. Miller
;; SPDX-License-Identifier: MIT

(define-library (srfi 28)
  (export format)
  (import (scheme base) (scheme write))
  (begin

(define (format format-string . objects)
    (let ((buffer (open-output-string)))
      (let loop ((format-list (string->list format-string))
                 (objects objects))
        (cond ((null? format-list) (get-output-string buffer))
              ((char=? (car format-list) #\~)
               (if (null? (cdr format-list))
                   (error 'format "Incomplete escape sequence")
                   (case (cadr format-list)
                     ((#\a)
                      (if (null? objects)
                          (error 'format "No value for escape sequence")
                          (begin
                            (display (car objects) buffer)
                            (loop (cddr format-list) (cdr objects)))))
                     ((#\s)
                      (if (null? objects)
                          (error 'format "No value for escape sequence")
                          (begin
                            (write (car objects) buffer)
                            (loop (cddr format-list) (cdr objects)))))
                     ((#\%)
                      (newline buffer)
                      (loop (cddr format-list) objects))
                     ((#\~)
                      (write-char #\~ buffer)
                      (loop (cddr format-list) objects))
                     (else
                      (error 'format "Unrecognized escape sequence")))))
              (else (write-char (car format-list) buffer)
                    (loop (cdr format-list) objects))))))

))
