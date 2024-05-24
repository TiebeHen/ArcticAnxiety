extends Node3D



@onready var debris = $Debris
@onready var smoke = $Smoke
@onready var fire = $Fire
@onready var explosion = $Explosion
static var TargetPos
var SoundPlayed = false




func _process(delta):
	_GetTargetPos()
	explode()


func explode():
	
	if(TargetPos != Vector3.ZERO):
		
		debris.position = TargetPos
		smoke.position = TargetPos
		fire.position = TargetPos
	
		debris.emitting = true
		smoke.emitting = true
		fire.emitting = true
		if(SoundPlayed == false):
			explosion.play()
			SoundPlayed = true
	
		
	
func _GetTargetPos():
	var RocketScript = load("res://Scripts/Rocket.cs")
	var RocketNode = RocketScript.new()
	TargetPos = RocketNode.TargetPos()
	
