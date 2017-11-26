## Map file structure
The map file is located under data/map.txt, and is a plain text file holding the information of the map and the entity's initial locations.

First line: The number of columns and rows of cells of the map. Make sure to also change the width and height of the window (see line 5 of pacman.pde)

Second line: Each of the two numbers set the following: 

- X and Y value of the player's starting point
- X and Y value of the red ghost's starting point
- X and Y value of the pink ghost's starting point
- X and Y value of the blue ghost's starting point
- X and Y value of the orange ghost's starting point
- X and Y value of the cell right outside the house. This value is used to guide the ghosts outside the house.

The following lines set what each cell is. The numbers mean the following:

- 0: Void (where the player and the ghosts cannot reach)
- 1: Wall
- 2: Entrance to house
- 3: Road (where the dots are created)
- 4: Power pellets
- 5: Inside the house