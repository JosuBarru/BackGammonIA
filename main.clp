(deftemplate jugador
    (slot id (type INTEGER))
  	(slot tipo (type SYMBOL))
    (slot color (type INTEGER)(allowed-integers -1 1)))

(deftemplate estado
    (slot id (type INTEGER))
    (slot padre (type INTEGER))
    (multislot fichas (type INTEGER) (cardinality 26 26)) ; De 1 a 24 son las casillas del tablero, 25 es la casilla de la meta blanca y 26 la de negras
    (multislot comidas (type INTEGER) (cardinality 2 2))
    (slot turno (type INTEGER)(allowed-integers -1 1)))


(deftemplate movimiento
    (slot origen (type INTEGER)(range 0 25)) ;De 1 a 24 son las casillas del tablero, 25 es la casilla de blancas comidas y 0 la de negras comidas 
    (slot destino (type INTEGER)(range 0 25))) ;De 1 a 24 son las casillas del tablero, 0 es la casilla de la meta de blancas y 25 la de negras 

(deftemplate dado
    (slot d1 (type INTEGER)(range 1 6))
    (slot id (type INTEGER) (range 1 4)))


;Functions
; (deffunction getTipo (?num)
;     (printout t "Elige el tipo de jugador " ?num " (humano/cpu): " crlf)
;     (bind ?tipo (read))

;     (while (and (!= (str-compare ?tipo humano) 0) (!= (str-compare ?tipo cpu) 0))
;         (printout t ?tipo " NO es ninguna de las dos opciones permitidas" crlf)
;         (printout t "Elige el tipo de jugador " ?num " (humano/cpu): " crlf)
;         (bind ?tipo (read))
;     )

;     (return ?tipo)
; )

(deffunction getTipo (?num)
    (printout t "Elige el tipo de jugador " ?num " (humano/cpu): " crlf)
    (bind ?tipo (read))

    (if (= (str-compare ?tipo cpu) 0) then
        (return cpu)
    else
        (return humano)
    )
)

(deffunction getColor ()
    (printout t "Elige el color de jugador 1 (blancas/negras): " crlf)
    (bind ?color (read))

    (if (= (str-compare ?color negras) 0) then
        (return -1)
    else
        (return 1) 
    )
)


; (deffunction getColor ()
;     (printout t "Elige el color de jugador 1 (blancas/negras): " crlf)
;     (bind ?color (read))

;     (while (and (!= (str-compare ?color blancas) 0) (!= (str-compare ?color negras) 0))
;         (printout t ?color " NO es ninguna de las dos opciones permitidas" crlf)
;         (printout t "Elige el color de jugador 1 (blancas/negras): " crlf)
;         (bind ?color (read))
;     )

;     (if (= (str-compare ?color blancas) 0) then
;         (bind ?c 1)
;     else
;         (bind ?c -1)

;     (return ?c))
; )

(deffunction tirarDados ()
    (seed (round (time))) 

    (bind ?d1 (random 1 6))
    (bind ?d2 (random 1 6))
    
    (printout t "Dados: " ?d1 " , " ?d2 crlf)
    (return (create$ ?d1 ?d2))
)

;Imprimir en ascii art el tablero
(deffunction blancaonegra(?a)
    (if (< ?a 0) then
        (return (str-cat (abs ?a) "N")) 
    )
    (if (= ?a 0) then
        (return "0 ")
    )
    (return (str-cat ?a "B"))
)

