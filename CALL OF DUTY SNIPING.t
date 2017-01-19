/*
 -------------------------------------------------------------------------------
 Call Of Duty Sniping
 by: Denis Shleifman
 (Summative)
 -------------------------------------------------------------------------------
 */

/*
 -------------------------------------------------------------------------------
 Declarations
 -------------------------------------------------------------------------------
 */

/*
 ------------------------
 Variables
 ------------------------
 */

%Windows
var game : int := Window.Open ("graphics:400,400,offscreenonly,nocursor,invisible")
var menu : int := Window.Open ("graphics:1024,768,offscreenonly,nobuttonbar")

%mouse and keyboard variables
var button, mouseX, mouseY : int %mouse variables
var done : boolean := false %done clicking the keyboard
var buttondone : boolean := false %done pressing on the mouse
var chars : array char of boolean %keyboardinput varible

%Counters
var shootingCounter : int %time until the next shot may be fired
var shootingCountMin : int %original value the Counter is set to
var loseHPCounter : int %time until the the loseHP animation will stop
var loseHPCountMin : int %original value the Counter is set to

%Sorting Variables
var sortName : boolean := false %sorted by name largest to smallest
var sortScore : boolean := false %sorted by score largest to smallest
var sortRank : boolean := false %sorted by rank largest to smallest
var sortPlace : boolean := true %sorted by place smallest to largest
var stringSTR : string %temporary storage for string

%Scores Variables
var fileName : int %fileNumberVatrable

var leaderBoardNameExternal : array 1 .. 10 of string %the output Name String
var leaderBoardNameInternal : array 1 .. 10 of string %the internal Name String
var myName : string %the players name
var leaderBoardScoreExternal : array 1 .. 10 of int %the output score integer
var leaderBoardScoreInternal : array 1 .. 10 of int %the internal score integer
var myScore : int := 0 %the players score
var leaderBoardPlaceExternal : array 1 .. 10 of int %the output place integer
var leaderBoardPlaceInternal : array 1 .. 10 of int %the internal place integer
var myPlace : int %the players place
var leaderBoardDifficultyExternal : array 1 .. 10 of int %the output difficulty integer
var leaderBoardDifficultyInternal : array 1 .. 10 of int %the internal difficulty integer
var myDifficulty : int %the players difficulty

%credit variables
var skipmode : boolean := false %variable that determines if the credits are skipped
var yCredits : int := -24 %the y coordinates of the credits

%game Variables
var backgroundX : int %the Xcoordinate of the background picture
var backgroundY : int %the Ycoordinate of the background picture
var radius : int %radius of the scope
var speed : int %your speed
var HP : int %your health
var song : int %Which game song is being played
var endGame : boolean %indicated that the game is over

%chat variables
var chat : string %the chat that the user enter
var outputchat : array 1 .. 5 of string %the chat strings that are drawn onto the screen

%shooting variables
var hit : boolean %did the bullet hit a soldier
var bulletsShot : int %the ammount of bullets shot
var clip : int %how many bullets you have left in your clip
var bulletShiftX : int %the shift due to the recoil of the sniper on the X axis
var bulletShiftY : int %the shift due to the recoil of the sniper on the X axis
var maxBullets : int %the bullets you have with yourself
var reloading : boolean := false %is the gun currently reloading

%misc vars
var triangleX : array 1 .. 3 of int %the Xcoordinates of each triangle for the leaderboard
var triangleY : array 1 .. 3 of int %the Ycoordinates of each triangle for the leaderboard

%text input vars
var character : string (1) %the character that is entered
var insert : boolean := false %is the typing in insert mode
var position : int %the character position of the cursor
var positionX : int         %the X position of the cursor
var tmpStr : string         %temporary string storage
var height, ascent, descent, internalLeading : int %defining characteristics of a font
var inputCount : int := 0 %counter that determines the cursor blinking

%fonts
var font : int := Font.New ("Times:48")
var font2 : int := Font.New ("Times:24")
var font3 : int := Font.New ("mono:12")
var font4 : int := Font.New ("Times:72")

%cheats
var IamGod : boolean := false %is the i am god cheat enables or desables
var MachineGun : boolean := false %is the machine gun cheat enables or desables
var HeadShot : boolean := false %is the headShot cheat enables or desables
var SteadyAim : boolean := false %is the steadyt aim cheat enables or desables

/*
 ------------------------
 Constants
 ------------------------
 */

const backgroundWidth := 1024 %the width of the background picture
const backgroundLength := 768 %the length of the background picture
const widthDashes := 15 %space between each tick
const lengthDash := 5 %distance between the center to the extremity of each dash
const widthDashedArea := 45 %The width of the part of the crosshairs that has ticks
const radiusOval := 150 %radius of the visible area of the crosshairs
const widthLine := 2 %width of the thick line
const bunkerY := 477 %the y coordinate of the start of the bunker
const targetHeight := 74 %the total height of the target image before a modifications
const targetWidth := 77 %the width of the target image
const bulletWidth := 20 %the width of the bullet image
const bulletHeight := 21 %the height of the bullet image
const targetYExtra := 14 %The extended height of the target through modification

/*
 ------------------------
 records
 ------------------------
 */

%ammount of targets
var targetNum : int := 0
type enemy :
    record
	X : int %x coordinates
	Y : int %y coordinates
	Health : int %his health
	Direction : int %his direction of travel (true = right, false = left)
	Speed : int %the speed at which he travels
	HealthBarY : int %the y coordinate of the targets health
	ShootingCounter : int %counter that stops the target from shooting
	ShootingAnimationCounter : int %counter that determines when to draw on a bulletfire image
	Clip : int %the ammount of bullets left in the targets clip
	bulletCounter : int %the ammount of bullets that he has shot
	Dead : boolean %is the target dead (true = dead, false = alive)
	Disturbed : boolean %is the target returning fire (true = yes, false = no)
    end record
var target : flexible array 1 .. 0 of enemy


%ammount of bullets that are drawn
var bulletCounter : int
type ammo :
    record
	X : int %x coordinate of the bullets
	Y : int %y coordinate of the bullets
	Size : int %the size of the bullets (1 = small, 2 = big)
    end record
var bullet : flexible array 1 .. 0 of ammo

/*
 -------------------------------------------------------------------------------
 Program
 Procedures
 and
 Funtions
 -------------------------------------------------------------------------------
 */

/*
 -------------------------------------------------------------------------------
 functions
 -------------------------------------------------------------------------------
 */

fcn ptinrect (h, v, x1, v1, x2, v2 : int) : boolean
    result (h > x1) and (h < x2) and (v > v1) and (v < v2)
end ptinrect


%cheacks to see if all targets are disturbed (1 = everyone is not, 2 = some are some are not, 3 = everyone is)
fcn allTargetsDistrubed : int
    % cheks if no one is disturbed
    for i : 1 .. targetNum
	if target (i).Disturbed then
	    exit
	end if
	if i = targetNum then
	    result 1
	end if
    end for
    %checks if everyone is disturbed
    for i : 1 .. targetNum
	if target (i).Disturbed = false then
	    exit
	end if
	if i = targetNum then
	    result 3
	end if
    end for
    %since everyone is not either disturbed or not disturbed, some must be disturbed, and some are not
    result 2
end allTargetsDistrubed

/*
 -------------------------------------------------------------------------------
 procedures
 -------------------------------------------------------------------------------
 */

