(deftemplate jugador
    (slot id (type INTEGER))
  	(slot tipo (type SYMBOL))
    (slot color (type INTEGER)(allowed-integers -1 1)))

(deftemplate estado
    (slot id (type INTEGER))
    (slot padre (type INTEGER))
    (multislot fichas (type INTEGER) (cardinality 26 26)) ; De 1 a 24 son las casillas del tablero, 25 es la casilla de la meta blanca y 26 la de negras
    (multislot comidas (type INTEGER) (cardinality 2 2))
    (slot turno (type INTEGER)(allowed-integers -1 1))
    (slot jugador (type SYMBOL)))


(deftemplate movimiento
    (slot origen (type INTEGER)(range 0 25)) ;De 1 a 24 son las casillas del tablero, 25 es la casilla de blancas comidas y 0 la de negras comidas 
    (slot destino (type INTEGER)(range 1 26))) ;De 1 a 24 son las casillas del tablero, 25 es la casilla de la meta de blancas y 26 la de negras 

(deftemplate dado
    (slot d1 (type INTEGER)(range 1 6))
    (slot id (type INTEGER) (range 1 4)))


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

; (deffunction tirarDados ()
;     (seed (round (time))) 

;     (bind ?d1 (random 1 6))
;     (bind ?d2 (random 1 6))
    
;     (printout t "Dados: " ?d1 " , " ?d2 crlf)
;     (return (create$ ?d1 ?d2))
; )

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


    (if (>  (* ?turno (nth$ ?destino  ?fichas)) -2) then ;Mira si tiene dos o más fichas contrarias la casilla destino
        (printout t "Salida: " ?salida " Destino: " ?destino crlf)
        (assert (movimiento  (origen ?salida) (destino ?destino)))
        (return 0)
    )

)

(deffunction salidas(?fichas ?dado ?turno)
    (loop-for-count (?i 1 24)
        (if (> (* ?turno (nth$ ?i ?fichas)) 0) then
            (destinos ?i ?fichas ?dado ?turno)
        )
    )
)

(deffunction evaluarBlancas (?fichas ?comidas ?dados)
    (if (= (nth$ 25 ?fichas) 15) then
        (return 1000)
    )
    (bind ?puntuacion 0)
    (bind ?puntuacion (- ?puntuacion (* (nth$ 1 ?comidas) 10))) ;Restamos por piezas que nos han comido
    (bind ?puntuacion (+ ?puntuacion (* (nth$ 2 ?comidas) 10))) ;Sumamos por piezas que comemos

    (bind ?puntuacion (+ ?puntuacion (* (nth$ 25 ?fichas) 15))) ;Sumamos por las piezas que hayan llegado al final
    (bind ?puntuacion (- ?puntuacion (* (nth$ 26 ?fichas) 15))) ;Restamos por las piezas rivales que hayan llegado al final

    (loop-for-count (?i 1 24)
        (if (> (nth$ ?i ?fichas) 0) then
            (bind ?puntuacion (- ?puntuacion (* (nth$ ?i ?fichas) ?i))) ;Restamos la distancia total de las blancas a la meta
        else 
            (if (< (nth$ ?i ?fichas) 0) then
                (bind ?puntuacion (+ ?puntuacion (* (nth$ ?i ?fichas) (- 25 ?i)))) ;Sumamos la distancia total de las negras a la meta
            )
        )
    )

    (if (any-factp ((?e estado)) (> ?e:fichas 6)) then
        (bind ?puntuacion (+ ?puntuacion 50))            ; Sumamos 50 si ya podemos meter las blancas en la meta
    )

    (if (any-factp ((?e estado)) (< ?e:fichas 19)) then
        (bind ?puntuacion (- ?puntuacion 50))            ; Restamos 50 si ya podemos meter las negras en la meta
    )

    (return ?puntuacion)
)

