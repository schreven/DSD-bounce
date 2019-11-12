# DSD-bounce-game

This repository presents the bounce game. It is single-player game, mixing the [pong](https://en.wikipedia.org/wiki/Pong) and [breakout](https://en.wikipedia.org/wiki/Breakout_(video_game) games. The game consists in moving platforms to stop balls from falling down, as long as possible.

## Setup
This game was developed and tested on the Xilinx ML-509 board; XUPV5-LX11T Evaluation Platform. The Xilinx Platform Studio and Embedded Development Kit (EDK) were used. The screen is to be connected through VGA and the keyboard is to be connected through ps2.

All the files relevant to the development are available in the repository. The user may also decide to just play the game on his board using the binary file.


## Important files
The main VHDL files; related to hardware, can be found in [pcores](https://github.com/schreven/DSD-bounce-game/tree/master/pcores).

The main C files; related to the logic of the game, can be found in [SDK](https://github.com/schreven/DSD-bounce-game/tree/master/SDK/SDK_Workspace_35/bounce_0/src).

The binary file to directly upload the game to a board is in [binary](https://github.com/schreven/DSD-bounce-game/tree/master/binary).


![in-game-image](/images/in-game.png)

## Gameplay
In this game the player has to keep a certain amount of balls (1 to 4) in the game to continue playing. These blue (squared) balls react to gravity and have different weights. They will bounce against anything (even one another). The game starts with 4 balls. A new one spawns every 10 seconds, with a maximum of 4 in the game at any time.

To keep the balls from falling, the player can move the main-platform in all directions, in the lower part of the screen. A sub-platform can be dropped at the current location of the main platform. There can be only one sub-platform at any time. Each time a ball bounces on the main platform, the user gains points. Hitting a ball with the side of the platform will give it speed in that direction. Additionally, two large brown blocks will go down, at slow and constant speed. The blocks obstruct the game and cause a loss if they attain the bottom of the screen. To reset a block, the player must catch a green cube that falls from it.

The buzzer and the leds on the board will highlight certain events / states. The score is displayed by the green bars on the left and right sides. The highest score is also saved in darker green.

### Controls
AltGr: start the game

Up-Down-Left-Right keyboard keys: move the main plate

Ctrl: drop the sub-platform at the location of the main-platform

Left-Right-Down-Up board keys: change minimum number of balls to keep playing to 1-2-3-4 respectively. This must be done at the start screen.
