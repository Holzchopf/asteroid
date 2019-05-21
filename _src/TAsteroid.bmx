Type TAsteroid
	' list off all existing asteroids
	Global all:TList = CreateList()

	' asteroid stats
	Field x:Float
	Field y:Float
	Field vx:Float, vy:Float
	Field rot:Float = 0
	Field size:Float			' radius of the asteroid in px
	Field mass:Float
	
	' create one at random
	Function CreateOne() 
		Local a:TAsteroid = New TAsteroid
		a.x = Rnd( SCREEN_WIDTH ) 
		a.y = Rnd( SCREEN_HEIGHT )
		Local rot:Float = Rnd(360) 
		Local vel:Float = Rnd(0, VMAX_ASTEROID)
		a.vx = Cos(rot) * vel
		a.vy = Sin(rot) * vel
		
		a.size = Rnd(10, 50)
		a.CalculateMass()
		all.AddLast(a)
	EndFunction
	
	' calculate mass from size
	Method CalculateMass()
		mass = size * size * size
	End Method
	
	' turn this asteroid into two, split among the axis 
	' going through the center and pointing pX/pY
	Method SplitIntoTwo(pX:Float, pY:Float)
		' only create new ones when bigger than...
		If size > 10 Then
			For Local i:Int = 0 Until 2
				' create new one, half as big as old one
				Local a:TAsteroid = New TAsteroid
				Local lsize:Float = size / 2.0
				' move away from center
				Local dist:Float = 1.1
				If i=1 Then dist = -1.1
				' copy stats from old one and adapt
				a.x = x - pY * dist
				a.y = y + pX * dist
				a.vx = vx - pY * dist * 0.1
				a.vy = vy + pX * dist * 0.1
				a.size = lsize
				a.CalculateMass()
				all.AddLast(a)
			Next
		EndIf
		' old one is not needed any longer
		all.Remove(Self)
	End Method
	
	' update all asteroids and check for collisions against
	' all other asteroids
	Function UpdateAll() 
		' update all positions first
		For Local a:TAsteroid = EachIn all
			a.Update()
		Next
		' check against all other asteroids
		For Local a:TAsteroid = EachIn all
			For Local b:TAsteroid = EachIn all
				' only check against others
				If a <> b Then
					a.CollideWith(b)
				' once it's checking twice the same, abort the inner loop
				Else
					Exit
				EndIf
			Next
		Next
	End Function
	
	' update stats
	Method Update()
		' update position
		x :+ vx * dms
		y :+ vy * dms
		' wrap over screen edges
		If x < 0 Then x = SCREEN_WIDTH
		If x > SCREEN_WIDTH Then x = 0
		If y < 0 Then y = SCREEN_HEIGHT
		If y > SCREEN_HEIGHT Then y = 0
	EndMethod
	
	' check for collision with other asteroid,
	' colliding asteroids bounce off each other
	Method CollideWith( pAsteroid:TAsteroid )
		' distance center-center
		Local dx:Float, dy:Float, dd:Float
		dx = pAsteroid.x - x
		dy = pAsteroid.y - y
		dd = Sqr(dx * dx + dy * dy)
		' critical collision distance 
		Local mind:Float = (pAsteroid.size + size)
		If dd <= mind Then
			' collision vector (normalised)
			Local cx:Float , cy:Float
			cx = dx / dd
			cy = dy / dd
			' overlapping distance,
			' move both away by half of how much they overlap
			Local od:Float = (dd - mind) / 2.0
			x :+ cx * od
			y :+ cy * od
			pAsteroid.x :- cx * od
			pAsteroid.y :- cy * od
			' swap velocity vector
			Local m1:Float = pAsteroid.mass
			Local mtot:Float = mass + m1
			Local sx0:Float = vx
			Local sy0:Float = vy
			Local sx1:Float = pAsteroid.vx
			Local sy1:Float = pAsteroid.vy
			vx = 2 * (mass * sx0 + m1 * sx1) / mtot - sx0
			vy = 2 * (mass * sy0 + m1 * sy1) / mtot - sy0
			pAsteroid.vx = 2 * (mass * sx0 + m1 * sx1) / mtot - sx1
			pAsteroid.vy = 2 * (mass * sy0 + m1 * sy1) / mtot - sy1
			Rem
			vx = pAsteroid.vx * pAsteroid.mass / mtot
			vy = pAsteroid.vy * pAsteroid.mass / mtot
			pAsteroid.vx = sx * mass / mtot
			pAsteroid.vy = sy * mass / mtot
			End Rem
		EndIf
	EndMethod
	
	' draw all existing asteroids
	Function DrawAll()
		For Local a:TAsteroid = EachIn all
			a.Draw()
		Next
	End Function
	
	Method Draw() 
		SetColor(128,128,128)
		SetOrigin(x,y)
		SetRotation(rot) 
		'DrawOval(-size,-size, 2*size, 2*size)
		SetScale(size/64.0, size/64.0)
		DrawImage(imgAsteroid, 0,0)
		SetScale(1,1)
	EndMethod
EndType
