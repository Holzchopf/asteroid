Type TAsteroid Extends TSolid
	' create one at random
	Function CreateOne() 
		Local a:TAsteroid = New TAsteroid
		a.x = Rnd( SCREEN_WIDTH ) 
		a.y = Rnd( SCREEN_HEIGHT )
		Local rot:Float = Rnd(360) 
		Local vel:Float = Rnd(0, VMAX_ASTEROID)
		a.vx = Cos(rot) * vel
		a.vy = Sin(rot) * vel
		
		a.radius = Rnd(10, 50)
		a.CalculateMass()
		a.Add()
	End Function
	
	' calculate mass from size
	Method CalculateMass()
		mass = radius * radius * radius
	End Method
	
	' turn this asteroid into two, split among the axis 
	' going through the center and pointing pX/pY
	Method SplitIntoTwo(pX:Float, pY:Float)
		' only create new ones when bigger than...
		If radius > 10 Then
			For Local i:Int = 0 Until 2
				' create new one, half as big as old one
				Local a:TAsteroid = New TAsteroid
				Local lradius:Float = radius / 2.0
				' move away from center
				Local dist:Float = 1.1
				If i=1 Then dist = -1.1
				' copy stats from old one and adapt
				a.x = x - pY * dist
				a.y = y + pX * dist
				a.vx = vx - pY * dist * 0.1
				a.vy = vy + pX * dist * 0.1
				a.radius = lradius
				a.CalculateMass()
				a.Add()
			Next
		EndIf
		' old one is not needed any longer
		Remove()
	End Method
	
	Method Draw( pOffsetX:Float=0, pOffsetY:Float=0 )
		SetColor(128,128,128)
		'SetOrigin(x,y)
		'SetRotation(rot) 
		'DrawOval(-size,-size, 2*size, 2*size)
		SetScale(radius/64.0, radius/64.0)
		SetOrigin(pOffsetX + x, pOffsetY + y)
		DrawImage(imgAsteroid, 0,0)
		SetScale(1,1)
	End Method
End Type
