extends Node3D

# Constants and variables
const SPEED = 25.0
var max_time_snowball = 1.0
var time_left_snowball = 0.0
var _velocity = Vector3(SPEED, SPEED, SPEED) # Set velocity towards bottom right

# Called when the node enters the scene tree for the first time.
func _ready():
	time_left_snowball = max_time_snowball

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.GamePaused == true:
		return
		
	_velocity = _velocity.normalized() * SPEED * delta # Scale velocity by delta time
	translate(_velocity) # Move the snowball
	
	time_left_snowball -= delta
	if time_left_snowball < 0:
		queue_free()

# Set the velocity of the snowball
func set_velocity(velocity: Vector3):
	_velocity = velocity
