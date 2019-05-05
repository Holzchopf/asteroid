
Type TAsteroidDebris
	' list off all existing asteroid debris pieces
	Global all:TList = CreateList()

	' debris stats
	Field x:Float
	Field y:Float
	Field vx:Float, vy:Float
	Field rot:Float = 0
	Field size:Float
	Field scale:Float = 1.0
	
	' which piece (frame in image) to draw
	Field frame:Int
	
	' time of creation and lifetime
	Field time0:Int
	Field dt:Int
	
	
	' create complete set of debris from given asteroid
	' (copies position, velocities and rotation from asteroid)
	' and store it in the "all" list
	Function CreateFromAsteroid( pAsteroid:TAsteroid, pShot:TShot=Null )
		' create all 32 pieces for one asteroid
		For Local i:Int = 0 Until 32
			Local debris:TAsteroidDebris = New TAsteroidDebris
			' copy asteroid stats, slightly adapt movement vector
			debris.x = pAsteroid.x
			debris.y = pAsteroid.y
			debris.vx = pAsteroid.vx + Rnd(-0.05, 0.05)
			debris.vy = pAsteroid.vy + Rnd(-0.05, 0.05)
			' if a shot was passed to the function,
			' adapt movement speed to the shot's one
			If pShot <> Null Then
				debris.vx :+ pShot.vx * 0.2
				debris.vy :+ pShot.vy * 0.2
			EndIf
			debris.rot = pAsteroid.rot
			debris.size = pAsteroid.size
			' pre-calculate the scale
			debris.scale = debris.size / 64.0
			' store debris piece
			debris.frame = i
			debris.time0 = ms
			all.AddLast( debris )
		Next
	End Function
	
	' update all registered debris objects
	Function UpdateAll()
		For Local a:TAsteroidDebris = EachIn all
			a.Update()
		Next
	End Function
	
	' update position etc. of single debris object
	Method Update()
		dt = ms - time0
		' update position
		x :+ vx * dms
		y :+ vy * dms
		' make piece smaller, remove once its not visible any more
		scale :- 0.001 * dms / 20.0
		If scale < 0 Then all.Remove(Self)
		' wrap over screen edges
		If x < -size Then x = SCREEN_WIDTH + size
		If x > SCREEN_WIDTH + size Then x = -size
		If y < -size Then y = SCREEN_HEIGHT + size
		If y > SCREEN_HEIGHT + size Then y = -size
	End Method
	
	' draw all registered debris objects
	Function DrawAll()
		For Local a:TAsteroidDebris = EachIn all
			a.Draw()
		Next
	End Function
	
	' draw single debris object
	Method Draw()
		' first term goes from 1 to 0 real quick,
		' second goes from 0 to 1 slowly
		'Local g:Int = 255 * (Exp(-dt/20.0)) + 64 * (1-Exp(-dt/500.0))
		Local g:Int = 128 - 64 * (1-Exp(-dt/20.0))
		SetColor(g,g,g)
		SetOrigin(x,y)
		SetRotation(rot) 
		SetScale(scale, scale)
		DrawImage(imgAsteroidDebris, 0,0, frame)
		SetScale(1,1)
	End Method
End Type