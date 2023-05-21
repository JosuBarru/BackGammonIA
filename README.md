# BackGammonIA
Juego de BackGammon programado en CLIPS para jugar en modo manual (1v1), contra una IA o enfrentar dos IAs
## Requerimientos:
* Instalar CLIPS en tu ordenador.
* Es bastante recomendable usar Windows, respecto a otros sistemas operativos

## Uso:
Al ejecutar el programa se preguntará por el tipo del jugador 1. A continuación, se preguntará el color a asignar a este primer jugador. Por úlitmo, se preguntará el tipo del segundo jugador.

Por cada ronda que pasa ambos jugadores pueden decidir si abandonan la partida.

El resultado de los dados deberá ser insertado manualmente.

Según los dados obtenidos el programa devolverá una serie de movimientos posibles, para los que el usuario de modo manual deberá escoger uno, hasta agotar los dados.

## Desarrollo:

Para el desarrollo del programa hemos desarrollado una serie de reglas, que se ejecutan a medida que vamos necesitando.
La priemera regla es inicio, que se ejecuta en cuanto se ejecuta el programa con el initial-fact y nos pide para cada jugador si va a ser persona o cpu, además del color de las fichas de cada uno. Una vez recopilada esta informacion crea el primer estado.

Tenemos otra rule que se activa justo a continuacion que lo que hace es pedirnos los resultados de los dados. Además, si son dobles, saltará otra rule que marcará como que tenemos ahora cuatro movimientos.

Por otro lado tenemos nocomidas1 y nocomidas2, para las fichas blancas y las negras respectivamente.El motivo por el que hemos hecho dos funciones en vez de una única unificada es para intentar optimizar al máximo el tiempo que tarda el programa en calcular los movimientos. Concretamente, estas son las normas que se activarán en el momento en el que tengamos que realizar los movimientos. Mediante varias funciones conseguimos obtener todos los movimientos posibles para el estado actual.

Además, tenemos las reglas comidas1 y comidas2, tambien para blancas y negras, que se activarán siempre que hayan comido una ficha de nuestro color, viendonos obligados a sacarla antes de mover cualquir otra.

Una vez calculados los movimientos tenemos dos opciones:
Si no hay movimientos posibles, se activa la regla borrar los dados, que como su nombre indica borra los dados para dar paso al siguiente turno.
Si sí que se pueden realizar movimientos se activa eleccion. Esta regla nos deja elegir entre todos los movimientos posibles y ejecuta el que le digamos. Si solo hay un movimiento posible se ejecutará automáticamente. Esta regla se activará para todas las tiradas que nos correspondan en nuestro turno.

Además, tenemos dos reglas, victoriaBlancas y victoriaNegras, que se ejecutan cuando uno de los dos haya ganado la partida y termina el programa con un halt.

Para desarrollar la IA, hemos utilizado dos funciones: evaluarBlancas y evaluarNegras. Estas dos funciones dado el color del jugador nos darán una puntuacion a un estado de fichas.
En el juego lo que tenemos son dos reglas, eleccionCPUBlancas y eleccionCPUNegras, que dado un estado y un dado, sacamos todos los movimientos posibles que puede hacer el jugador y los transformamos a estados. Estos son evaluados mediante las funciones antes mencionadas y se elige el mejor movimiento posible. La eleccion de dos reglas es por el mismo motivo de antes.
