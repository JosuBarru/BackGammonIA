(deftemplate jugador
    (slot id (type INTEGER))
  	(slot tipo (type SYMBOL))
    (slot color (type INTEGER)(range -1 1)))

(deftemplate estado
    (slot id (type INTEGER))
    (slot padre (type INTEGER))
    (multislot fichas (type INTEGER) (cardinality 26 26))
    (multislot comidas (type INTEGER) (cardinality 2 2)))

;Functions
(deffunction getTipo (?num)
    (printout t "Elige el tipo de jugador " ?num " (humano/cpu): " crlf)
    (bind ?tipo (read))

    (while (and (!= (str-compare ?tipo humano) 0) (!= (str-compare ?tipo cpu) 0))
        (printout t ?tipo " NO es ninguna de las dos opciones permitidas" crlf)
        (printout t "Elige el tipo de jugador " ?num " (humano/cpu): " crlf)
        (bind ?tipo (read))
    )

    (return ?tipo)
)

(deffunction getColor ()
    (printout t "Elige el color de jugador 1 (blancas/negras): " crlf)
    (bind ?color (read))

    (while (and (!= (str-compare ?color blancas) 0) (!= (str-compare ?color negras) 0))
        (printout t ?color " NO es ninguna de las dos opciones permitidas" crlf)
        (printout t "Elige el color de jugador 1 (blancas/negras): " crlf)
        (bind ?color (read))
    )

    (if (= (str-compare ?color blancas) 0) then
        (bind ?c 1)
    else
        (bind ?c -1)

    (return ?c))
)

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
        (return 0)
    )
    (return (str-cat ?a "B"))
)

(deffunction imprimir(?fichas ?comidas)
  
  (printout t "  13     14     15     16     17     18            19     20     21     22     23     24           " crlf)
  (printout t "+____+ +____+ +____+ +____+ +____+ +____+ ++++++ +____+ +____+ +____+ +____+ +____+ +____+ | +____+" crlf)
  (printout t "|    | |    | |    | |    | |    | |    | |||||| |    | |    | |    | |    | |    | |    | | |    |" crlf)
  (printout t "| " (blancaonegra (nth$ 14 ?fichas)) " | | " (blancaonegra (nth$ 15 ?fichas)) " | | "(blancaonegra (nth$ 16 ?fichas)) " | | " (blancaonegra (nth$ 17 ?fichas)) " | | " (blancaonegra (nth$ 18 ?fichas)) " | | " (blancaonegra (nth$ 19 ?fichas)) " | ||" (blancaonegra (nth$ 1 ?comidas)) "|| | " (blancaonegra (nth$ 20 ?fichas)) " | | " (blancaonegra (nth$ 21 ?fichas)) " | | " (blancaonegra (nth$ 22 ?fichas)) " | | " (blancaonegra (nth$ 23 ?fichas)) " | | " (blancaonegra (nth$ 24 ?fichas)) " | | " (blancaonegra (nth$ 25 ?fichas)) " | | | " (blancaonegra (nth$ 26 ?fichas)) " |" crlf)
  (printout t "|    | |    | |    | |    | |    | |    | |||||| |    | |    | |    | |    | |    | |    | | |    |" crlf)
  (printout t "+____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ | +____+" crlf)
  (printout t "                                                                                           |      " crlf)
  (printout t "------------------------------------------------------------------------------------------ |      " crlf)
  (printout t "                                                                                           |      " crlf)
  (printout t "+____+ +____+ +____+ +____+ +____+ +____+ ++++++ +____+ +____+ +____+ +____+ +____+ +____+ | +____+" crlf)
  (printout t "|    | |    | |    | |    | |    | |    | |||||| |    | |    | |    | |    | |    | |    | | |    |" crlf)
  (printout t "| "(blancaonegra (nth$ 13 ?fichas))" | | "(blancaonegra (nth$ 12 ?fichas))" | | "(blancaonegra (nth$ 11 ?fichas))" | | "(blancaonegra (nth$ 10 ?fichas))" | | "(blancaonegra (nth$ 9 ?fichas))" | | "(blancaonegra (nth$ 8 ?fichas))" | ||" (blancaonegra (nth$ 2 ?comidas)) "|| | "(blancaonegra (nth$ 7 ?fichas))" | | "(blancaonegra (nth$ 6 ?fichas))" | | "(blancaonegra (nth$ 5 ?fichas))" | | "(blancaonegra (nth$ 4 ?fichas))" | | "(blancaonegra (nth$ 3 ?fichas))" | | "(blancaonegra (nth$ 2 ?fichas))" | | | "(blancaonegra (nth$ 1 ?fichas))" |" crlf)
  (printout t "|    | |    | |    | |    | |    | |    | |||||| |    | |    | |    | |    | |    | |    | | |    |" crlf)
  (printout t "+____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ +____+ | +____+" crlf)
  (printout t "  12     11     10     9      8      7             6      5      4      3      2      1          " crlf)
  (printout t crlf)
  
)

(deffunction movimientoLegal (?color ?d ?vieja ?nueva ?fichas)
     (if (!= (* (- ?vieja ?nueva) ?color) ?d) then
         (return FALSE)
     )
     (if (< (* (nth$ (+ ?nueva 1) ?fichas) ?color) -1) then
        (return FALSE)
     )
    (return TRUE)
)

;Hacer Legal Actions terminar movimiento legal

(deffunction movimiento (?color ?d ?fichas)

    (printout t "Numero de posiciones que puedes mover: " ?d crlf)
    (printout t "Elige la casilla de la que mover una ficha: ")
    (bind ?salida (read))
    (while (<= (*  (nth$ (+ ?salida 1) ?fichas) ?color) 0)
        (printout t "En la casilla " ?salida " no tienes fichas de tu color, escoge otra:" crlf)
        (bind ?salida (read))
    )

    (printout t crlf)
    (printout t "Elige la casilla a la que mover la ficha: ")
    (bind ?llegada (read))
    (while (not (movimientoLegal ?color ?d ?salida ?llegada ?fichas))
        (printout t "El movimiento no se puede realizar, escge otra casilla:" crlf)
        (bind ?llegada (read))
    )
    (bind ?fichas (replace$ ?fichas (+ ?salida 1) (+ ?salida 1) (- (nth$ (+ ?salida 1) ?fichas) ?color)))
    (bind ?fichas(replace$ ?fichas (+ ?llegada 1) (+ ?llegada 1) (+ (nth$ (+ ?llegada 1) ?fichas) ?color)))
    (printout t ?fichas crlf)

    (return ?fichas)


)


;Rules
(defrule inicio
	;(declare (salience 50))
    ?i<-(initial-fact)
=>
	(retract ?i)

  (bind ?tipo1 (getTipo 1))
    
  (bind ?color1 (getColor))

  (assert (jugador (id 1) (tipo ?tipo1) (color ?color1)))

  (bind ?tipo2 (getTipo 2))
  (bind ?color2 (* ?color1 -1))
    
  (assert (jugador (id 1) (tipo ?tipo2) (color ?color2)))
    
  (assert (estado (id 0) (padre -1) (fichas (create$ 0 -2 0 0 0 0 5 0 3 0 0 0 -5 5 0 0 0 -3 0 -5 0 0 0 0 2 0)) (comidas (create$ 0 0)))))

(defrule jugar
    ;(declare (salience 25))
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas $?comidas))
=>
    (retract ?e)
    (imprimir ?fichas)
    (bind $?d (tirarDados))
    (movimiento 1 (nth$ 1 $?d) ?fichas)
    (imprimir ?fichas)
)
