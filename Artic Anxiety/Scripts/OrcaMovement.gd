extends CharacterBody3D

var speed = 25
var motion = Vector3.ZERO
static var player = null
var orcaLoc
var target_velocity = Vector3.ZERO
var test

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	test = 0
	if player != null:
		if(test == 10000):
			look_at(Vector3(player.x, 0, player.z), Vector3(0, 1, 0)) 
			test = 0
		test += 1
		var direction = Vector3.ZERO
		orcaLoc = position
		#var  playerX = player[0];
		#var playerZ = player[2];
	
		if(player.x < orcaLoc[0]):
			direction.x -= 1
		else:
			direction.x += 1
		if(player.z < orcaLoc[2]):
			direction.z -= 1
		else:
			direction.z += 1
	
	
		if direction != Vector3.ZERO:
			direction = direction.normalized()
	
	
	
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
		target_velocity.y = velocity.y
		#motion = move_and_slide(motion)
		velocity = target_velocity
		move_and_slide()
	
func SetPlayerPos(pos: Vector3):
	player = pos