(deffunction imprimir(?fichas ?comidas)
  
  (printout t "  13     14     15     16     17     18            19     20     21     22     23     24           " crlf)
  (printout t "+____+ +____+ +____+ +____+ +____+ +____+ ++++++ +____+ +____+ +____+ +____+ +____+ +____+ | +____+" crlf)
  (printout t "|    | |    | |    | |    | |    | |    | |||||| |    | |    | |    | |    | |    | |    | | |    |" crlf)
  (printout t "| " (blancaonegra (nth$ 13 ?fichas)) " | | " (blancaonegra (nth$ 14 ?fichas)) " | | "(blancaonegra (nth$ 15 ?fichas)) " | | " (blancaonegra (nth$ 16 ?fichas)) " | | " (blancaonegra (nth$ 17 ?fichas)) " | | " (blancaonegra (nth$ 18 ?fichas)) " | ||" (nth$ 1 ?comidas) " || | " (blancaonegra (nth$ 19 ?fichas)) " | | " (blancaonegra (nth$ 20 ?fichas)) " | | " (blancaonegra (nth$ 21 ?fichas)) " | | " (blancaonegra (nth$ 22 ?fichas)) " | | " (blancaonegra (nth$ 23 ?fichas)) " | | " (blancaonegra (nth$ 24 ?fichas)) " | | | " (blancaonegra (nth$ 26 ?fichas)) " |" crlf)
  (printout t "|    | |    | |    | |    | |    | |    | |||||| |    | |    | |    | |    | |    | |    | | |    |" crlf)
  (printout t "+____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ | +____+" crlf)
  (printout t "                                                                                           |      " crlf)
  (printout t "------------------------------------------------------------------------------------------ |      " crlf)
  (printout t "                                                                                           |      " crlf)
  (printout t "+____+ +____+ +____+ +____+ +____+ +____+ ++++++ +____+ +____+ +____+ +____+ +____+ +____+ | +____+" crlf)
  (printout t "|    | |    | |    | |    | |    | |    | |||||| |    | |    | |    | |    | |    | |    | | |    |" crlf)
  (printout t "| "(blancaonegra (nth$ 12 ?fichas))" | | "(blancaonegra (nth$ 11 ?fichas))" | | "(blancaonegra (nth$ 10 ?fichas))" | | "(blancaonegra (nth$ 9 ?fichas))" | | "(blancaonegra (nth$ 8 ?fichas))" | | "(blancaonegra (nth$ 7 ?fichas))" | || " (nth$ 2 ?comidas) "|| | "(blancaonegra (nth$ 6 ?fichas))" | | "(blancaonegra (nth$ 5 ?fichas))" | | "(blancaonegra (nth$ 4 ?fichas))" | | "(blancaonegra (nth$ 3 ?fichas))" | | "(blancaonegra (nth$ 2 ?fichas))" | | "(blancaonegra (nth$ 1 ?fichas))" | | | "(blancaonegra (nth$ 25 ?fichas))" |" crlf)
  (printout t "|    | |    | |    | |    | |    | |    | |||||| |    | |    | |    | |    | |    | |    | | |    |" crlf)
  (printout t "+____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ | +____+" crlf)
  (printout t "  12     11     10     9      8      7             6      5      4      3      2      1          " crlf)
  (printout t crlf)
  
)

(deffunction destinos(?salida ?fichas ?dado ?turno)
    (bind ?destino (- ?salida (* ?dado ?turno)))
    (if (or (<= ?destino 0) (>= ?destino 25)) then
        (return 0)
    )


    (if (>  (* ?turno (nth$ ?destino  ?fichas)) -2) then
        (printout t "Salida: " ?salida " Destino: " ?destino crlf)
        (assert (movimiento  (origen ?salida) (destino ?destino)))
    )

)

(deffunction salidas(?fichas ?dado ?turno)
    (loop-for-count (?i 1 24)
        (if (> (* ?turno (nth$ ?i ?fichas)) 0) then
            (destinos ?i ?fichas ?dado ?turno)
        )
    )
)


;Rules
(defrule inicio
    ?i<-(initial-fact)
=>
	(retract ?i)

  (bind ?tipo1 (getTipo 1))
    
  (bind ?color1 (getColor))

  (assert (jugador (id 1) (tipo ?tipo1) (color ?color1)))

  (bind ?tipo2 (getTipo 2))
  (bind ?color2 (* ?color1 -1))
    
  (assert (jugador (id 1) (tipo ?tipo2) (color ?color2)))
    
  (assert (estado (id -1) (padre -2) (fichas (create$ -2 0 0 0 0 5 0 3 0 0 0 -5 5 0 0 0 -3 0 -5 0 0 0 0 2 0 0)) (comidas (create$ 0 0)) (turno -1))))



