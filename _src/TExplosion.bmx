
Type TExplosion Extends TMobile
	' explosion stats
	Field radius:Float
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
		expl.radius = pAsteroid.radius
		' pre-calculate the scale
		expl.scale = expl.radius / 64.0
		expl.time0 = ms
		expl.Add()
	End Function
	
	' update position etc. of single explosion
	Method Update()
		Super.Update()
		' update time
		dt = (ms - time0) / 40.0
		' remove, when lifetime is exceeded
		If dt > 1.0 Then Remove()
		scale = (radius + 32*dt) / 64.0
	End Method
	
	' draw single explosion
	Method Draw( pOffsetX:Float=0, pOffsetY:Float=0 )
		Local r:Int = 255
		Local g:Int = 64 * (1 - dt)
		Local a:Float = (1 - dt)
		SetColor(r,g,0)
		SetAlpha(a)
		SetOrigin(pOffsetX + x, pOffsetY + y)
		SetRotation(rot) 
		SetScale(scale, scale)
		DrawImage(imgAsteroid, 0,0)
		SetScale(1,1)
		SetAlpha(1)
	End Method
End Type