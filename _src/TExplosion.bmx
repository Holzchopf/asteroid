
Type TExplosion
	' list off all existing explosions
	Global all:TList = CreateList()

	' explosion stats
	Field x:Float
	Field y:Float
	Field vx:Float, vy:Float
	Field rot:Float = 0
	Field size:Float
	Field scale:Float = 1.0
	
	' time of creation and relative lifetime
	Field time0:Int
	Field dt:Float
	
	' create explosion from given asteroid
	' (copies position, velocities and rotation from asteroid)
	' and store it in the "all" list
	Function CreateFromAsteroid( pAsteroid:TAsteroid, pShot:TShot=Null )
			Local expl:TExplosion = New TExplosion
			' copy asteroid stats
			expl.x = pAsteroid.x
			expl.y = pAsteroid.y
			expl.vx = pAsteroid.vx
			expl.vy = pAsteroid.vy
			' if a shot was passed to the function,
			' adapt movement speed to the shot's one
			If pShot <> Null Then
				expl.vx :+ pShot.vx * 0.2
				expl.vy :+ pShot.vy * 0.2
			EndIf
			expl.rot = pAsteroid.rot
			expl.size = pAsteroid.size
			' pre-calculate the scale
			expl.time0 = ms
			all.AddLast( expl )
	End Function
	
	' update all registered explosions
	Function UpdateAll()
		For Local a:TExplosion = EachIn all
			a.Update()
		Next
	End Function
	
	' update position etc. of single explosion
	Method Update()
		' update time
		dt = (ms - time0) / 40.0
		' remove, when lifetime is exceeded
		If dt > 1.0 Then all.Remove(Self)
		' update position
		x :+ vx * dms
		y :+ vy * dms
		scale = (size + 32*dt) / 64.0
	End Method
	
	' draw all registered explosions
	Function DrawAll()
		For Local a:TExplosion = EachIn all
			a.Draw()
		Next
	End Function
	
	' draw single explosion
	Method Draw()
		Local r:Int = 255
		Local g:Int = 64 * (1 - dt)
		Local a:Float = (1 - dt)
		SetColor(r,g,0)
		SetAlpha(a)
		SetOrigin(x,y)
		SetRotation(rot) 
		SetScale(scale, scale)
		DrawImage(imgAsteroid, 0,0)
		SetScale(1,1)
		SetAlpha(1)
	End Method
End Type