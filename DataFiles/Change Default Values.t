var nameInternal : array 1 .. 10 of string
var scoreInternal : array 1 .. 10 of int
var difficultyInternal : array 1 .. 10 of int
var fileName : int

%sets the default difficulty
for i : 1 .. 10
    if i > 6 then
	difficultyInternal (i) := 1
    elsif i < 4 then
	difficultyInternal (i) := 3
    else
	difficultyInternal (i) := 2
    end if
    %sets teh default score
    scoreInternal (i) := 100 - 10 * (i-1)
end for

%sets the default names
nameInternal (1) := "Denis"
nameInternal (2) := "Emily"
nameInternal (3) := "Michael"
nameInternal (4) := "Jessica"
nameInternal (5) := "Jacob"
nameInternal (6) := "Ashley"
nameInternal (7) := "Matthew"
nameInternal (8) := "Sarah"
nameInternal (9) := "Joshua"
nameInternal (10) := "Hannah"

%saves it into the masterCopy
open : fileName, "HighScoreOriginal.dat", put
for i : 1 .. 10
    put : fileName, nameInternal (i), " ", scoreInternal (i), " ", difficultyInternal (i)
end for
close : fileName

%saves it into the used copy of the highscore file
open : fileName, "HighScore.dat", put
for i : 1 .. 10
    put : fileName, nameInternal (i), " ", scoreInternal (i), " ", difficultyInternal (i)
end for
close : fileName
