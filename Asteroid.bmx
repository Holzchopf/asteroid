SuperStrict

' using "Framework" prevents from every module being imported,
' which keeps the executable small
Framework BRL.GLMax2D
Import BRL.LinkedList
Import BRL.PNGLoader
Import BRL.Random
Import BRL.Timer
Import PUB.FreeJoy

' split up the code in several files - keeps it tidy
Include "_src/consts.bmx"
Include "_src/TAsteroid.bmx"
Include "_src/TAsteroidDebris.bmx"
Include "_src/TExplosion.bmx"
Include "_src/TPlayer.bmx"
Include "_src/TShot.bmx"


' initialise random number generator with arbitrary value,
' so it doesn't always generate the same sequence
SeedRnd( MilliSecs() )

' Limit to given FPS
Global timer:TTimer = CreateTimer( SCREEN_HERTZ )
' for framerate independent updates, store current MilliSecs() value
' and delta ms value (also, lets control game speed)
Global _ms:Int, ms:Float, dms:Float
' user input
Global jx:Float , jy:Float
Global khshot:Int, kdshot:Int, kdtlapse:Int
' time-lapse start/end, active, factor
Global tls:Int, tle:Int, tl:Int, tlf:Float = 1.0

' load graphics and set their handle (attachment point) to their center
Global imgSpaceship:TImage = LoadImage("gfx/spaceship.png")
MidHandleImage(imgSpaceship)
' asteroids will be drawn in various sizes, so it's best to load them
' with activated mipmapping and filtered - otherwise they will be pixelated
Global imgAsteroid:TImage = LoadImage("gfx/asteroid.png", MIPMAPPEDIMAGE | FILTEREDIMAGE )
MidHandleImage(imgAsteroid)
Global imgAsteroidDebris:TImage = LoadAnimImage("gfx/asteroid-debris.png", 128,128, 0, 32, MIPMAPPEDIMAGE | FILTEREDIMAGE)
MidHandleImage(imgAsteroidDebris)

Global player:TPlayer = New TPlayer

For Local i:Int = 0 Until 20
	TAsteroid.CreateOne()
Next

' init graphics mode
Graphics( SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_DEPTH, SCREEN_HERTZ ) 

' debug - joystick actually found?
'Print JoyCount()

' main loop
_ms = MilliSecs()
While Not (KeyDown(KEY_ESCAPE) Or AppTerminate())
	' input (and alternative inputs)
	jx = JoyX(0) + KeyDown(KEY_RIGHT) - KeyDown(KEY_LEFT)
	jy = JoyY(0) + KeyDown(KEY_DOWN) - KeyDown(KEY_UP) 
	khshot = JoyHit(0) + KeyHit(KEY_SPACE) 
	kdshot = JoyDown(0) + KeyDown(KEY_SPACE)
	kdtlapse = KeyDown(KEY_F)
	
	Local _cms:Int = MilliSecs()
	
	' timelapse controller
	If kdtlapse And (Not tl) Then
		tl = True
		tls = _cms
	ElseIf (Not kdtlapse) And tl Then
		tl = False
		tle = _cms
	EndIf
	' slow down
	If tl Then tlf = 1.0 - (_cms - tls) / 500.0
	If Not tl Then tlf = (_cms - tle) / 500.0
	
	tlf = Max(0.1, Min(1.0, tlf))
	
	' update real-time timing and game timing
	dms = (_cms - _ms) * tlf
	'If kdtlapse Then dms = 1
	_ms = _cms
	ms :+ dms
	
	player.Update() 
	TShot.UpdateAll()
	TAsteroid.UpdateAll()
	TAsteroidDebris.UpdateAll()
	TExplosion.UpdateAll()
	player.CollideWithAsteroids() 
	
	' output
	SetOrigin(0,0)
	SetRotation(0)
	SetBlend(ALPHABLEND)
	SetColor(255,255,255)

	Cls
	
	'--- TODO: replace by nice HUD ---
	rem
	DrawText(player.x, 0, 0)
	DrawText(player.y, 0, 15)
	DrawText(player.rot, 0, 30)
	
	DrawRect(100,0, 100*jx,15)
	DrawRect(100,15, 100*jy,15)
	end rem
	
	' draw game elements
	TAsteroid.DrawAll()
	TExplosion.DrawAll()
	TAsteroidDebris.DrawAll()
	player.Draw()
	TShot.DrawAll()
	
	' wait for timer, but not for VSYNC - most correct way to keep
	' game synced and framerate independent
	WaitTimer(timer)
	Flip 0
Wend
End

