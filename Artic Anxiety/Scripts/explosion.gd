extends Node3D



@onready var debris = $Debris
@onready var smoke = $Smoke
@onready var fire = $Fire
@onready var explosion = $Explosion
static var TargetPos
var SoundPlayed = false

var goKaboom = false


func _process(_delta):
	goKaboom = $"../..".can_explode()
	
	if goKaboom:
		TargetPos = $"../..".target_pos()
		explode()

func explode():
	debris.position = TargetPos
	smoke.position = TargetPos
	fire.position = TargetPos
	
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true
	if(SoundPlayed == false):
		explosion.play()
		SoundPlayed = true
		$"../..".hide()