(deffunction evaluarNegras (?fichas ?comidas)
    (if (= (nth$ 26 ?fichas) -15) then
        (return 1000)
    )
    (bind ?puntuacion 0)
    (bind ?puntuacion (- ?puntuacion (* (nth$ 2 ?comidas) 10))) ;Restamos por piezas que nos han comido
    (bind ?puntuacion (+ ?puntuacion (* (nth$ 1 ?comidas) 10))) ;Sumamos por piezas que comemos

    (bind ?puntuacion (+ ?puntuacion (* (nth$ 25 ?fichas) 15))) ;Sumamos por las piezas que hayan llegado al final
    (bind ?puntuacion (- ?puntuacion (* (nth$ 26 ?fichas) 15))) ;Restamos por las piezas rivales que hayan llegado al final

    (loop-for-count (?i 1 24)
        (if (< (nth$ ?i ?fichas) 0) then
            (bind ?puntuacion (- ?puntuacion (* (nth$ ?i ?fichas) (- 25 ?i)))) ;Restamos la distancia total de las negras a la meta
        else 
            (if (> (nth$ ?i ?fichas) 0) then
                (bind ?puntuacion (+ ?puntuacion (* (nth$ ?i ?fichas) ?i))) ;Sumamos la distancia total de las blancas a la meta
            )
        )
    )

    (if (any-factp ((?e estado)) (< ?e:fichas 19)) then
        (bind ?puntuacion (+ ?puntuacion 50))            ; Sumamos 50 si ya podemos meter las negras en la meta
    )

    (if (any-factp ((?e estado)) (> ?e:fichas 6)) then
        (bind ?puntuacion (- ?puntuacion 50))            ; Restamos 50 si ya podemos meter las blancas en la meta
    )

    (return ?puntuacion)
)

;Funciones salidas, destinos alteradas para cuando se pueden empezar a meter fichas en la meta, es decir, cuando hay 15 fichas en el ultimo cuadrante

(deffunction destinosmeta1(?salida ?fichas ?dado)

    (bind ?destino (- ?salida ?dado))


    (if (< ?destino 0) then 
        (return 0)
    )

    (if (eq ?destino 0) then
        (printout t "Salida: " ?salida " Destino: Meta blanca (25)"  crlf)
        (assert (movimiento  (origen ?salida) (destino 25)))
        (return 0)
    )

    (if (>  (nth$ ?destino ?fichas) -2) then ;Mira si tiene dos o más fichas contrarias la casilla destino
        (printout t "Salida: " ?salida " Destino: " ?destino crlf)
        (assert (movimiento  (origen ?salida) (destino ?destino)))
    )
    
)

(deffunction destinosmeta2(?salida ?fichas ?dado)

    (bind ?destino (+ ?salida ?dado))

    (if (> ?destino 25) then 
        (return 0)
    )

    (if (eq ?destino 25) then
        (printout t "Salida: " ?salida " Destino: Meta negra (26)"  crlf)
        (assert (movimiento  (origen ?salida) (destino 26)))
        (return 0)
    )

    (if (< (nth$ ?destino ?fichas) 2) then
       (printout t "Salida: " ?salida " Destino: " ?destino crlf)
        (assert (movimiento  (origen ?salida) (destino ?destino)))
    )
)


(deffunction salidasmeta1(?fichas ?dado)
    (loop-for-count (?i 1 6)
        (if (>  (nth$ ?i ?fichas) 0) then
            (destinosmeta1 ?i ?fichas ?dado)
        )
    )
)

(deffunction salidasmeta2(?fichas ?dado)
    (loop-for-count (?i 19 24)
        (if (< (nth$ ?i ?fichas) 0) then
            (destinosmeta2 ?i ?fichas ?dado)
        )
    )
)




(deffunction movimiento_libre_final1(?fichas ?dado) ; para blancas funcion para cuando la ficha mas lejana esta a una distancia menor que el dado y nos encontramos en el final
    (loop-for-count (?i 1 6)
        (if (>  (nth$ ?i ?fichas) 0) then
            (printout t "Salida: " ?i " Destino: Meta blanca (25)"  crlf)
            (assert (movimiento  (origen ?i) (destino 25)))
        )
    )
   
)

