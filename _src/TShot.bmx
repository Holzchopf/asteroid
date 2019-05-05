
' Shots (lasers)
Type TShot
	' list of all existing shots
	Global all:TList = CreateList() 
	
	' projectile stats
	Field x:Float
	Field y:Float
	Field vx:Float, vy:Float
	Field size:Float = 2
	
	' create a shot at pX/pY in direction pRot
	Function CreateOne(pX:Float, pY:Float, pRot:Float) 
		Local s:TShot = New TShot
		s.x = pX
		s.y = pY
		s.vx = Cos(pRot) * VSHOT
		s.vy = Sin(pRot) * VSHOT
		ListAddLast(all, s)
	EndFunction

	' update all shots
	Function UpdateAll() 
		For Local s:TShot = EachIn all
			s.Update() 
		Next
	EndFunction
	
	' update shot stats
	Method Update()
		' update position
		x :+ vx * dms
		y :+ vy * dms
		' check for collisions with asteroids
		CollideWithAsteroids()
		' remove outside screen
		If x < 0 Then all.Remove(Self)
		If x > SCREEN_WIDTH Then all.Remove(Self)
		If y < 0 Then all.Remove(Self)
		If y > SCREEN_HEIGHT Then all.Remove(Self) 
	EndMethod
	
	' check this shot against all registered asteroids
	' on collision, destroy asteroid
	Method CollideWithAsteroids() 
		Local dx:Float, dy:Float, dd:Float
		For Local a:TAsteroid = EachIn TAsteroid.all
			' distance from shot center to asteroid center
			dx = a.x - x
			dy = a.y - y
			dd = Sqr(dx * dx + dy * dy)
			' hit an asteroid!
			If dd <= (size + a.size) Then
				TExplosion.CreateFromAsteroid(a, Self)
				TAsteroidDebris.CreateFromAsteroid(a, Self)
				a.SplitIntoTwo(vx, vy)
				all.Remove(Self)
			EndIf
		Next
	EndMethod

	' draw all existing shots
	Function DrawAll() 
		For Local s:TShot = EachIn all
			s.Draw() 
		Next
	EndFunction

	' draw shot
	Method Draw() 
		SetColor(255,0,0)
		SetOrigin(x,y) 
		'DrawOval(-size,-size, 2*size, 2*size)
		SetScale(size/64.0, size/64.0)
		DrawImage(imgAsteroid, 0,0)
		SetScale(1,1)
	EndMethod
EndType

