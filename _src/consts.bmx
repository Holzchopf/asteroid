' some constants defining our world
Const SCREEN_HERTZ:Int				= 60
Const SCREEN_WIDTH:Int				= 640
Const SCREEN_HEIGHT:Int				= 480
Const SCREEN_DEPTH:Int				= 0
' velocities are now in px/ms - not px/frame
' (px/frame ~= px/(16.7ms)
' VMAX_PLAYER = Sqrt(COEFF_ACCELERATE/COEFF_RESISTANCE)
' COEFF_RESISTANCE = COEFF_ACCELERATE/(VMAX_PLAYER^2)
Const MASS_PLAYER:Float				= 1
Const VMAX_PLAYER:Float				= 0.5
Const COEFF_ROTATE:Float			= 0.5
Const COEFF_ACCELERATE:Float		= 0.001
Const COEFF_RESISTANCE:Float		= COEFF_ACCELERATE / (VMAX_PLAYER * VMAX_PLAYER)
Const VMAX:Float					= 10.0 / 16.0
Const VSHOT:Float					= VMAX_PLAYER * 1.5
Const VMAX_ASTEROID:Float			= 1.0 / 16.0
