extends Node3D

# Constants and variables
const SPEED = 25.0
const MAX_TIME_ROCKET = 4.0
var target_position = Vector3()
var _velocity = Vector3(SPEED, 0, SPEED)
var level = null
var hit_target = false
var time_left_rocket = MAX_TIME_ROCKET
var explode: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	level = Level1.new()
	hit_target = false
	time_left_rocket = MAX_TIME_ROCKET

# Set the velocity of the rocket
func set_velocity(velocity: Vector3):
	_velocity = velocity

# Set the target position of the rocket
func set_target_position(_target_pos: Vector3):
	_target_pos.y += 0.35
	target_position = _target_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.GamePaused == true:
		return
		
	var direction = (target_position - position).normalized()
	position += direction * SPEED * delta
	time_left_rocket -= delta
	
	look_at(target_position, Vector3.UP)
	
	if explode == false:
	# Check if the rocket is close enough to the target position to be considered as "hit"
		if position.distance_to(target_position) < SPEED * delta:
			target_position.y = 0
			level.delete_tile_with_radius(target_position, 5)
			hit_target = true
			explode = true
			_velocity = Vector3.ZERO
		
			if time_left_rocket < 0:
				queue_free()

# Return the target position if the target is hit, otherwise return Vector3.ZERO
func target_pos() -> Vector3:
	return target_position
		
func can_explode() -> bool:
	return explode
	
func remove_rocket():
	queue_free()