%This procedure opens a inputable text field
%str is the variable that the final string will be saved to
%x1,y are the coordinates of the bottom left corner of the box
%x2 is the x coordinate ofthe top right corner of the box
%fnt is the font that all the text will be drawn as
%Clr is the Colour in which the text will be drawn
proc inputText (var str : string, x1, y, x2, fnt, Clr : int)
    Font.Sizes (fnt, height, ascent, descent, internalLeading) %calculates the sizes of the font
    %resets
    str := ""
    insert := false
    position := 0
    loop
	inputCount += 1 %increases the counter
	if inputCount > 1500 then %resets the counter
	    inputCount := 0
	end if
	%resets the insert function
	if position = length (str) then     %if you are at the end of the string
	    insert := false
	end if
	%re calculates the position
	positionX := 0
	for i : 1 .. position     %this calculates where to draw the cursor
	    positionX += Font.Width (str (i), fnt)
	end for

	mousewhere (mouseX, mouseY, button)
	Draw.FillBox (x1 - 3, y - 3, x2 + 3, y + height + 3, red)     %draw the rim
	Draw.FillBox (x1 - 1, y - 1, x2 + 1, y + height + 1, white)     %draws the white text wpace
	Font.Draw (str, x1, y + descent, fnt, Clr)     %draws the string
	if inputCount < 1000 then
	    if insert then
		Draw.FillBox (x1 + positionX, y, x1 + positionX + Font.Width (str (position + 1), fnt), y + height, black)     %draws the insert-mode cursor
	    else
		Draw.ThickLine (x1 + positionX, y, x1 + positionX, y + height, 2, black)     %draw the normal-mode cursor
	    end if
	end if
	/* This feature is non needed in this game
	 if ptinrect (mouseX, mouseY, x1, y, x2, y + height) then
	 Draw.FillBox (mouseX - 1, mouseY - 15, mouseX, mouseY + 15, black)
	 Draw.FillBox (mouseX - 5, mouseY - 16, mouseX - 1, mouseY - 15, black)
	 Draw.FillBox (mouseX + 1, mouseY - 16, mouseX + 5, mouseY - 15, black)
	 Draw.FillBox (mouseX - 5, mouseY + 16, mouseX - 1, mouseY + 17, black)
	 Draw.FillBox (mouseX + 1, mouseY + 16, mouseX + 5, mouseY + 17, black)
	 end if
	 */
	View.Update
	%if you click
	if button = 1 then
	    inputCount := 0
	    %inside the box
	    if ptinrect (mouseX, mouseY, x1, y, x2, y + height) then     %if mouse inside text box
		tmpStr := ""
		%finds the position of the mouse
		for i : 1 .. length (str)
		    tmpStr += str (i)
		    if x1 + Font.Width (tmpStr, fnt) > mouseX then
			%if the mouse is closer to the space befor then
			if mouseX - Font.Width (tmpStr (1 .. * -1), fnt) - x1 < Font.Width (tmpStr, fnt) - mouseX + x1 then
			    position := i - 1
			    exit
			else
			    position := i
			    exit
			end if
		    end if
		end for
		if x1 + Font.Width (str, fnt) < mouseX then
		    position := length (str)
		end if
	    else
		%exit
	    end if
	end if
	if hasch then     % if a key is being pressed
	    inputCount := 0
	    getch (character)
	    if character = chr (8) and position ~= 0 then     %if backspace is pressed
		tmpStr := ""
		for i : 1 .. length (str) - 1
		    if i < position then
			tmpStr += str (i)
		    elsif i > position - 1 then
			tmpStr += str (i + 1)
		    end if
		end for
		str := tmpStr
		if position ~= 0 then
		    position -= 1
		end if
	    elsif character = chr (211) and position ~= length (str) then     %if delete is pressed
		tmpStr := ""
		for i : 1 .. length (str) - 1
		    if i < position + 1 then
			tmpStr += str (i)
		    elsif i > position then
			tmpStr += str (i + 1)
		    end if
		end for
		str := tmpStr
	    elsif character = chr (10) then     %if enter key is pressed
		done := true
		exit
	    elsif ord (character) = 205 then     %if right arrow key is pressed
		if position ~= length (str) then
		    position += 1
		else
		    position := 0
		end if
	    elsif ord (character) = 203 then     %if left arrow key is pressed
		if position ~= 0 then
		    position -= 1
		else
		    position := length (str)
		end if
	    elsif ord (character) = 199 then     %if home button is pressed
		position := 0
	    elsif ord (character) = 207 then     %if end button is pressed
		position := length (str)
	    elsif ord (character) = 244 then     %if ctrl right arrow is pressed
		for i : position + 1 .. length (str)
		    if str (i) = " " then
			position := i
			exit
		    elsif str (i) ~= " " and i = length (str) then
			position := length (str)
		    end if
		end for
	    elsif ord (character) = 243 then                     %if ctrl left arrow is pressed
		for decreasing i : position - 1 .. 1
		    if str (i) = " " then
			position := i
			exit
		    elsif str (i) ~= " " and i = 1 then
			position := 0
		    end if
		end for
	    elsif ord (character) = 210 then
		if insert then     %if insert key is pressed
		    insert := false
		else
		    insert := true
		end if
	    elsif ord (character) ~= 8 and ord (character) ~= 208 and ord (character) ~= 200 and ord (character) ~= 27 and ord (character) ~= 133 and ord (character) ~= 134 then     %bad characters
		if ord (character) < 187 or ord (character) > 196 then     %more bad characters
		    if length (str) < 255 and Font.Width (str + character, fnt) < x2 - x1 then     %if letter/number key is pressed
			tmpStr := ""
			if insert then
			    for i : 0 .. length (str) - 1
				if i < position then
				    tmpStr += str (i + 1)
				elsif i = position then
				    tmpStr += character
				elsif i > position then
				    tmpStr += str (i + 1)
				end if
			    end for
			else
			    for i : 0 .. length (str)
				if i < position then
				    tmpStr += str (i + 1)
				elsif i = position then
				    tmpStr += character
				elsif i > position then
				    tmpStr += str (i)
				end if
			    end for
			end if
			str := tmpStr
			position += 1
		    end if
		end if
	    end if
	end if
	Time.DelaySinceLast (1)
    end loop
end inputText

/*
 ------------------------
 Visual Output
 ------------------------
 */

proc DrawCrosshairs
    %if you are currently in the injured animation
    if loseHPCounter < 0 and HP > 0 then
	for i : 1 .. maxx by 5 - abs (loseHPCounter) * 5 div (loseHPCountMin + 1)
	    for j : 1 .. maxy by 5 - abs (loseHPCounter) * 5 div (loseHPCountMin + 1)
		Draw.Dot (i, j, red)
	    end for
	end for
    elsif loseHPCounter = 0 then
	Music.PlayFileReturn ("SoundTrack/Sound Effects/Silence.mp3")
    end if

    Draw.Oval (maxx div 2, maxy div 2, radiusOval, radiusOval, black) %draws the crosshair circle
    Draw.Fill (50, 50, black, black) %fills in around this circle

    Draw.FillBox (0, maxy div 2 - widthLine, maxx div 2 - widthDashedArea, maxy div 2 + widthLine, black) %Draws a thick line to the dashed area horizontally from the left
    Draw.FillBox (maxx div 2 + widthDashedArea, maxy div 2 - widthLine, maxx, maxy div 2 + widthLine, black) %Draws a thick line to the dashed area horizontally from the right

    Draw.FillBox (maxx div 2 - widthLine, 0, maxx div 2 + widthLine, maxy div 2 - widthDashedArea, black) %Draws a thick line to the dashed area virtically from the botton
    Draw.FillBox (maxx div 2 - widthLine, maxy div widthLine + widthDashedArea, maxx div 2 + widthLine, maxy, black) %Draws a thick line to the dashed area virtically from the top

    Draw.Line (maxx div 2 - widthDashedArea, maxy div 2, maxx div 2 + widthDashedArea, maxy div 2, black) %draws a line horizontally across the dashed area
    Draw.Line (maxx div 2, maxy div 2 - widthDashedArea, maxx div 2, maxy div 2 + widthDashedArea, black) %draws a line virtically across the dashed area

    for i : 1 .. 5
	Draw.Line (maxx div 2 - widthDashedArea + widthDashes * i, maxy div 2 - lengthDash, maxx div 2 - widthDashedArea + widthDashes * i, maxy div 2 + lengthDash, black) %draws the horizontal ticks
	Draw.Line (maxx div 2 - lengthDash, maxy div 2 - widthDashedArea + widthDashes * i, maxx div 2 + lengthDash, maxy div 2 - widthDashedArea + widthDashes * i, black) %draws the virtical ticks
    end for

    for i : 0 .. 2
	Pic.ScreenLoad ("Images/Sprites/Game_RedHeart.bmp", i * 25, 0, 0) %draws the hearts
    end for
    Draw.FillBox (HP, 0, 75, 25, black)         %blacks out the hearts depending on your HP
    for i : 1 .. 6 - clip
	if i ~= 6 then
	    Pic.ScreenLoad ("Images/Sprites/Game_Bullet.bmp", maxx - 10 * i, 0, 0) %draws all of the bullets
	end if
    end for
    %keeps the blacked out bar from covering the screen
    if 50 - 50 * shootingCounter div shootingCountMin < 50 then
	if reloading then
	    Draw.FillBox (maxx - 10 * 5, 0, maxx, 50 - 50 * shootingCounter div shootingCountMin, black) %blacks out a bullet depending on the time you have waited between shots
	else
	    Draw.FillBox (maxx - 10 * (5 - clip), 0, maxx - 10 * (6 - clip), 50 - 50 * shootingCounter div shootingCountMin, black) 
		%blacks out a bullet depending on the time you have waited between shots
	end if
    else
	if reloading then
	    Draw.FillBox (maxx - 10 * 5, 0, maxx, 50, black) %blacks out a bullet depending on the time you have waited between shots
	else
	    Draw.FillBox (maxx - 10 * (5 - clip), 0, maxx - 10 * (6 - clip), 50, black) %blacks out a bullet depending on the time you have waited between shots
	end if
    end if

    Draw.FillOval (maxx div 2, maxy div 2, 3, 3, red) %draws a red dot in the center
    for i : 1 .. 5
	Font.Draw (outputchat (i), 0, maxy - 15 * i, font3, green) %draws the chat onto the screen
    end for

    Font.Draw ("Kills: " + intstr (myScore), 0, 30, font2, white) %draws your score onto the screen
    Font.Draw ("Menu", maxx - Font.Width ("Menu", font2) - 10, maxy - 24, font2, white) %Draws the menu button onto the screen
