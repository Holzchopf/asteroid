Type TPlayer Extends TSolid
	Field health:Int = 100
	
	' laser cooldown time
	Field stimer:Int
	
	' create player at pX/pY
	Function CreateOne( pX:Int, pY:Int )
		Local p:TPlayer = New TPlayer
		p.x = pX
		p.y = pY
		p.rot = 0
		
		p.radius = 16
		p.mass = 16*16*16
		
		p.Add()
	End Function
	
	' control player
	Method Control()
		' rotation: simply react to JoyX()
		rot :+ jx * COEFF_ROTATE * dms
		
		' acceleration is more complicated and needs a little mathematics:
		
		' velocity and direction of current movement
		' (not necessarily angle of ship)
		Local v0:Float = Sqr(vx*vx + vy*vy)
		Local a0:Float = ATan2(vy, vx)
		' forces acting on ship:
		Local fx:Float, fy:Float
		' acceleration force - react to JoyY() (attention, Joy "forward" is -1)
		Local facc:Float = -jy * COEFF_ACCELERATE
		
		'--- allow negative acceleration? ---
		If facc < 0 Then facc = 0
		
		' decelaration force - simple air resistance approximation:
		' force = f( v0^2 )
		Local fdec:Float = v0*v0 * COEFF_RESISTANCE
		
		' calculate resulting force on ship
		' facc acts positive, fdec negative
		fx = Cos(rot) * facc - Cos(a0) * fdec
		fy = Sin(rot) * facc - Sin(a0) * fdec
		
		' update acceleration
		ax = fx / MASS_PLAYER
		ay = fy / MASS_PLAYER
		
		' pew pew pew
		If khshot Or (kdshot And ms > stimer) Then
			stimer = ms + 100
			Local nozzlea:Float = rot
			Local nozzler:Float = radius + 4
			TShot.CreateOne(x + Cos(nozzlea) * nozzler, y + Sin(nozzlea) * nozzler, rot)
		EndIf
	End Method
	
	' draw player graphics
	Method Draw( pOffsetX:Float=0, pOffsetY:Float=0 )
		SetColor(255,255,255)
		SetOrigin(pOffsetX + x, pOffsetY + y)
		SetRotation(rot)
		'DrawPoly(polyxy)
		DrawImage(imgSpaceship,0,0)
	End Method
End Type
