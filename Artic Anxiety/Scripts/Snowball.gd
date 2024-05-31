extends Node3D

# Constants and variables
const SPEED = 25.0
var max_time_snowball = 1.0
var time_left_snowball = 0.0
var _velocity = Vector3(SPEED, SPEED, SPEED) # Set velocity towards bottom right
@onready var collision_snowball = $StaticBody3D/CollisionShape3D
var activateCollisionTimer = 0.3


# Called when the node enters the scene tree for the first time.
func _ready():
	time_left_snowball = max_time_snowball
	collision_snowball.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.GameIsRunning == true:
			
		_velocity = _velocity.normalized() * SPEED * delta # Scale velocity by delta time
		translate(_velocity) # Move the snowball
		
		time_left_snowball -= delta
		if time_left_snowball < 0:
			queue_free()
	activateCollisionTimer -= delta
	if( activateCollisionTimer < 0):
		collision_snowball.disabled = false
# Set the velocity of the snowball
func set_velocity(velocity: Vector3):
	_velocity = velocity