end DrawCrosshairs

%Draws everything onto the screen
proc Output
    Pic.ScreenLoad ("Images/BackGrounds/Game_BackGround_Top.bmp", backgroundX, backgroundY + bunkerY, 0) %Draws the top of the background
    for i : 1 .. bulletCounter
	if bullet (i).Size = 1 then
	    Pic.ScreenLoad ("Images/Sprites/Game_Small_BulletHole.bmp", backgroundX + bullet (i).X - 5, backgroundY + bullet (i).Y - 5, picMerge) %draws all of the small bullets
	end if
    end for
    for i : 1 .. targetNum
	%if the targets health is bellow its max health and his health is greater then zero, draw a healthbox
	if target (i).Health < targetWidth - 4 and target (i).Health > 0 then
	    Draw.Box (backgroundX + target (i).X, backgroundY + target (i).Y + targetHeight + target (i).HealthBarY, backgroundX + target (i).X + targetWidth, backgroundY + target (i).Y +
		targetHeight + target (i).HealthBarY + 10, white) %outer WhiteBox
	    Draw.Box (backgroundX + target (i).X + 1, backgroundY + target (i).Y + targetHeight + target (i).HealthBarY + 1, backgroundX + target (i).X + targetWidth - 1, backgroundY +
		target (i).Y + targetHeight + target (i).HealthBarY + 9, white) %outer WhiteBox
	    Draw.FillBox (backgroundX + target (i).X + 2, backgroundY + target (i).Y + targetHeight + target (i).HealthBarY + 2, backgroundX + target (i).X + target (i).Health + 2, backgroundY +
		target (i).Y + targetHeight + target (i).HealthBarY + 8, red) %health box
	end if
	%sraws the target
	Pic.ScreenLoad ("Images/Sprites/Game_Target.bmp", backgroundX + target (i).X, backgroundY + target (i).Y - targetYExtra, picMerge)
	%if he is shooting then draw a flash
	if target (i).ShootingCounter < target (i).ShootingAnimationCounter then
	    Pic.ScreenLoad ("Images/Sprites/Game_GunFire.bmp", backgroundX + target (i).X + 33, backgroundY + target (i).Y + 43, picMerge)
	end if
    end for
    %draw the bottom of the background
    Pic.ScreenLoad ("Images/BackGrounds/Game_BackGround_Bottom.bmp", backgroundX, backgroundY, 0)
    for i : 1 .. bulletCounter
	%draw the large bullets
	if bullet (i).Size = 2 then
	    Pic.ScreenLoad ("Images/Sprites/Game_Large_BulletHole.bmp", backgroundX + bullet (i).X - 10, backgroundY + bullet (i).Y - 10, picMerge)
	end if
    end for
    %draw the crosshairs ontop
    DrawCrosshairs
end Output

/*
 ------------------------
 Micsellaneous procedures
 ------------------------
 */

%reduces your health
proc loseHP (Health : int)
    %if the cheat I am God is not activated
    if IamGod = false then
	%decreases health
	HP -= Health
	if HP < 0 then
	    HP := 0
	end if
	%decreases counters
	loseHPCountMin := Health * 100 div 60
	shootingCounter := -Health * 100 div 60
	shootingCountMin := -Health * 100 div 60
	loseHPCounter := -Health * 100 div 60
	%plays music
	Music.PlayFileReturn ("SoundTrack/Sound Effects/Heartbeat.mp3")
    end if
end loseHP

%switches two strings
proc SwitchString (var str1, str2 : string)
    stringSTR := str1
    str1 := str2
    str2 := stringSTR
end SwitchString

%switches two integers
proc switchInts (var Intiger1, Intiger2 : int)
    Intiger1 := Intiger1 - Intiger2
    Intiger2 := Intiger1 + Intiger2
    Intiger1 := Intiger2 - Intiger1
end switchInts

%orders integers and keeps two other integer and one string array ordered with it
proc IntOrder (var ArrayOrder, SuplementArray1, SuplementArray2 : array 1 .. 10 of int, var SuplementArray3 : array 1 .. 10 of string, direction : boolean)
    for i : 1 .. 10
	for j : 1 .. 10
	    if direction and ArrayOrder (i) < ArrayOrder (j) or direction = false and ArrayOrder (i) > ArrayOrder (j) then
		switchInts (ArrayOrder (i), ArrayOrder (j))
		switchInts (SuplementArray1 (i), SuplementArray1 (j))
		switchInts (SuplementArray2 (i), SuplementArray2 (j))
		SwitchString (SuplementArray3 (i), SuplementArray3 (j))
	    end if
	end for
    end for
end IntOrder

%orders integers and keeps three other integers array ordered with it
proc StrOrder (var ArrayOrder : array 1 .. 10 of string, var SuplementArray1, SuplementArray2, SuplementArray3 : array 1 .. 10 of int, direction : boolean)
    for i : 1 .. 10
	for j : 1 .. 10
	    if direction and ArrayOrder (i) > ArrayOrder (j) or direction = false and ArrayOrder (i) < ArrayOrder (j) then
		SwitchString (ArrayOrder (i), ArrayOrder (j))
		switchInts (SuplementArray1 (i), SuplementArray1 (j))
		switchInts (SuplementArray2 (i), SuplementArray2 (j))
		switchInts (SuplementArray3 (i), SuplementArray3 (j))
	    end if
	end for
    end for
end StrOrder

%switches two characters in a string
proc StringLetterSwitcher (var str : string, character1, character2 : string)
    for j : 1 .. length (str)
	if str (j) = character1 then
	    str := str (1 .. j - 1) + character2 + str (j + 1 .. *)
	end if
    end for
end StringLetterSwitcher

