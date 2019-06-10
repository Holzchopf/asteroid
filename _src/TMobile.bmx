' Base class for all mobile objects with
' - position
' - velocity
' - acceleration

' overal update cycle plan:
' - Control (e.g. react to player inputs)
' - Update positions
Type TMobile
	' all registered mobiles
	Global allMobile:TList = New TList

	' position
	Field x:Float, y:Float
	Field rot:Float
	' velocity
	Field vx:Float, vy:Float
	' acceleration
	Field ax:Float, ay:Float
	
	Method CopyTo( pMobile:TMobile )
		pMobile.x = x
		pMobile.y = y
		pMobile.rot = rot
		pMobile.vx = vx
		pMobile.vy = vy
		pMobile.ax = ax
		pMobile.ay = ay
	End Method
	
	Method Add()
		allMobile.AddLast(Self)
	End Method
	
	Method Remove()
		allMobile.Remove(Self)
	End Method
	
	' controls and updates all mobiles
	Function UpdateAll()
		' control
		For Local s:TMobile = EachIn allMobile
			s.Control()
		Next
		' update
		For Local s:TMobile = EachIn allMobile
			s.Update()
		Next
	End Function
	
	' draws all mobiles
	Function DrawAll()
		For Local s:TMobile = EachIn allMobile
			' draw four copies of mobile, so they nicely wrap around screen edges
			Local offx:Float = 0
			Local offy:Float = 0
			If s.x > SCREEN_WIDTH / 2 Then offx :- SCREEN_WIDTH
			If s.y > SCREEN_HEIGHT / 2 Then offy :- SCREEN_HEIGHT
			For Local iy:Int = 0 To 1
				For Local ix:Int = 0 To 1
					s.Draw(offx + ix * SCREEN_WIDTH, offy + iy * SCREEN_HEIGHT)
				Next
			Next
		Next
	End Function
	
	' base methods, can be overwritten
	Method Control()
	
	End Method
	
	Method Update()
		' s1 = s0 + 1/2 * a * t^2 + v0 * t
		' v1 = v0 + a * t
		' first: update position
		x :+ dms * (ax / 2 * dms + vx)
		y :+ dms * (ay / 2 * dms + vy)
		' second: update velocity
		vx :+ ax * dms
		vy :+ ay * dms
		' update position
		'x :+ vx * dms
		'y :+ vy * dms
		' wrap over screen edges
		If x < 0 Then x :+ SCREEN_WIDTH
		If x > SCREEN_WIDTH Then x :- SCREEN_WIDTH
		If y < 0 Then y :+ SCREEN_HEIGHT
		If y > SCREEN_HEIGHT Then y :- SCREEN_HEIGHT
	End Method
	
	' draw mobile with optional offset
	Method Draw( pOffsetX:Float=0, pOffsetY:Float=0 )
	
	End Method
End Type
