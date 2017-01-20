; The rosette interface for cosette

#lang rosette

(require "util.rkt" "table.rkt" "equal.rkt" "sql.rkt")
(require racket/pretty)
(require json)

(provide cosette-sol->json 
         cosette-solve)

(define (cosette-sol->json solution)
  (let ([status (car solution)]
        [tables (cdr solution)])
    (jsexpr->string 
      (hasheq 'status status
              'counter-example (map (lambda (t) (table->jsexpr t)) tables)))))

(define (cosette-solve q1 q2 input-tables)
  (let ([solution (verify (same q1 q2))])
    (cond 
      [(sat? solution) (cons "neq" (evaluate input-tables solution))]
      [else (cons "eq"  (list))]))) 

(define (table->jsexpr t) 
  (hasheq 'table-name (get-table-name t) 
          'table-content (list (get-schema t) 
                         (map (lambda (r) (list (car r) (cdr r))) 
                              (get-content t)))))