%draws a triangle according to its x,y coordinates, the direction (true = up and false = down), it's width, and the color
proc DrawTriangle (x, y : int, direction : boolean, width, Colour : int)
    %determines X values
    for i : 1 .. 3
	triangleX (i) := x + (i - 1) * width div 2
    end for
    %Determines Y coordinates
    for i : 1 .. 3
	if direction = true then
	    if i = 2 then
		triangleY (i) := y + round (width * sqrt (3 / 4))
	    else
		triangleY (i) := y
	    end if
	else
	    if i = 2 then
		triangleY (i) := y
	    else
		triangleY (i) := y + round (width * sqrt (3 / 4))
	    end if
	end if
    end for
    %Draws the triangle
    Draw.FillPolygon (triangleX, triangleY, 3, Colour)
end DrawTriangle

%resets all of the characteristics of a target (num) to its default values
proc resetTargetProperties (num : int)
    randint (target (num).X, 200, 750)
    target (num).Y := bunkerY - targetHeight
    target (num).Health := targetWidth - 4
    randint (target (num).Direction, 0, 1)
    randint (target (num).Speed, 1, 10)
    randint (target (num).HealthBarY, 20, 50)
    target (num).ShootingCounter := 0
    target (num).ShootingAnimationCounter := 0
    target (num).Clip := 5
    target (num).bulletCounter := 0
    target (num).Dead := false
    target (num).Disturbed := false
end resetTargetProperties

%adds a new target
proc newTarget
    targetNum += 1
    new target, targetNum
    resetTargetProperties (targetNum)
end newTarget

%adds a new bullet and gives it default values
proc newBullet
    bulletCounter += 1
    if bulletCounter > 0 then
	new bullet, bulletCounter
	bullet (bulletCounter).X := 200 - backgroundX + bulletShiftX
	bullet (bulletCounter).Y := 200 - backgroundY + bulletShiftY
	if bullet (bulletCounter).Y < bunkerY or bullet (bulletCounter).Y > 570 then
	    bullet (bulletCounter).Size := 2
	else
	    bullet (bulletCounter).Size := 1
	end if
    end if
end newBullet

%determines when to switch songs
proc switchSongs
    if song = 1 and allTargetsDistrubed > 1 then
	song := 2
	Music.PlayFileLoop ("SoundTrack/Music/Game2Music.wav")
    elsif song = 2 and allTargetsDistrubed = 1 then
	song := 1
	Music.PlayFileLoop ("SoundTrack/Music/Game1Music.wav")
    end if
end switchSongs


%resets all if the variables of the game
proc resetGame
    IamGod := false
    MachineGun := false
    HeadShot := false
    SteadyAim := false

    endGame := false
    backgroundX := (maxx - backgroundWidth) div 2
    backgroundY := (maxy - backgroundLength) div 2
    speed := 10
    bulletCounter := -1
    newBullet
    shootingCounter := -1
    shootingCountMin := -1
    loseHPCounter := 0
    HP := 75
    clip := 0
    maxBullets := 100
    bulletsShot := 0
    myScore := 0
    myName := ""
    hit := false
    song := 2

    sortName := false
    sortScore := false
    sortRank := false
    sortPlace := true

    targetNum := 1
    new target, targetNum
    resetTargetProperties (targetNum)
    for i : 1 .. 5
	outputchat (i) := ""
    end for
end resetGame

%increases all of the counters
proc increaseCounters
    shootingCounter += 1
    loseHPCounter += 1
    for i : 1 .. targetNum
	target (i).ShootingCounter += 1
    end for
    if shootingCounter >= 0 and reloading then
	reloading := false
	clip := 0
    end if
end increaseCounters

/*
 ------------------------
 KeyBoard Procedures
 ------------------------
 */

% opens the chat bar
proc Cheats
    %gets a string
    inputText (chat, maxx div 2 - 100, maxy div 2 - 12, maxx div 2 + 100, font2, black)
    %Determines if the chat coincides with a cheat
    if index (Str.Lower (chat), "i am god") > 0 then
	IamGod := true
    elsif Str.Lower (chat) = "supply me" then
	maxBullets := 1000
    elsif Str.Lower (chat) = "machine gun" then
	MachineGun := true
    elsif Str.Lower (chat) = "headshot" then
	HeadShot := true
    elsif Str.Lower (chat) = "steady aim" then
	SteadyAim := true
    elsif Str.Lower (chat) = "kill me" then
	HP := 0
    elsif Str.Lower (chat) = "disable all" then
	SteadyAim := false
	HeadShot := false
	MachineGun := false
	maxBullets := 100
	IamGod := false
    elsif Str.Lower (chat) = "enable all" then
	SteadyAim := true
	HeadShot := true
	MachineGun := true
	maxBullets := 1000
	IamGod := true
	%else saves it into the chats
    else
	for decreasing i : 5 .. 2
	    outputchat (i) := outputchat (i - 1)
	end for
	outputchat (1) := chat
    end if
end Cheats

proc reload
    %if pressing on r
    if chars (chr (114)) then
	Music.PlayFileReturn ("SoundTrack/Sound Effects/Reload.MP3") %play the reloading sound
	reloading := true
	clip += 1
	%sets counters
	if MachineGun then
	    shootingCounter := -1
	    shootingCountMin := -1
	else
	    shootingCounter := -1761 div 60
	    shootingCountMin := -1761 div 60
	end if
    end if
end reload

%determines the keys that are being pressed
proc keyboardInput
    Input.KeyDown (chars)
    if chars (chr (10)) = false then
	done := false
    end if
    if chars (chr (181)) then %if pressing Ctrl
	speed := 1
    elsif chars (chr (180)) then %elsif pressing Shift
	speed := 15
    else
	speed := 7
    end if
    %if pressing on enter
    if chars (chr (10)) and done = false then
	Cheats
    end if
    reload
end keyboardInput

/*
 ------------------------
 Shooting Procedures
 ------------------------
 */

%Generatses a pseudo-random shift for the bullet caused by recoil
proc bulletShift
    if SteadyAim = false then
	if speed = 1 then
	    randint (bulletShiftX, -5, 5)
	    randint (bulletShiftY, 0, 15)
	elsif speed = 7 then
	    randint (bulletShiftX, -10, 10)
	    randint (bulletShiftY, 0, 30)
	elsif speed = 15 then
	    randint (bulletShiftX, -20, 20)
	    randint (bulletShiftY, 0, 60)
	end if
    else
	bulletShiftX := 0
	bulletShiftY := 0
    end if
    if MachineGun then
	bulletShiftX *= 3
	bulletShiftY *= 3
    end if
end bulletShift

%calculates the targets that the bullets hit
proc bulletHit
    for i : 1 .. targetNum
	if ptinrect (200 + bulletShiftX, 200 + bulletShiftY, backgroundX + target (i).X - targetWidth div 2, backgroundY + target (i).Y, backgroundX + target (i).X + targetWidth * 3 div 2,
		backgroundY + bunkerY + targetHeight + 25) then
	    target (i).Disturbed := true
	end if
    end for
    hit := false
    for decreasing i : targetNum .. 1
	if target (i).Dead = false then
	    %if torso is hit
	    if hit = false and ptinrect (200 - backgroundX + bulletShiftX, 200 - backgroundY + bulletShiftY, target (i).X + 28, target (i).Y, target (i).X + 71, target (i).Y + 42) then
		if HeadShot then
		    target (i).Health -= 75
		else
		    target (i).Health -= 25
		end if
		hit := true
		%elsif arm is hit
	    elsif hit = false and ptinrect (200 - backgroundX + bulletShiftX, 200 - backgroundY + bulletShiftY, target (i).X, target (i).Y + 28, target (i).X + 28, target (i).Y + 62) then
		if HeadShot then
		    target (i).Health -= 75
		else
		    target (i).Health -= 10
		end if
		hit := true
		%elsif head is hit
	    elsif hit = false and ptinrect (200 - backgroundX + bulletShiftX, 200 - backgroundY + bulletShiftY, target (i).X + 27, target (i).Y + 42, target (i).X + 53, target (i).Y +
		    targetHeight)
		    then
		target (i).Health -= 75
		hit := true
	    end if
	    % if the target dies reset his properties
	    if hit and target (i).Health <= 0 then
		target (i).Health := 0
		myScore += 1
		target (i).Dead := true
		if myDifficulty = 3 then
		    newTarget
		end if
	    end if
	end if
	exit when hit
    end for
    % gets a new bulletHole if neccessary
    if hit = false then
	newBullet
    end if
