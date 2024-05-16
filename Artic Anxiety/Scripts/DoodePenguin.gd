extends Node

static var Dood = false
var maxtimeLeftUntilDeathScreen = 3
var timeLeftUntilDeathScreen = maxtimeLeftUntilDeathScreen


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Dood == true:
		if timeLeftUntilDeathScreen < 0:
			$CameraDeath.current = true
			timeLeftUntilDeathScreen = maxtimeLeftUntilDeathScreen
		else:
			timeLeftUntilDeathScreen -= delta
	
func _KillPlayer():
	Dood = true

