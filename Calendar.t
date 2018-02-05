setscreen ("graphics:560;560")

%all variables needed for the calendar

%variables that controls mouse
var mouseX, mouseY : int := -1
var mouseButton : int := -1
var buttonUpDown : int := -1

%check if mouse is clicked inside a rectangle
var inTheRectangle : boolean := false %boolean-true/false

%variables that calculate the starting day
var m2, y2, e : int := -1
var d : real := -1

%Others
var year : int := -1
var month : int := -1
var monthName : string := ""
var startingDay : int := -1
var totalMonthDays : int := -1
var day : int := -1
var hour : int := -1
var minute : int := -1
var second : int := -1
var dayOfWeek : int := -1

%Make the mouse wait
procedure waitForMouseClick
    Mouse.ButtonWait ("down", mouseX, mouseY, mouseButton, buttonUpDown)
    Mouse.ButtonWait ("up", mouseX, mouseY, mouseButton, buttonUpDown)
end waitForMouseClick

%Decide whether the click is inside a certain rectangle
procedure pointInsideRectangle (x1, y1, x2, y2 : int)
    if x2 > mouseX and mouseX > x1 and y2 > mouseY and mouseY > y1 then
	inTheRectangle := true
    else
	inTheRectangle := false
    end if
end pointInsideRectangle

/*************************************************************************
Name: drawNextMonthButton
Parameters:
	    x is an integer that 
	    y is an integer that
	    height is an integer that 
Purpose:
Restriction: 
*************************************************************************/

%draws the button at top left for next month
procedure drawNextMonthButton (x, y, height : int)

    const triangle_colour : int := black
    const back_colour : int := yellow

    drawfillbox (x, %background
	y - height div 2,
	x + height,
	y + height div 2,
	back_colour)

    for i : 0 .. height div 2      %triangle
	drawline (x + height div 3 + i,
	    y + height div 2 - i,
	    x + height div 3 + i,
	    y - height div 2 + i,
	    triangle_colour)
    end for

end drawNextMonthButton

%draws the button on the top right for previous month
procedure drawPreviousMonthButton (x, y, height : int)

    const triangle_colour : int := black
    const back_colour : int := yellow

    drawfillbox (x, %background
	y - height div 2,
	x + height,
	y + height div 2,
	back_colour)

    for i : 0 .. height div 2      %triangle backwards
	drawline (x + height div 3 + i,
	    y + i,
	    x + height div 3 + i,
	    y - i,
	    triangle_colour)
    end for

end drawPreviousMonthButton

%draws the grid for the calendar
procedure DrawCalendarGrid (monthname : string)

    const backcolour : int := black
    const titlecolour : int := yellow
    const linecolour : int := white

    %background
    Draw.FillBox (0, 0, maxx, maxy, backcolour)

    %verticle lines
    Draw.Line (80, 0, 80, 480, linecolour)
    Draw.Line (160, 0, 160, 480, linecolour)
    Draw.Line (240, 0, 240, 480, linecolour)
    Draw.Line (320, 0, 320, 480, linecolour)
    Draw.Line (400, 0, 400, 480, linecolour)
    Draw.Line (480, 0, 480, 480, linecolour)


    %horizonal lines
    Draw.Line (0, 80, 560, 80, linecolour)
    Draw.Line (0, 160, 560, 160, linecolour)
    Draw.Line (0, 240, 560, 240, linecolour)
    Draw.Line (0, 320, 560, 320, linecolour)
    Draw.Line (0, 400, 560, 400, linecolour)
    Draw.Line (0, 480, 560, 480, linecolour)

    %title
    var font : int := -1
    font := Font.New ("courier:25:bold")
    Draw.Text (monthname, maxx div 2 - length (monthname) * 10, maxy - 35, font, titlecolour)
    Font.Free (font)

    %title(weekdays)
    font := Font.New ("courier:20")
    Draw.Text ("Sun  Mon  Tue  Wed  Thu  Fri  Sat", 15, maxy - 70, font, titlecolour)
    Font.Free (font)

    drawNextMonthButton (maxx - 25, maxy - 25, 20) %draws the button
    drawPreviousMonthButton (5, maxy - 25, 20) %draws the button