end bulletHit


%determines the type of sound
proc shootingSound
    if MachineGun = false then
	if clip = 5 then
	    Music.PlayFileReturn ("SoundTrack/Sound Effects/Shoot_and_Reload.MP3")
	    shootingCounter := -3161 div 60
	    shootingCountMin := -3161 div 60
	    reloading := true
	else
	    Music.PlayFileReturn ("SoundTrack/Sound Effects/Shoot.MP3")
	    shootingCounter := -1000 div 60
	    shootingCountMin := -1000 div 60
	end if
    end if
end shootingSound

%all the shooting procedures together
proc shoot
    %if you press inside of the window then
    if ptinrect (mouseX, mouseY, maxx - Font.Width ("Menu", font2) - 10, maxy - 24, maxx - 10, maxy) = false and button = 1 and bulletsShot <= maxBullets and ptinrect (mouseX, mouseY, 0, 0,
	    maxx, maxy) and shootingCounter > 0 then
	clip += 1
	bulletShift
	bulletHit
	shootingSound
	bulletsShot += 1
	if MachineGun then
	    shootingCounter := -1
	    shootingCountMin := -1
	end if
    end if
end shoot

/*
 ------------------------
 Pause Menu
 ------------------------
 */

proc PauseMenu
    if HP > 0 then
	Output
	Draw.FillBox ((maxx - Font.Width ("Resume Game", font2)) div 2 - 25, 75, (maxx + Font.Width ("Resume Game", font2)) div 2 + 25, maxy - 75, red)
	Draw.FillBox ((maxx - Font.Width ("Resume Game", font2)) div 2 - 22, 78, (maxx + Font.Width ("Resume Game", font2)) div 2 + 22, maxy - 78, black)
	Font.Draw ("Main Menu", (maxx - Font.Width ("Main Menu", font2)) div 2, maxy - 130, font2, white)
	Font.Draw ("Resume Game", (maxx - Font.Width ("Resume Game", font2)) div 2, maxy - 160, font2, white)
	Font.Draw ("Quit", (maxx - Font.Width ("Quit", font2)) div 2, 100, font2, white)
	View.Update
    end if
    loop
	mousewhere (mouseX, mouseY, button)
	if button = 1 then
	    buttondone := true
	else
	    buttondone := false
	end if
	if HP = 0 or button = 1 and ptinrect (mouseX, mouseY, (maxx - Font.Width ("Main Menu", font2)) div 2, maxy - 130, (maxx + Font.Width ("Main Menu", font2)) div 2, maxy - 106) then
	    if myScore > leaderBoardScoreInternal (10) then
		Output
		Font.Draw ("NEW HIGH SCORE!!!", (maxx - Font.Width ("NEW HIGH SCORE!!!", font2)) div 2, maxy div 2 + 100, font2, white)
		Font.Draw ("Please enter your Name", (maxx - Font.Width ("Please enter your Name", font2)) div 2, maxy div 2 + 50, font2, white)
		inputText (myName, maxx div 2 - 100, maxy div 2 - 12, maxx div 2 + 100, font2, black)
		leaderBoardScoreInternal (10) := myScore
		leaderBoardNameInternal (10) := myName
		IntOrder (leaderBoardScoreInternal, leaderBoardPlaceExternal, leaderBoardDifficultyInternal, leaderBoardNameInternal, false)
		for i : 1 .. 10
		    leaderBoardPlaceExternal (i) := i
		    leaderBoardScoreExternal (i) := leaderBoardScoreInternal (i)
		    leaderBoardNameExternal (i) := leaderBoardNameInternal (i)
		    StringLetterSwitcher (leaderBoardNameInternal (i), " ", "_")
		end for
		open : fileName, "DataFiles/HighScore.dat", put
		for i : 1 .. 10
		    put : fileName, leaderBoardNameInternal (i), " ", leaderBoardScoreInternal (i), " ", leaderBoardDifficultyInternal (i)
		end for
		close : fileName
	    end if
	    Music.PlayFileStop
	    endGame := true
	    exit
	elsif button = 1 and ptinrect (mouseX, mouseY, (maxx - Font.Width ("Resume Game", font2)) div 2, maxy - 160, (maxx + Font.Width ("Resume Game", font2)) div 2, maxy - 136) then
	    buttondone := true
	    exit
	elsif button = 1 and ptinrect (mouseX, mouseY, (maxx - Font.Width ("Quit", font2)) div 2, 100, (maxx + Font.Width ("Quit", font2)) div 2, 124) then
	    Window.Close (game)
	    Window.Close (menu)
	    quit
	end if
    end loop
end PauseMenu

/*
 ------------------------
 Mouse Procedures
 ------------------------
 */

proc mouseInput
    mousewhere (mouseX, mouseY, button)
    if ptinrect (mouseX, mouseY, maxx - Font.Width ("Menu", font2) - 10, maxy - 24, maxx - 10, maxy) and button = 1 or HP <= 0 then         %Go to Pause Menu
	PauseMenu
    elsif ptinrect (mouseX, mouseY, 0, 0, maxx, maxy) and not ptinrect (mouseX, mouseY, maxx div 2 - widthDashes, maxy div 2 - widthDashes, maxx div 2 + widthDashes, maxy div 2 + widthDashes)
	    then
	%scroll
	if mouseY < -mouseX + maxy div 2 and backgroundY < 50 - 15 and backgroundX < 50 - 15 then         %Scroll down left
	    backgroundX += speed
	    backgroundY += speed
	elsif mouseY > mouseX + maxy div 2 and backgroundY > -backgroundLength + 400 - 50 + 15 and backgroundX < 50 - 15 then         %Scroll up left
	    backgroundX += speed
	    backgroundY -= speed
	elsif mouseY > -mouseX + maxy * 1.5 and backgroundY > -backgroundLength + 400 - 50 + 15 and backgroundX > -backgroundWidth + 400 - 50 + 15 then         %Scroll up right
	    backgroundX -= speed
	    backgroundY -= speed
	elsif mouseY < mouseX - maxy div 2 and backgroundY < 50 - 15 and backgroundX > -backgroundWidth + 400 - 50 + 15 then         %Scroll down left
	    backgroundX -= speed
	    backgroundY += speed
	elsif mouseY < mouseX and mouseY < -mouseX + maxy and backgroundY < 50 - 15 then         %Scroll down
	    backgroundY += speed
	elsif mouseY > mouseX and mouseY < -mouseX + maxy and backgroundX < 50 - 15 then         %Scroll left
	    backgroundX += speed
	elsif mouseY > -mouseX + maxy and mouseY > mouseX and backgroundY > -backgroundLength + 400 - 50 + 15 then         %Scroll up
	    backgroundY -= speed
	elsif mouseY > -mouseX + maxy and mouseY < mouseX and backgroundX > -backgroundWidth + 400 - 50 + 15 then         %Scroll right
	    backgroundX -= speed
	end if
    end if
    if button = 0 then
	buttondone := false
    end if
    if buttondone = false then
	shoot
    end if
end mouseInput

/*
 ------------------------
 Target Procedures
 ------------------------
 */

