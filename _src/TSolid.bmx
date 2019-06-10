' Base class for all solid objects with
' - mass
' - radius
' - (position)
' - (velocity)
' - (acceleration)

' overal update cycle plan:
' - (Control (e.g. react to player inputs))
' - (Update positions)
' - Check for collisions
'	Collisions will:
'	- move solids apart
'	- update their impulses
'	- call OnCollide(partner, oldvalues) for both solids
Type TSolid Extends TMobile
	' all registered solids (must be stored in global list for collision check)
	Global allSolid:TList = New TList
	' cache collision helper objects
	Global _oldMe:TSolid = New TSolid, _oldYou:TSolid = New TSolid

	' geometry
	Field radius:Float
	Field mass:Float
	
	Method CopyToSolid( pSolid:TSolid )
		CopyTo( TMobile(pSolid) )
		pSolid.radius = radius
		pSolid.mass = mass
	End Method
	
	Method Add()
		Super.Add()
		allSolid.AddLast(Self)
	End Method
	
	Method Remove()
		Super.Remove()
		allSolid.Remove(Self)
	End Method
	
	' controls, updates and collides all solids
	Function UpdateAll()
		' collision check of all against every other
		For Local s:TSolid = EachIn allSolid
			For Local p:TSolid = EachIn allSolid
				' only check against others
				If s <> p Then
					s.CollisionCheckWith(p)
				' once it's checking against self, abort the inner loop
				Else
					Exit
				EndIf
			Next
		Next
	End Function
	
	' standard collision checking routine
	' checks for collision, moves overlaping solids apart,
	' calls OnCollide for both parties with collision partner and old vector values
	Method CollisionCheckWith( pPartner:TSolid )
		' distance center-center
		Local dx:Float, dy:Float, dd:Float
		dx = pPartner.x - x
		dy = pPartner.y - y
		' if the distance is greater than half the screen, roll-over
		' (to simulate objects existing at all edges at the same time)
		If dx > SCREEN_WIDTH / 2 Then dx :- SCREEN_WIDTH
		If dx < -SCREEN_WIDTH / 2 Then dx :+ SCREEN_WIDTH
		If dy > SCREEN_HEIGHT / 2 Then dy :- SCREEN_HEIGHT
		If dy < -SCREEN_HEIGHT / 2 Then dy :+ SCREEN_HEIGHT
		dd = Sqr(dx * dx + dy * dy)
		' critical collision distance 
		Local mind:Float = (pPartner.radius + radius)
		If dd <= mind Then
			' store old values
			CopyToSolid( _oldMe )
			pPartner.CopyToSolid( _oldYou )
			' collision vector (normalised)
			Local cx:Float , cy:Float
			cx = dx / dd
			cy = dy / dd
			' overlapping distance,
			' move both away by a "share" of how much they overlap
			' which depends on their movement speed
			Local v0:Float = Sqr( vx*vx + vy*vy )
			Local v1:Float = Sqr( pPartner.vx*pPartner.vx + pPartner.vy*pPartner.vy )
			Local vtot:Float = v0 + v1
			Local f0:Float = v0 / vtot
			Local f1:Float = v1 / vtot
			Local od:Float = dd - mind
			If vtot=0 Then WriteStdout "vtot 0"
			x :+ cx * od * f0
			y :+ cy * od * f0
			pPartner.x :- cx * od * f1
			pPartner.y :- cy * od * f1
			' swap velocity vector
			Local m1:Float = pPartner.mass
			Local mtot:Float = mass + m1
			Local sx0:Float = vx
			Local sy0:Float = vy
			Local sx1:Float = pPartner.vx
			Local sy1:Float = pPartner.vy
			If mtot=0 Then WriteStdout "mtot 0"
			vx = 2 * (mass * sx0 + m1 * sx1) / mtot - sx0
			vy = 2 * (mass * sy0 + m1 * sy1) / mtot - sy0
			pPartner.vx = 2 * (mass * sx0 + m1 * sx1) / mtot - sx1
			pPartner.vy = 2 * (mass * sy0 + m1 * sy1) / mtot - sy1
			' tell 'em they collided
			OnCollide( pPartner, _oldMe )
			pPartner.OnCollide( Self, _oldYou )
			Rem
			vx = pAsteroid.vx * pAsteroid.mass / mtot
			vy = pAsteroid.vy * pAsteroid.mass / mtot
			pAsteroid.vx = sx * mass / mtot
			pAsteroid.vy = sy * mass / mtot
			End Rem
		EndIf
	End Method
	
	Method OnCollide( pPartner:TSolid, pOld:TSolid )
		
	End Method
End Type