end DrawCalendarGrid

%draws the number in the correct position
procedure DrawMonthDays (days : int, startingday : int) %numbers of days

    var numbercolour : int := yellow
    var font : int := -1
    font := Font.New ("courier:25:bold")

    var x : int := -1
    var y : int := 430

    for day : 1 .. days
	%x := 80 * day - 50
	if day < 10 then
	    x := 30 + ((day + startingday - 1) mod 7) * 80
	else
	    x := 20 + ((day + startingday - 1) mod 7) * 80
	end if
	Draw.Text (intstr (day), x, y, font, numbercolour)
	if ((day + startingday) mod 7) = 0 then %skipping lines
	    y := y - 80
	end if
    end for
end DrawMonthDays

%calculation of starting days of a month
procedure firstDayOfMonth (month : int, year : int)
    if month > 2 then
	m2 := month - 2
    elsif month = 1 then
	m2 := 11
    elsif month = 2 then
	m2 := 12
    end if
    if m2 = 11 or m2 = 12 then
	y2 := year mod 100 - 1
    else
	y2 := year mod 100
    end if
    d := (1 + (2.6 * m2 - 0.2) - 2 * (year div 100) + y2 + (y2 div 4) + (year div 400)) mod 7
    e := d div 1
end firstDayOfMonth

%code determines the number of days in a month
procedure monthDays (month : int, year : int)
    if month = 1 or month = 3 or month = 5 or month = 7 or month = 8 or month = 10
	    or month = 12 then
	totalMonthDays := 31
    elsif month = 4 or month = 6 or month = 9 or month = 11 then
	totalMonthDays := 30
    else
	if year mod 400 = 0 then
	    totalMonthDays := 29
	elsif year mod 100 = 0 then
	    totalMonthDays := 28
	elsif year mod 4 = 0 then
	    totalMonthDays := 29
	else
	    totalMonthDays := 28
	end if
    end if
end monthDays

%changes a number to a month name
procedure monthByName (month : int)
    case month of
	label 1 :
	    monthName := "January"
	label 2 :
	    monthName := "February"
	label 3 :
	    monthName := "March"
	label 4 :
	    monthName := "April"
	label 5 :
	    monthName := "May"
	label 6 :
	    monthName := "June"
	label 7 :
	    monthName := "July"
	label 8 :
	    monthName := "August"
	label 9 :
	    monthName := "September"
	label 10 :
	    monthName := "October"
	label 11 :
	    monthName := "November"
	label 12 :
	    monthName := "December"
    end case
end monthByName

%this is the main procedure that includes all the procedures I did before except the mouse
procedure generateMonth
    firstDayOfMonth (month, year)
    startingDay := e
    monthDays (month, year)
    monthByName (month)
    DrawCalendarGrid (monthName + " " + intstr (year))
    DrawMonthDays (totalMonthDays, startingDay)
end generateMonth

%
procedure processMouseClick
    pointInsideRectangle (maxx - 25, maxy - 35, maxx - 5, maxy - 15)
    if inTheRectangle /*because its a boolean*/ then
	month := month + 1
	if month = 13 then
	    month := 1
	    year := year + 1
	end if
    end if
    pointInsideRectangle (5, maxy - 35, 25, maxy - 15)
    if inTheRectangle then
	month := month - 1
	if month = 1 then
	    month := 12
	    year := year - 1
	end if
    end if
    inTheRectangle := false
end processMouseClick

% M A I N  P R O G R A M  B E G I N S  H E R E

Time.SecParts (Time.Sec, year, month, day, dayOfWeek, hour, minute, second)

loop
    generateMonth
    waitForMouseClick
    processMouseClick
end loop

