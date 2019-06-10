
' Shots (lasers)
Type TShot Extends TSolid
	' create a shot at pX/pY in direction pRot
	Function CreateOne(pX:Float, pY:Float, pRot:Float) 
		Local s:TShot = New TShot
		s.x = pX
		s.y = pY
		s.vx = Cos(pRot) * VSHOT
		s.vy = Sin(pRot) * VSHOT
		s.radius = 2
		s.mass = 1
		s.Add()
	End Function

	' special behaviour for shots on collision: when colliding with an asteroid,
	' destroy that asteroid
	Method OnCollide( pPartner:TSolid, pOld:TSolid )
		' new direction of movement
		Local a0:Float = ATan2(vy, vx)
		' new velocity
		vx = Cos(a0) * VSHOT
		vy = Sin(a0) * VSHOT
		' collision with asteroid? destroy and remove!
		Local a:TAsteroid = TAsteroid( pPartner )
		If a Then
			TExplosion.CreateFromAsteroid(a, TShot(pOld) )
			TAsteroidDebris.CreateFromAsteroid(a, TShot(pOld) )
			a.SplitIntoTwo(vx,vy)
			Remove()
		EndIf
	End Method
	
	' draw shot
	Method Draw( pOffsetX:Float=0, pOffsetY:Float=0 ) 
		SetColor(255,0,0)
		SetOrigin(pOffsetX + x, pOffsetY + y) 
		'DrawOval(-size,-size, 2*size, 2*size)
		SetScale(radius/64.0, radius/64.0)
		DrawImage(imgAsteroid, 0,0)
		SetScale(1,1)
	End Method
End Type
