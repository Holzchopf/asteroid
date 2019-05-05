' some constants defining our world
Const SCREEN_HERTZ:Int				= 60
Const SCREEN_WIDTH:Int				= 640
Const SCREEN_HEIGHT:Int				= 480
Const SCREEN_DEPTH:Int				= 0
' velocities are now in px/ms - not px/frame
' (px/frame = px/(20ms)
Const COEFF_ROTATE:Float			= 4.0 / 16.0
Const COEFF_ACCELERATE:Float		= 0.01'1.0 / 16.0
Const COEFF_RESISTANCE:Float		= 0.01' * 128.0
Const VMAX:Float					= 10.0 / 16.0
Const VSHOT:Float					= 7.0 / 16.0
Const VMAX_ASTEROID:Float			= 1.0 / 16.0
