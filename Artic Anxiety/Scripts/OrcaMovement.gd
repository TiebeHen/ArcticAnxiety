extends CharacterBody3D

var speed = 200
var motion = Vector3.ZERO
static var player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player != null:
		look_at(Vector3(player.x, 0, player.z), Vector3(0, 1, 0)) 
		
	#motion = move_and_slide(motion)
	
func SetPlayerPos(pos: Vector3):
	player = pos
