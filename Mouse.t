var mouseX, mouseY : int := -1
var mouseButton : int := -1
var buttonUpDown : int := -1

procedure waitForMouseClick
    Mouse.ButtonWait ("down", mouseX, mouseY, mouseButton, buttonUpDown)
    Mouse.ButtonWait ("up", mouseX, mouseY, mouseButton, buttonUpDown)
end waitForMouseClick

/*loop
 waitForMouseClick
 put mouseX, " ", mouseY
 end loop*/

var inTheRectangle : boolean := false %boolean-true/false

procedure pointInsideRectangle (x1, y1, x2, y2 : int)
    drawbox (x1, y1, x2, y2, red)
    if x2 > mouseX and mouseX > x1 and y2 > mouseY and mouseY > y1 then
	inTheRectangle := true
    else
	inTheRectangle := false
    end if
end pointInsideRectangle

waitForMouseClick
pointInsideRectangle (45, 20, 250, 220)
put inTheRectangle
