BREAKVIC
===========
BREAKVIC is a videogame written in Commodore VIC-20 BASIC. BREAKVIC was written for a competition using only 20 lines of code.

The project goal is to insert in only 20 lines full gameplay, sounds, and graphics.
For the graphics, only PETSCII characters are used. The gameplay consists of breaking all the blocks on the screen. The game ends with a final score when the player destroys all the blocks.
The score is computed as:
* 300 points at the begin of the game
* -100 points when the ball hits the lower border of the screen outside the player paddle
* +100 points when the ball breaks a block or hits the player paddle

The player can control the paddle by using the joystick.

Notes
--------
* In order to compress the code, the keywords **print** and **poke** are replaced by their basic abbreviations (**?** and **pO**)
* The code is written through the "CBM .prg Studio". The code contains some particular control sequences, for example {clear}, {white}, ...
When you load the prg file on both the emulator or the real hardware, you can list the program and see the original control characters used by the VIC-20.

Notes for the competition
----------------------------
* The file breakvic_joy.bas is the source file for the competition. The breakvic.prg and breakvic_joy.bas are generated by this source file.

Issues
---------
* The color of the ball changes when the ball is on a screen location previously occupied by a block
* The x,y coordinates of the ball are always incremented/decremented by 1, only when the ball hits the player paddle the x coordinate is incremented/decremented by 2

Comments to the code
-----------------------
Line 10 initializes the sound volume (poke 36878,15) and the screen color (poke 36879,12), then it clears the screen and sets the character color to white. Some variables are initialized:
* **x, y**: the ball coordinates
* **dx,dy**: the values used to increment/decrement x and y
* **bx**: the x coordinate of the player paddle
* **c**: the position in the screen memory where the first block is inserted
* **p**: as c but it points to the color memory
* **v**: the ball velocity

> 10 pO36878,15:pO36879,12:?"{clear}{white}":x=10:y=21:dx=-1:dy=-1:bx=10:c=7727:p=38447:v=1

Line 20 initializes some variables: **t** (the player score) and **m** (the number of blocks). The other instructions on the line draw the blocks on the screen: 15 blocks for each line plus an empty line. In the cycle, both the screen memory (poke c+i,102) and the color memory (poke p+i,3) are written.

> 20 t=300:m=75:fori=1to15:pOc+i,102:pOp+i,3:nexti:c=c+44:p=p+44:ifc<7944goto20

Line 30 draws the player paddle (character 160) on the last row of the screen, the length of the paddle is two characters. Moreover, the space (code 32) is written on the ball coordinates (poke7680+y\*22+x,32) for deleting the previous ball on the screen.

> 30 poke8164+bx,160:poke8164+bx+1,160:poke7680+y\*22+x,32

Line 40 and 50 report standard basic code for reading the joystick. If **left** is detected and **bx>0** then the paddle is moved on the left by **goto** line 110. Line 50 detects the **right** and if **bx<20** it moves the paddle on the right by **goto** line 120

> 40 j=peek(37151):if(jand16)=0andbx>0thengoto110

> 50 poke37154,127:j=peek(37152):poke37154,255:if(jand128)=0andbx<20thengoto120

Line 60 stops the first voice of the VIC and increases the x,y coordinates. The x coordinate is multiplied by the velocity. The instruction **if** checks if the ball hits the left/right screen border or the ball hits a block (peek(7680+y\*22+x)=102).

> 60 poke36874,0:x=x+dx\*v:y=y+dy:ifx<=0orx>=21orpeek(7680+y\*22+x)=102thendx=-dx

Line 80 stops the second voice of the VIC and checks the y coordinate for screen border and blocks detection.

> poke36875,0:ify=0ory=21orpeek(7680+y\*22+x)=102thendy=-dy

Line 90 and 91 check the x coordinate. This control is necessary because when the x coordinate is incremented/decremented with a velocity greater than 1, the coordinate can overcome the left/right screen border.

> 90 ifx<0thenx=0

>91 ifx>21thenx=21

Line 92 checks if the ball hits the player paddle. If the ball hits the paddle **gosub** to line 140.

>92 ify=21andx>bx-2andx<bx+3thengosub140

Line 93 checks if the ball hits a block. If the ball hits a block **gosub** to line 130.

>93 ifpeek(7680+y\*22+x)=102thengosub130

If the ball hits the lower border of the screen but not the player paddle then it decreases the score.

> 94 ify=21andnot(peek(7680+(y+1)\*22+x))=160thent=t-100

If the number of blocks is equal to 0 **goto** to line 150 (the end of the game).

> 97 ifm=0thengosub150

Line 100 draws the ball and **goto** to the start of the game cycle (line 30).

> 100 poke7680+y\*22+x,81:goto30

Lines 110 and 120 are executed when the player uses the joystick (see lines 40 and 50) for moving the player paddle.

> 110 poke8164+bx,32:poke8164+bx+1,32:bx=bx-1:goto60

> 120 poke8164+bx,32:poke8164+bx+1,32:bx=bx+1:goto60

Line 130 is executed when the ball hits a block (see line 92). The line plays the voice 1 of the VIC, modifies the ball velocity, increments the score and decrements the number of blocks.

> 130 poke36874,135:v=1:t=t+100:m=m-1:return

Line 140 is executed when the ball hits the player paddle (see line 93). The line plays the voice 2 of the VIC and modifies the ball velocity.

> 140 poke36875,135:v=2:return

This line is executed when the game ends (see line 97). The line sets the volume to 0 and prints the player final score.

> 150 poke36878,0:?"{clear}{white}{down\*9}{right\*5}game over{down\*2}{left\*9}score: ";t:end
