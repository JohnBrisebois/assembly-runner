# assembly-runner
Program Overview: A game where the player runs to the right (with the camera locked to
them) and has to avoid obstacles in their path, by either dodging or jumping. It gets more
difficult as they play.

Files and Functions:

* main: This file runs the menu, then logic functions from their files.

* printScreen: this file contains all the functions that modify pixels on the display. It does this by first writing colors in a long series in the stack, then copying them over to the display. By doing this we avoid flickering. 

  * fillBack and fillGround fill the background with green and blue

  * Next, we get the locations of all objects (cloud, player, spikes) and “draw” them onto the stack using drawCloud, drawGuy, and a few other functions. drawGuy also checks which frame he is on, as well as the action state, and draws a frame accordingly.

  * Finally, drawPixels loops through the stack and copies the colors onto the display. We must be sure to draw them left to right to prevent screen tearing.

* menu: this file contains everything relating to the menu.

  * printMenu draws the text on the screen

  * menuLoop checks for player input, and starts the game or exits.

* logic: this file loops through the frames at a constant rate, while calculating where everything is, and what states they are in.

  * generate runs at the start of each game, it sets all the necessary variables in the stack, like player position, frame number, and spike size. It then runs refresh.

  * refresh loops continuously, checks for keyboard inputs, and runs the functions down below as well as printScreen

  * refreshDelay runs through a long loop so we can adjust frame rate.

  * genObstacle and updateObstacle generate obstacles based on a random number and then calculate their new position every frame. The chance of generation increases every 150 frames.

  * checkCollision checks if the player has struck an obstacle, and returns to the menu if they have.

  * jumpStart and dodgeStart run when the player inputs S or space. They set the player state on the stack to 1 or 2 for a number of frames and this helps the game keep track.
