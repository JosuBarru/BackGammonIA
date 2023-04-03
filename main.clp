(deftemplate jugador
    (slot id (type INTEGER))
	(slot tipo (type SYMBOL))
    (slot color (type SYMBOL)))

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

    (return ?c)))


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
    
    (assert (jugador (id 1) (tipo ?tipo2) (color ?color2))))