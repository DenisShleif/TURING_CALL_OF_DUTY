# TURING_CALL_OF_DUTY

BRIEF DESCRIPTION: 
CALL OF DUTY SNIPING is loosly based on call of duty. The game allows the user to play as a sniper shooting enemy units in a bunker

FUNCTIONALITY DESCRIPTION:
 - Contains multiple menues and sub menues including:
   - New Game
   - Instructions
   - Cheats
   - LeaderBoard
     - Statitstics are stored in a .dat file
     - User can sort statistics by rank, name or difficulty level
   - Pause Menu
 - Contains 3 different difficulty levels
 - Allows user to move crosshairs
   - Movement occurs at 3 different speeds controllable by user
   - Movement occurs in 8 different directions
   - Illusion of crosshair movement is created by moving the background
 - Allows user to shoot bullets
   - Bullet sound is made on top of background music
   - Time delay between shooting bullets
   - After 5 shots the user automatically reloads
   - Longer time delay for reloading which includes reloding sound
   - Bullet holes are left in background
     - Size of bullet hole changes depending on location on the background
   - Recoil and wind effects simulated
     - Random devitations from the center of the crosshairs simulate recoil and wind
     - Greater possible diviation in the vertical direction to simulate recoil
     - Recoil decreases at slower speeds of movement
 - Enemy "AI"
   - Multiple enemy AI's are present in the bunker at one time
   - Enemy moves side to side in the bunker at a certain speed and at a certain heing
   - If bullet hits within a certain range of the enemy, the enemy will begin to fire back
     - The enemy will have a random chance of hitting you, at a random health damage
     - When hit, the vision of the user will blur momentarily (length of time proportional to damage done)
     - Heartbeat sound played will demonstrate that user got shot
   - Enemy will experience different levels of damage depending on if they were shot in the arm, chest or head
     - Slight random deviations in damage also occur
 - Background Music
   - One song for menues
   - One song before any enemies have spotted the shooter
   - One song after the enemy has spotted the shooter
 - Allows user to open a chat menu where cheat codes can be entered proving certain adavantages

SKILLS USED:
 - File I/O for storing Statistics
 - Graphical user interface design
 - Animation design
 - Game creation