(deffunction movimiento_libre_final2(?fichas ?dado); para negras funcion para cuando la ficha mas lejana esta a una distancia menor que el dado y nos encontramos en el final
    (loop-for-count (?i 19 24)
        (if (< (nth$ ?i ?fichas) 0) then
            (printout t "Salida: " ?i " Destino: Meta negra (26)"  crlf)
            (assert (movimiento  (origen ?i) (destino 26)))        
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
    
  (assert (jugador (id 2) (tipo ?tipo2) (color ?color2)))
    
  (assert (estado (id -1) (padre -2) (fichas (create$ -2 0 0 0 0 5 0 3 0 0 0 -5 5 0 0 0 -3 0 -5 0 0 0 0 2 0 0)) (comidas (create$ 0 0)) (turno -1) (jugador ?tipo1)))
  )



(defrule dados
    (declare (salience 0))
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas $?comidas) (turno ?t) (jugador ?))
=>

    (printout t "seguir jugando? (s/n)" crlf) ; para parar la ejecucion si se rinde el rival
    (bind ?r (read))
    (if (eq ?r n) then; a menos que pongas n se sigue jugando
        (return 0)
    )

    (retract ?e)
    (bind ?id1 (+ ?id 1))
    (bind ?turno1 (* ?t -1))
    
    (do-for-fact ((?jugador jugador)) (eq ?jugador:color ?turno1)
    (bind ?j ?jugador:tipo)
    )
    
    (assert (estado (id ?id1) (padre ?id) (fichas ?fichas) (comidas ?comidas) (turno ?turno1) (jugador ?j)))

    (imprimir ?fichas ?comidas)
    (printout t "resultado del primer dado:" crlf)
    (bind ?d1 (read))
    (printout t "resultado del primer dado:" crlf)
    (bind ?d2 (read))
    (assert (dado (d1 ?d1) (id 1)))
    (assert (dado (d1 ?d2) (id 2)))
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

    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas ~0 ?x) (turno 1) (jugador ?))
    ?d <- (dado (d1 ?d1) (id ?id1))
    =>

    (destinos 25 ?fichas ?d1 1)
)

(defrule comidas2
    (declare (salience 100))  

    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas ?x ~0) (turno -1) (jugador ?))
    ?d <- (dado (d1 ?d1) (id ?id1))
    =>

    (destinos 0 ?fichas ?d1 -1)
)

