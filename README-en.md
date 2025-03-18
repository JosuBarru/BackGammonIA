[![en](https://img.shields.io/badge/lang-en-red.svg)](https://github.com/JosuBarru/BackGammonIA/blob/main/README-en.md)
[![es](https://img.shields.io/badge/lang-es-yellow.svg)](https://github.com/JosuBarru/BackGammonIA/blob/main/README.md)

# BackGammonIA  
Backgammon game programmed in CLIPS to play in manual mode (1v1), against an AI, or to have two AIs compete against each other.  

## Requirements:  
* Install CLIPS on your computer.  
* It is highly recommended to use Windows over other operating systems :(.  

## Usage:  
When running the program, it will first ask for the type of player 1. Next, it will ask for the color assigned to this first player. Finally, it will ask for the type of the second player.  

Each round, both players can decide whether to quit the game.  

The dice roll results must be entered manually.  

Based on the obtained dice rolls, the program will return a set of possible moves. A manual mode user must choose one move at a time until the dice are fully used.  

## Development:  
To develop the program, we created a series of rules that execute as needed.  
The first rule is `inicio`, which runs as soon as the program starts with `initial-fact`. It asks for each player’s type (human or CPU) and the color of their pieces. Once this information is collected, it creates the initial game state.  

Another rule runs immediately after, which prompts for the dice roll results. If the roll is a double, another rule triggers, granting four moves instead of two.  

Additionally, we have `nocomidas1` and `nocomidas2` for white and black pieces, respectively. The reason for having two separate functions instead of one unified function is to optimize the program’s computation time. These rules activate when a player needs to make their moves. Through various functions, we obtain all possible moves for the current state.  

We also have `comidas1` and `comidas2`, for white and black pieces respectively, which activate when a piece of our color has been hit. In this case, we are forced to move it out before making any other move.  

Once all possible moves have been calculated, we have two options:  
- If no moves are possible, the rule `borrar los dados` is activated, which, as the name suggests, clears the dice to proceed to the next turn.  
- If moves are possible, the `eleccion` rule is activated. This rule allows the player to choose from all available moves and executes the selected one. If there is only one possible move, it will be executed automatically. This rule is activated for all dice rolls that the player is entitled to during their turn.  

Additionally, we have two rules, `victoriaBlancas` and `victoriaNegras`, which execute when one of the players wins the game, terminating the program with a `halt`.  

To develop the AI, we used two functions: `evaluarBlancas` and `evaluarNegras`. Given the player's color, these functions assign a score to a board state.  
In the game, we have two rules, `eleccionCPUBlancas` and `eleccionCPUNegras`, which, given a state and a dice roll, generate all possible moves for the player and transform them into new states. These states are evaluated using the previously mentioned functions, and the best possible move is chosen. The reason for having two separate rules is the same as before—to optimize performance.  