proc respawn
    %detemines spawn amonuts by the difficulty
    if myDifficulty = 1 then
	%randomizes the spawning of a target
	if Rand.Int (0, 200) = 1 then
	    newTarget
	end if
	%if all of the targets are dead, spawn one
	for i : 1 .. targetNum
	    if target (i).Dead = false then
		exit
	    end if
	    if i = targetNum and target (i).Y <= bunkerY - targetHeight then
		targetNum := 1
		new target, targetNum
		resetTargetProperties (targetNum)
	    end if
	end for
    elsif myDifficulty = 2 then
	%if all of the targets are dead, raise the ammount of targets and respawn all of them
	for i : 1 .. targetNum
	    if target (i).Dead = false then
		exit
	    end if
	    if i = targetNum then
		for j : 1 .. targetNum
		    resetTargetProperties (j)
		end for
		newTarget
	    end if
	end for
    elsif myDifficulty = 3 then
	%if the target dies, respawn it
	for i : 1 .. targetNum
	    if target (i).Dead and target (i).Y <= bunkerY - targetHeight then
		resetTargetProperties (i)
	    end if
	end for
    end if
end respawn

proc moveTargets
    for i : 1 .. targetNum
	%determines the targets directin
	if target (i).X < 200 then
	    target (i).Direction := 1
	elsif target (i).X > 750 then
	    target (i).Direction := 0
	end if
	%if the target is dead, move it downward
	if target (i).Dead then
	    if target (i).Y > bunkerY - targetHeight then
		target (i).Y -= 10
	    end if
	else
	    %moves the target upward if it is bellow the bunker
	    if target (i).Y < bunkerY then
		target (i).Y += target (i).Speed
	    else
		%else if it is above the bunker move it left and right depending on the direcyion
		if target (i).Direction = 1 then
		    target (i).X += target (i).Speed
		else
		    target (i).X -= target (i).Speed
		end if
	    end if
	end if
    end for
end moveTargets

proc targetsReturnFire
    for i : 1 .. targetNum
	%if the target is high enough to fire, and it is disturbed and it has had time appropriate time between shots, and it has not used up all of its bullets then it will shoot
	if target (i).Y >= bunkerY and target (i).Disturbed and target (i).ShootingCounter > 0 and target (i).bulletCounter < 100 then
	    target (i).Clip -= 1
	    %determines it shooting counter
	    if target (i).Clip = 0 then
		target (i).ShootingCounter := -3161 div 60
	    else
		target (i).ShootingCounter := -1000 div 60
	    end if
	    target (i).ShootingAnimationCounter := target (i).ShootingCounter + 250 div 60
	    %raises its bullet counter
	    target (i).bulletCounter += 1
	    %randomizes a lost in health
	    if myDifficulty = 1 and Rand.Int (1, 30) = 1 or myDifficulty = 2 and Rand.Int (1, 20) = 1 or myDifficulty = 3 and Rand.Int (1, 10) = 1 then
		loseHP (Rand.Int (1, 25))
	    end if
	end if
    end for
end targetsReturnFire

/*
 ------------------------
 Game/Memu
 ------------------------
 */

proc playGame
    Music.PlayFileStop %stops all music
    Window.Show (game) %shows the game window
    Window.Hide (menu) %hides the menu window
    %prepares the menu window for its next use
    Pic.ScreenLoad ("Images/BackGrounds/Menu_BackGround.bmp", 0, 0, 0)
    Font.Draw ("Call Of Duty Sniping", (maxx - Font.Width ("Call Of Duty Sniping", font)) div 2 - 150, maxy - 58, font, white)
    Font.Draw ("Play", 50, maxy - 48 * 2 - 50 * 2, font, white)
    Font.Draw ("Instructions", 50, maxy - 48 * 3 - 50 * 3, font, white)
    Font.Draw ("Cheats", 50, maxy - 48 * 4 - 50 * 4, font, white)
    Font.Draw ("LeaderBoard", 50, maxy - 48 * 5 - 50 * 5, font, white)
    Font.Draw ("Quit", maxx - 50 - Font.Width ("Quit", font), 50, font, white)
    View.Update
    Window.Select (game) %selsects the game window
    Music.PlayFileLoop ("SoundTrack/Music/Game1Music.wav") %plays music
    loop
	increaseCounters
	keyboardInput
	mouseInput
	moveTargets
	targetsReturnFire
	respawn
	switchSongs
	Output
	View.Update
	Time.DelaySinceLast (60)
	exit when endGame
    end loop
    Window.Show (menu) %shows menu window
    Window.Hide (game) %hides menu window
    %prepares the game window for its next use
    resetGame
    Output
    View.Update
    Window.Select (menu) %selects the menu window
    Music.PlayFileStop     %stops music
    Music.PlayFileLoop ("SoundTrack/Music/Menu.MP3") %starts new music
end playGame

