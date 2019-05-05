Type TPlayer
	' position, velocity and rotation
	Field x:Float=200, y:Float=100
	Field vx:Float=0, vy:Float=0
	Field rot:Float
	
	Field health:Int = 100
	
	'Field __proj:Float

	' for prototyping: polygon defining player graphics
	Global polyxy:Float[] = [16.0, 0.0, 0.0, 16.0, -12.0, 12.0, -16.0, 0.0, -12.0, -12.0, 0.0, -16.0]
	
	' laser cooldown time
	Field stimer:Int
	
	' update player position
	Method Update()
		' rotation: simply react to JoyX()
		rot :+ jx * COEFF_ROTATE * dms
		' acceleration is more complicated and needs a little mathematics:
		' velocity and angle of current movement
		' (Not necessarily direction of ship)
		Local v0:Float = Sqr(vx*vx + vy*vy)
		Local a0:Float = ATan2(vy, vx)
		' forces acting on ship:
		Local fx:Float, fy:Float
		' acceleration force - react to JoyY() (attention, Joy "forward" is -1)
		Local facc:Float = -jy * COEFF_ACCELERATE
		
		rem
		' propelling vector
		Local ax:Float = Cos(rot) * facc
		Local ay:Float = Sin(rot) * facc
		
		' adapt force by orientation of ship to current movement vector
		'- cosine of angle between the two vectors
		Local n:Float = (Abs(facc) * v0)
		Local cosphi:Float
		If n = 0 Then
			cosphi = 0
		Else
			cosphi = (vx*ax + vy*ay) / n
		EndIf
		'__proj = cosphi
		'- scale facc according to cosphi: @1 = x1.0, @0 = x2.0
		Local scl:Float = 2.0 - cosphi
		'facc :* scl
		End Rem
		
		'--- allow negative acceleration? ---
		If facc < 0 Then facc = 0
		
		' decelaration force - simple air resistance approximation:
		' force = f( v0^2 )
		Local fdec:Float = v0*v0 * COEFF_RESISTANCE ' (v0^2)
		
		' calculate resulting force on ship
		' facc acts positive, fdec negative
		fx = Cos(rot) * facc - Cos(a0) * fdec
		fy = Sin(rot) * facc - Sin(a0) * fdec
		
		' resulting acceleration
		Local ax:Float = fx / MASS_PLAYER
		Local ay:Float = fy / MASS_PLAYER
		
		' s1 = s0 + 1/2 * a * t^2 + v0 * t
		' v1 = v0 + a * t
		
		' first: update position
		x :+ dms * (ax / 2 * dms + vx)
		y :+ dms * (ay / 2 * dms + vy)
		' second: update velocity
		vx :+ ax * dms
		vy :+ ay * dms
		
		' --- limit vmax by force loss on velocity? ---
		' limit total velocity
		Rem
		Local vtot:Float = Sqr(vx*vx + vy*vy)
		If vtot > VMAX Then
			Local vmul:Float = vtot / VMAX
			vx = vx / vmul
			vy = vy / vmul
		EndIf
		endrem
		
		' update position
		'x :+ vx * dms
		'y :+ vy * dms
		
		' wrap over screen edges
		If x < 0 Then x = SCREEN_WIDTH
		If x > SCREEN_WIDTH Then x = 0
		If y < 0 Then y = SCREEN_HEIGHT
		If y > SCREEN_HEIGHT Then y = 0
		
		' shoot lasers on trigger
		If khshot Or (kdshot And ms > stimer) Then
			stimer = ms + 100
			TShot.CreateOne(x , y , rot) 
		EndIf
	EndMethod
	
	' collision check against all asteroids
	Method CollideWithAsteroids() 
		Local dx:Float, dy:Float, dd:Float
		For Local a:TAsteroid = EachIn TAsteroid.all
			dx = a.x - x
			dy = a.y - y
			dd = Sqr(dx * dx + dy * dy) 
			If dd <= (16 + a.size) Then
				TAsteroid.all.Remove(a)
			EndIf
		Next
	End Method
	
	' draw player graphics
	Method Draw()
		SetColor(255,255,255)
		SetOrigin(x,y)
		SetRotation(rot)
		'DrawPoly(polyxy)
		DrawImage(imgSpaceship,0,0)
	End Method
EndType