;Casos en que no hay comidas ; modificado para el caso de meta y no meta
(defrule nocomidas1
    (declare (salience 100))  
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas 0 ?x) (turno 1) (jugador ?))
    ?d <- (dado (d1 ?d1))
    =>  
    ;mirar que las fichas no esten todas en el ultimo cuadrante de las blancas
    (bind ?num 0); para saber si estan todas en el ultimo cuadrante
    (bind ?pos_lejana); para saber si podemos meter aunque no sean exactos
    (loop-for-count (?f 1 6)
        (bind ?fi_casilla (nth$ ?f ?fichas)); numero de fichass en la casilla
        (if (> ?fi_casilla 0) then ; solo si las fichas son blancas se suman
            (bind ?num (+ ?num ?fi_casilla))
            (bind ?pos_lejana ?f)
        )
    )
    (bind ?num (+ ?num (nth$ 25 ?fichas))); sumamos las fichas que estan en la meta
    (printout t "para debug: numero de fichas en el ultimo cuadrante: " ?num crlf)
    (printout t "para debug: posicion mas lejana: " ?pos_lejana crlf)
    (if (< ?num 15) then
        (printout t "no es final" crlf)
        (salidas ?fichas ?d1 1)
    else (if (< ?pos_lejana  ?d1) then
            (movimiento_libre_final1 ?fichas ?d1)
        else
            (salidasmeta1 ?fichas ?d1)
         )
    )

)
; modificado para el caso de meta y no meta
(defrule nocomidas2 
    (declare (salience 100))  
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas ?x 0) (turno -1) (jugador ?))
    ?d <- (dado (d1 ?d1))
    =>  
    (bind ?num 0); para saber si estan todas en el ultimo cuadrante
    (bind ?pos_lejana); para saber si podemos meter aunque no sean exactos
    (foreach ?f (create$ 24 23 22 21 20 19); orden inverso para conseguir la mas lejana
        (bind ?fi_casilla (nth$ ?f ?fichas)); numero de fichass en la casilla
        (if (< ?fi_casilla 0) then ; solo si las fichas son blancas se suman
            (bind ?num (+ ?num ?fi_casilla))
            (bind ?pos_lejana ?f)
        )
    )

    (bind ?num (+ ?num (nth$ 26 ?fichas))); sumamos las fichas que estan en la meta
     (printout t "para debug: numero de fichas en el ultimo cuadrante: " ?num crlf)
    (printout t "para debug: posicion mas lejana: " ?pos_lejana crlf)
    (if (> ?num -15) then
        (printout t "no es final" crlf)
        (salidas ?fichas ?d1 -1)
    else (if (< (+ ?pos_lejana ?d1) 25) then
            (movimiento_libre_final2 ?fichas ?d1)
            (retract ?d)
        else
            (salidasmeta2 ?fichas ?d1)
         )
    )
)

(defrule borrarDados ; regla para borrar los dados sino existen movimientos
    (declare (salience 10))
    ?d1<-(dado (d1 ?) (id ?))
    =>
    (retract ?d1)
    (printout t "NO HAY MOVIMIENTOS POSIBLES" crlf)
)



(defrule eleccion 
    (declare (salience 10))
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas $?comidas) (turno ?t) (jugador ?jug))
    (movimiento (origen ?) (destino ?)); si solo hay uno ni preguntar
    (test (= (str-compare ?jug humano) 0))
    =>  
    (printout t "Dime la casilla de origen:" )
    (bind ?origen (read))

    (while (not(any-factp ((?m movimiento)) (eq ?m:origen ?origen)))
         (printout t ?origen " NO es ninguna de las opciones permitidas" crlf)  ;Bucle que comprueba si el origen es una opcion
         (printout t "Dime la casilla de origen:")
         (bind ?origen (read))
    )
    (printout t "Posibles destinos: ")
    (do-for-all-facts ((?m movimiento)) (eq ?m:origen ?origen) ;Imprime todos los que tienen el origen dado
        (printout t ?m:destino ", ")
    )
    (printout t crlf)
    (printout t "Dime la casilla de destino: ")
    (bind ?destino (read)) 

    (while (not(any-factp ((?m movimiento)) (and (eq ?m:origen ?origen) (eq ?m:destino ?destino))))
         (printout t ?destino " NO es ninguna de las opciones permitidas" crlf) ;Bucle que comprueba si el destino es una opcion
         (printout t "Dime la casilla de destino:" )
         (bind ?destino (read))
    )
    (printout t "realizar movimiento de la ficha en " ?origen " a " ?destino crlf)
    (do-for-all-facts ((?m movimiento))
       (retract ?m)
    )
    (retract ?e)


    (if (eq ?destino 25) then
        (bind ?destino_dif 0)
    )

    (if (eq ?destino 6) then
        (bind ?destino_dif 25)
    )

    (bind ?destino_dif ?destino)

    (bind ?diferencia (abs (- ?destino_dif ?origen)))

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

    (do-for-fact ((?jugador jugador)) (eq ?jugador:color ?t)
    (bind ?j ?jugador:tipo)
    )

    (assert (estado (id ?id) (padre ?padre) (fichas ?fichas) (comidas ?comidas) (turno ?t) (jugador ?j)))

    (imprimir ?fichas ?comidas)

)

