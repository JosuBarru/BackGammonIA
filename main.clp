
(deftemplate jugador
    (slot id (type INTEGER))
  	(slot tipo (type SYMBOL))
    (slot color (type INTEGER)(range -1 1)))

(deftemplate estado
    (slot id (type INTEGER))
    (slot padre (type INTEGER))
    (multislot fichas (type INTEGER) (cardinality 26 26))
    (multislot comidas (type INTEGER) (cardinality 2 2)))

%Functions
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
    (bind ?d1 (random 1 6))
    (printout t ?d1 crlf)

    (seed (round (time))) 
    (bind ?d2 (random 1 6))
    (printout t ?d2 crlf)
    (return (create$ ?d1 ?d2))
)

%Imprimir en ascii art el tablero
(deffunction imprimir(?fichas)
  (printout t "  13   14   15      16   17    18           19   20    21    22    23    24          " crlf)
  (printout t "+___+ +___+ +___+ +___+ +___+ +___+ +++++ +___+ +___+ +___+ +___+ +___+ +___+ | +___+" crlf)
  (printout t "|   | |   | |   | |   | |   | |   | ||||| |   | |   | |   | |   | |   | |   | | |   |" crlf)
  (printout t "| " (nth$ 14 ?fichas) "  | | " (nth$ 15 ?fichas) "  | | " (nth$ 16 ?fichas) " | | " (nth$ 17 ?fichas) " | | " (nth$ 18 ?fichas) " | | " (nth$ 19 ?fichas) " | ||3|| | " (nth$ 20 ?fichas) " | | " (nth$ 21 ?fichas) " | | " (nth$ 22 ?fichas) " | | " (nth$ 23 ?fichas)" | | " (nth$ 24 ?fichas) " | | " (nth$ 25 ?fichas) " | | | " (nth$ 26 ?fichas) " |" crlf)
  (printout t "|   | |   | |   | |   | |   | |   | ||||| |   | |   | |   | |   | |   | |   | | |   |" crlf)
  (printout t "+___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ | +___+" crlf)
  (printout t "                                                                              |      " crlf)
  (printout t "----------------------------------------------------------------------------- |      " crlf)
  (printout t "                                                                              |      " crlf)
  (printout t "+___+ +___+ +___+ +___+ +___+ +___+ +++++ +___+ +___+ +___+ +___+ +___+ +___+ | +___+" crlf)
  (printout t "|   | |   | |   | |   | |   | |   | ||||| |   | |   | |   | |   | |   | |   | | |   |" crlf)
  (printout t "| (nth$ 13 ?fichas) | | (nth$ 12 ?fichas) | | (nth$ 11 ?fichas) | | (nth$ 10 ?fichas) | | (nth$ 9 ?fichas) | | (nth$ 8 ?fichas) | ||3|| | (nth$ 7 ?fichas) | | (nth$ 6 ?fichas) | | (nth$ 5 ?fichas) | | (nth$ 4 ?fichas) | | (nth$ 3 ?fichas) | | (nth$ 2 ?fichas) | | | (nth$ 1 ?fichas) |" crlf)
  (printout t "|   | |   | |   | |   | |   | |   | ||||| |   | |   | |   | |   | |   | |   | | |   |" crlf)
  (printout t "+___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ +___+ | +___+" crlf)
  (printout t "  12   11    10     9     8     7           6     5     4     3     2     1          " crlf)

)

%Rules
(defrule inicio
	(declare (salience 50))
    ?i<-(initial-fact)
=>
	(retract ?i)

  (bind ?tipo1 (getTipo 1))
    
  (bind ?color1 (getColor))

  (assert (jugador (id 1) (tipo ?tipo1) (color ?color1)))

  (bind ?tipo2 (getTipo 2))
  (bind ?color2 (* ?color1 -1))
    
  (assert (jugador (id 1) (tipo ?tipo2) (color ?color2)))
    
    (assert (estado (id 0) (padre -1) (fichas (create$ 0 2 0 0 0 0 -5 0 -3 0 0 0 5 -5 0 0 0 3 0 5 0 0 0 0 -2 0)) (comidas (create$ 0 0)))))

(defrule jugar
    (declare (salience 25))
    ?e<-(estado (id ?id) (padre ?padre) (fichas $?fichas) (comidas $?comidas))
=>
    (retract ?e)
    (tirarDados)
)