(defrule dados
    (declare (salience 0))
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas $?comidas) (turno ?t))
=>

    (retract ?e)
    (bind ?id1 (+ ?id 1))
    (bind ?turno1 (- ?t (* 2 ?t)))
    (assert (estado (id ?id1) (padre ?id) (fichas ?fichas) (comidas ?comidas) (turno ?turno1)))

    (imprimir ?fichas ?comidas)
    (bind $?d (tirarDados))
    (assert (dado (d1(nth$ 1 ?d)) (id 1)))
    (assert (dado (d1(nth$ 2 ?d)) (id 2)))
)

(defrule dobles 
  (declare (salience 110))
  ?d1<-(dado (d1 ?dado1) (id 1))
  ?d2<-(dado (d1 ?dado2) (id 2))
  (test (= ?dado1 ?dado2))
  =>
  (assert (dado (d1 ?dado1) (id 3)))
  (assert (dado (d1 ?dado2) (id 4) ))
)


; (defrule elegir )

;Casos en que hay comidas
(defrule comidas1
    (declare (salience 100))  

    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas ~0 ?x) (turno 1))
    ?d <- (dado (d1 ?d1) (id ?id1))
    =>

    (destinos 25 ?fichas ?d1 1)
)

(defrule comidas2
    (declare (salience 100))  

    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas ?x ~0) (turno -1))
    ?d <- (dado (d1 ?d1) (id ?id1))
    =>

    (destinos 0 ?fichas ?d1 -1)
)

;Casos en que no hay comidas
(defrule nocomidas1
    (declare (salience 100))  
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas 0 ?x) (turno 1))
    ?d <- (dado (d1 ?d1))
    =>  
    (salidas ?fichas ?d1 1)
)

(defrule nocomidas2
    (declare (salience 100))  
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas ?x 0) (turno -1))
    ?d <- (dado (d1 ?d1))
    =>  
    (salidas ?fichas ?d1 -1)
)


(defrule eleccion 
    (declare (salience 10))
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas $?comidas) (turno ?t))
    (movimiento (origen ?) (destino ?)); si solo hay uno ni preguntar
    =>  
    (printout t "Dime la casilla de origen:")
    (bind ?origen (read))
    (printout t "Posibles destinos: ")
    (do-for-all-facts ((?m movimiento)) (eq ?m:origen ?origen)
        (printout t ?m:destino ", " crlf)
    )
    (printout t crlf)
    (printout t "Dime la casilla de destino: ")
    (bind ?destino (read)) ; Ralizamos comprobacion?
    (printout t "realizar movimiento de la ficha en " ?origen " a " ?destino crlf)
    (do-for-all-facts ((?m movimiento))
       (retract ?m)
    )
    (retract ?e)

    (bind ?diferencia (abs (- ?destino ?origen)))

    (do-for-fact ((?dado dado)) ( = ?dado:d1 ?diferencia); eliminar dado usado
        (retract ?dado)
    )

    (if (= (nth$ ?destino ?fichas) (* -1 ?t)) then ; si hay una fichas del otro color
        (if (= ?t 1) then
            (bind $?comidas(replace$ ?comidas 2 2 (+ (nth$ 2 ?comidas) 1)))
            (bind $?fichas (replace$ ?fichas ?destino ?destino 0))
        )
        (if (= ?t -1) then
            (bind $?comidas (replace$ ?comidas 1 1 (+ (nth$ 1 ?comidas) 1)))
            (bind $?fichas (replace$ ?fichas ?destino ?destino 0))
        )
    )
    (if (= ?origen 25) then
        (bind $?comidas (replace$ ?comidas 1 1 (- (nth$ 1 ?comidas) 1)))
        (printout  t "comidas: "  crlf)
        else
        (if (= ?origen 0) then
            (bind $?comidas (replace$ ?comidas 2 2 (- (nth$ 2 ?comidas) 1)))
            (printout  t "comidas: "  crlf)
            else
            (bind $?fichas (replace$ ?fichas ?origen ?origen (- (nth$ ?origen ?fichas) ?t))) ; una ficha menos en el origen
        )
    )
        


    

    (bind $?fichas (replace$ ?fichas ?destino ?destino (+ (nth$ ?destino ?fichas) ?t))) ; una ficha mas en el destino

    (assert (estado (id ?id) (padre ?padre) (fichas ?fichas) (comidas ?comidas) (turno ?t)))

    (imprimir ?fichas ?comidas)

)