proc MainMenu
    loop
	mousewhere (mouseX, mouseY, button)
	%Draws the menu Screen
	Pic.ScreenLoad ("Images/BackGrounds/Menu_BackGround.bmp", 0, 0, 0)
	Font.Draw ("Call Of Duty Sniping", (maxx - Font.Width ("Call Of Duty Sniping", font)) div 2 - 150, maxy - 58, font, white)
	Font.Draw ("Play", 50, maxy - 48 * 2 - 50 * 2, font, white)
	Font.Draw ("Instructions", 50, maxy - 48 * 3 - 50 * 3, font, white)
	Font.Draw ("Cheats", 50, maxy - 48 * 4 - 50 * 4, font, white)
	Font.Draw ("LeaderBoard", 50, maxy - 48 * 5 - 50 * 5, font, white)
	Font.Draw ("Quit", maxx - 50 - Font.Width ("Quit", font), 50, font, white)
	View.Update
	%if pressing on the play Button
	if ptinrect (mouseX, mouseY, 50, maxy - 48 * 2 - 50 * 2, 50 + Font.Width ("Play", font), maxy - 50 * 2 - 48) and button = 1 then
	    loop
		%draws the difficulty selection screen
		Pic.ScreenLoad ("Images/BackGrounds/SubMenu_BackGround.bmp", 0, 0, 0)
		Font.Draw ("Please Select a Difficulty", (maxx - Font.Width ("Please Select a Difficulty", font)) div 2, maxy - 150, font, white)
		Font.Draw ("Rookie", maxx div 6 - Font.Width ("Rookie", font) div 2, maxy div 2 - 25, font, white)
		Font.Draw ("Regular", (maxx - Font.Width ("Regular", font)) div 2, maxy div 2 - 25, font, white)
		Font.Draw ("VETERAN", maxx * 5 div 6 - Font.Width ("VETERAN", font) div 2, maxy div 2 - 25, font, white)
		mousewhere (mouseX, mouseY, button)
		%if pressing on a difficulty, play the game
		if ptinrect (mouseX, mouseY, maxx div 6 - Font.Width ("Rookie", font) div 2, maxy div 2 - 25, maxx div 6 + Font.Width ("Rookie", font) div 2, maxy div 2 + 25) then
		    if button = 1 then
			myDifficulty := 1
			playGame
			exit
		    else
			Font.Draw ("Easiest Difficulty, Random Spawning", (maxx - Font.Width ("Easiest Difficulty, Random Spawning", font)) div 2, 100, font, white)
		    end if
		elsif ptinrect (mouseX, mouseY, (maxx - Font.Width ("Regular", font)) div 2, maxy div 2 - 25, (maxx + Font.Width ("Regular", font)) div 2, maxy div 2 + 25) then
		    if button = 1 then
			myDifficulty := 2
			playGame
			exit
		    else
			Font.Draw ("Medium Difficulty, Wave Spawning", (maxx - Font.Width ("Medium Difficulty, Wave Spawning", font)) div 2, 100, font, white)
		    end if
		elsif ptinrect (mouseX, mouseY, maxx * 5 div 6 - Font.Width ("VETERAN", font) div 2, maxy div 2 - 25, maxx * 5 div 6 + Font.Width ("VETERAN", font) div 2, maxy div 2 + 25) then
		    if button = 1 then
			myDifficulty := 3
			playGame
			exit
		    else
			Font.Draw ("Hard Difficulty, One Dies, Two Spawn", (maxx - Font.Width ("Hard Difficulty, One Dies, Two Spawn", font)) div 2, 100, font, white)
		    end if
		else
		    %else go back to the previous screen
		    Font.Draw ("Back", (maxx - Font.Width ("Back", font)) div 2, 100, font, white)
		    exit when button = 1 and ptinrect (mouseX, mouseY, (maxx - Font.Width ("Back", font)) div 2, 100, (maxx + Font.Width ("Back", font)) div 2, 150)
		end if
		View.Update
	    end loop
	    %if pressing on the instructions button
	elsif ptinrect (mouseX, mouseY, 50, maxy - 48 * 3 - 50 * 3, (maxx - Font.Width ("Instructions", font)) div 2, maxy - 50 * 3 - 48 * 2) and button = 1 then
	    %Draw the the instructions screen
	    Pic.ScreenLoad ("Images/BackGrounds/SubMenu_BackGround.bmp", 0, 0, 0)
	    Font.Draw ("Instructions", (maxx - Font.Width ("Instructions", font)) div 2 - 150, maxy - 58, font, white)
	    Font.Draw ("Back", (maxx - Font.Width ("Back", font)) div 2 - 150, 50, font, white)
	    Font.Draw ("Shoot: Left Mouse", (maxx - Font.Width ("Shoot: Left Mouse", font2)) div 2 - 150, maxy - 25 * 5 - 24 * 5, font2, white)
	    Font.Draw ("Reload: R", (maxx - Font.Width ("Reload: R", font2)) div 2 - 150, maxy - 25 * 6 - 24 * 6, font2, white)
	    Font.Draw ("Press Ctrl: More Control", (maxx - Font.Width ("Press Ctrl: More Control", font2)) div 2 - 150, maxy - 25 * 7 - 24 * 7, font2, white)
	    Font.Draw ("Press Shift: Shift faster", (maxx - Font.Width ("Press Shift: Shift faster", font2)) div 2 - 150, maxy - 25 * 8 - 24 * 8, font2, white)
	    Font.Draw ("Enter: Opens Chat bar", (maxx - Font.Width ("Enter: Opens Chat bar", font2)) div 2 - 150, maxy - 25 * 9 - 24 * 9, font2, white)
	    View.Update
	    %exit when you click on back
	    loop
		mousewhere (mouseX, mouseY, button)
		exit when ptinrect (mouseX, mouseY, (maxx - Font.Width ("Back", font)) div 2 - 150, 50, (maxx + Font.Width ("Back", font)) div 2 - 150, 50 + 48) and button = 1
	    end loop
	    %if pressing on the cheats screen
	elsif ptinrect (mouseX, mouseY, 50, maxy - 48 * 4 - 50 * 4, 50 + Font.Width ("Cheats", font), maxy - 50 * 4 - 48 * 3) and button = 1 then
	    % Draw the cheets screen
	    Pic.ScreenLoad ("Images/BackGrounds/SubMenu_BackGround.bmp", 0, 0, 0)
	    Font.Draw ("Cheats", (maxx - Font.Width ("Cheats", font)) div 2 - 150, maxy - 58, font, white)
	    Font.Draw ("Back", (maxx - Font.Width ("Back", font)) div 2 - 150, 50, font, white)
	    Font.Draw ("While playing press Enter", (maxx - Font.Width ("While playing press Enter", font2)) div 2 - 150, maxy - 51 * 3, font2, white)
	    Font.Draw ("then type in the following cheats", (maxx - Font.Width ("then type in the following cheats", font2)) div 2 - 150, maxy - 51 * 4, font2, white)
	    Font.Draw ("Infinite Health: I Am God", (maxx - Font.Width ("Infinite Health: I Am God", font2)) div 2 - 150, maxy - 51 * 5, font2, white)
	    Font.Draw ("Infinite bullets: Supply Me", (maxx - Font.Width ("Infinite bulletCounter: Supply Me", font2)) div 2 - 150, maxy - 51 * 6, font2, white)
	    Font.Draw ("Instant Reloading: Machine Gun", (maxx - Font.Width ("Instant Reloading: Machine Gun", font2)) div 2 - 150, maxy - 51 * 7, font2, white)
	    Font.Draw ("Bullets do Infinite Damage: HeadShot", (maxx - Font.Width ("Bullets do Infinite Damage: HeadShot", font2)) div 2 - 150, maxy - 51 * 8, font2, white)
	    Font.Draw ("Complete Accuracy : Steady Aim", (maxx - Font.Width ("Complete Accuracy : Steady Aim", font2)) div 2 - 150, maxy - 51 * 9, font2, white)
	    Font.Draw ("Suicide : Kill Me", (maxx - Font.Width ("Suicide : kill me", font2)) div 2 - 150, maxy - 51 * 10, font2, white)
	    Font.Draw ("Turn off all Cheats : Disable All", (maxx - Font.Width ("Turn off all Cheats : Disable All", font2)) div 2 - 150, maxy - 51 * 11, font2, white)
	    Font.Draw ("Turn on all Cheats : Enable All", (maxx - Font.Width ("Turn off all Cheats : Enable All", font2)) div 2 - 150, maxy - 51 * 12, font2, white)
	    View.Update
	    %exit when you click on back
	    loop
		mousewhere (mouseX, mouseY, button)
		exit when ptinrect (mouseX, mouseY, (maxx - Font.Width ("Back", font)) div 2 - 150, 50, (maxx + Font.Width ("Back", font)) div 2 - 150, 50 + 48) and button = 1
	    end loop
	    %if pressing on the leaderboard button
	elsif ptinrect (mouseX, mouseY, 50, maxy - 48 * 5 - 50 * 5, (maxx - Font.Width ("LeaderBoard", font)) div 2, maxy - 50 * 5 - 48 * 4) and button = 1 then
	    loop
		%draw the leaderBoard screen
		Pic.ScreenLoad ("Images/BackGrounds/SubMenu_BackGround.bmp", 0, 0, 0)
		Font.Draw ("LeaderBoard", (maxx - Font.Width ("LeaderBoard", font)) div 2, maxy - 58, font, white)
		Font.Draw ("Back", (maxx - Font.Width ("Back", font)) div 2, 50, font, white)
		DrawTriangle (5 + Font.Width ("Ranking", font2), maxy - 50 * 3, sortPlace, 20, white)
		DrawTriangle (155 + Font.Width ("Soldier", font2), maxy - 50 * 3, sortName, 20, white)
		DrawTriangle (380 + Font.Width ("Rank", font2), maxy - 50 * 3, sortRank, 20, white)
		DrawTriangle (maxx - 20, maxy - 50 * 3, sortScore, 20, white)
		Font.Draw ("Ranking", 0, maxy - 50 * 3, font2, white)
		Font.Draw ("Soldier", 150, maxy - 50 * 3, font2, white)
		Font.Draw ("Rank", 375, maxy - 50 * 3, font2, white)
		Font.Draw ("Kills In Battle", maxx - Font.Width ("Kills In Battle", font2) - 25, maxy - 50 * 3, font2, white)
		Font.Draw ("RESET", maxx - Font.Width ("RESET", font) - 25, 25, font, white)
		for i : 1 .. 10
		    Font.Draw (intstr (leaderBoardPlaceExternal (i)) + ".", 0, maxy - 50 * (3 + i), font2, white)
		    Font.Draw (leaderBoardNameExternal (i), 150, maxy - 50 * (3 + i), font2, white)
		    if leaderBoardDifficultyExternal (i) = 1 then
			Font.Draw ("Rookie", 375, maxy - 50 * (3 + i), font2, white)
		    elsif leaderBoardDifficultyExternal (i) = 2 then
			Font.Draw ("Regular", 375, maxy - 50 * (3 + i), font2, white)
		    else
			Font.Draw ("VETERAN", 375, maxy - 50 * (3 + i), font2, white)
		    end if
		    Font.Draw (intstr (leaderBoardScoreExternal (i)), maxx - Font.Width ("Kills In Battle", font2) - 25, maxy - 50 * (3 + i), font2, white)
		end for
		View.Update
		mousewhere (mouseX, mouseY, button)
		if button = 0 then
		    done := false
		end if
		if button = 1 and done = false then
		    %if clicking on the ranking triangle (sort by place)
		    if ptinrect (mouseX, mouseY, 0, maxy - 50 * 3, 5 + Font.Width ("Ranking", font2), maxy - 50 * 3 + 20) then
			if sortPlace then
			    sortPlace := false
			else
			    sortPlace := true
			end if
			IntOrder (leaderBoardPlaceExternal, leaderBoardScoreExternal, leaderBoardDifficultyExternal, leaderBoardNameExternal, sortPlace)
			done := true
			%if clicking on the Soldior triangle (sort by name)
		    elsif ptinrect (mouseX, mouseY, 150, maxy - 50 * 3, 175 + Font.Width ("Soldier", font2), maxy - 50 * 3 + 20) then
			if sortName then
			    sortName := false
			else
			    sortName := true
			end if
			StrOrder (leaderBoardNameExternal, leaderBoardDifficultyExternal, leaderBoardScoreExternal, leaderBoardPlaceExternal, sortName)
			done := true
			%if clicking on the Rank triangle (sort by difficulty)
		    elsif ptinrect (mouseX, mouseY, 375, maxy - 50 * 3, 400 + Font.Width ("Rank", font2), maxy - 50 * 3 + 20) then
			if sortRank then
			    sortRank := false
			else
			    sortRank := true
			end if
			IntOrder (leaderBoardDifficultyExternal, leaderBoardScoreExternal, leaderBoardPlaceExternal, leaderBoardNameExternal, sortRank)
			done := true
			%if clicking on the Kills In Battle triangle (sort by score)
		    elsif ptinrect (mouseX, mouseY, maxx - Font.Width ("Kills In Battle", font2) - 25, maxy - 50 * 3, maxx, maxy - 50 * 3 + 20) then
			if sortScore then
			    sortScore := false
			else
			    sortScore := true
			end if
			IntOrder (leaderBoardScoreExternal, leaderBoardPlaceExternal, leaderBoardDifficultyExternal, leaderBoardNameExternal, sortScore)
			done := true
		    elsif ptinrect (mouseX, mouseY, maxx - Font.Width ("RESET", font) - 25, 25, maxx - 25, 75) then
			%get the original data
			open : fileName, "DataFiles/HighScoreOriginal.dat", get
			for i : 1 .. 10
			    get : fileName, leaderBoardNameInternal (i)
			    get : fileName, leaderBoardScoreInternal (i)
			    get : fileName, leaderBoardDifficultyInternal (i)
			end for
			close : fileName
			%save it into the highscore file
			open : fileName, "DataFiles/HighScore.dat", put
			for i : 1 .. 10
			    put : fileName, leaderBoardNameInternal (i), " ", leaderBoardScoreInternal (i), " ", leaderBoardDifficultyInternal (i)
			end for
			close : fileName
			%re saves it into the external leaderboard variables
			for i : 1 .. 10
			    leaderBoardNameExternal (i) := leaderBoardNameInternal (i)
			    StringLetterSwitcher (leaderBoardNameExternal (i), "_", " ")
			    leaderBoardPlaceExternal (i) := i
			    leaderBoardScoreExternal (i) := leaderBoardScoreInternal (i)
			    leaderBoardDifficultyExternal (i) := leaderBoardDifficultyInternal (i)
			end for
			%resets the sort
			sortName := false
			sortScore := false
			sortRank := false
			sortPlace := true
		    end if
		end if
		%exit when you press on back
		exit when ptinrect (mouseX, mouseY, (maxx - Font.Width ("Back", font)) div 2, 50, (maxx + Font.Width ("Back", font)) div 2, 50 + 48) and button = 1
	    end loop
	    % if clicking onto the quit button
	elsif ptinrect (mouseX, mouseY, maxx - 50 - Font.Width ("Quit", font), 50, maxx - 50, 50 + 48) and button = 1 then
	    buttondone := true
	    loop
		mousewhere (mouseX, mouseY, button)
		if button = 0 then
		    buttondone := false
		end if
		%raise the yCredits
		if skipmode then
		    yCredits += 20
		else
		    yCredits += 1
		end if
		%determine if you wish to skip
		if ptinrect (mouseX, mouseY, maxx - 50 - Font.Width ("skip", font), 50, maxx - 50, 50 + 48) and button = 1 and buttondone = false then
		    skipmode := true
		end if
		%draw the screen
		Pic.ScreenLoad ("Images/BackGrounds/Credits_BackGround.bmp", 0, 0, 0)
		Font.Draw ("Skip", maxx - 50 - Font.Width ("Skip", font), 50, font, white)
		Font.Draw ("Call Of Duty Sniping", (maxx - Font.Width ("Call Of Duty Sniping", font2)) div 2, yCredits - 30 * 0, font2, white)
		Font.Draw ("Created By:", (maxx - Font.Width ("Created By:", font2)) div 2, yCredits - 30 * 3, font2, white)
		Font.Draw ("Denis Shleifman", (maxx - Font.Width ("Denis Shleifman", font2)) div 2, yCredits - 30 * 4, font2, white)
		Font.Draw ("Chief Concept Designer:", (maxx - Font.Width ("Chief Concept Designer:", font2)) div 2, yCredits - 30 * 6, font2, white)
		Font.Draw ("Denis Shleifman", (maxx - Font.Width ("Denis Shleifman", font2)) div 2, yCredits - 30 * 7, font2, white)
		Font.Draw ("Chief Programmer:", (maxx - Font.Width ("Chief Programmer:", font2)) div 2, yCredits - 30 * 9, font2, white)
		Font.Draw ("Denis Shleifman", (maxx - Font.Width ("Denis Shleifman", font2)) div 2, yCredits - 30 * 10, font2, white)
		Font.Draw ("Chief of Photo Editing:", (maxx - Font.Width ("Chief of Photo Editing:", font2)) div 2, yCredits - 30 * 12, font2, white)
		Font.Draw ("Steven Le", (maxx - Font.Width ("Steven Le", font2)) div 2, yCredits - 30 * 13, font2, white)
		Font.Draw ("Thank you for playing", (maxx - Font.Width ("Thank you for playing", font2)) div 2, yCredits - 30 * 15, font2, white)
		View.Update
		exit when yCredits > maxy + 30 * 15 %exit when the credits reach the top of the screen
		Time.DelaySinceLast (5)
	    end loop
	    Music.PlayFileStop %stop all music
	    Music.PlayFileReturn ("SoundTrack/Sound Effects/Shoot.MP3") %plays a shooting sound
	    %draws the final slide
	    Pic.ScreenLoad ("Images/BackGrounds/Credits_BulletHole.bmp", 180, 20, picMerge)
	    Font.Draw ("COD", (maxx - Font.Width ("COD", font4)) div 2, maxy div 2 - 50, font4, white)
	    Font.Draw ("Sniping", (maxx - Font.Width ("Sniping", font2)) div 2, maxy div 2 - 75, font2, white)
	    View.Update
	    Time.DelaySinceLast (1000) %delay
	    %end the game
	    Window.Close (game)
	    quit
	end if
    end loop
end MainMenu

/*
 ------------------------
 Pre Program
 ------------------------
 */
%opens the fule to retrieve the internal data
open : fileName, "DataFiles/HighScore.dat", get
for i : 1 .. 10
    get : fileName, leaderBoardNameInternal (i)
    get : fileName, leaderBoardScoreInternal (i)
    get : fileName, leaderBoardDifficultyInternal (i)
end for
close : fileName

%converts the internal data to the external data
for i : 1 .. 10
    leaderBoardScoreExternal (i) := leaderBoardScoreInternal (i)
    leaderBoardDifficultyExternal (i) := leaderBoardDifficultyInternal (i)
    leaderBoardNameExternal (i) := leaderBoardNameInternal (i)
    leaderBoardPlaceExternal (i) := i
    StringLetterSwitcher (leaderBoardNameExternal (i), "_", " ")
end for

/*
 ------------------------
 program
 ------------------------
 */

resetGame
Music.PlayFileLoop ("SoundTrack/Music/Menu.MP3")
MainMenu
