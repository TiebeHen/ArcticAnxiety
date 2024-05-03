extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 150

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $Twistpivot
@onready var pitch_pivot := $Twistpivot/PitchPivot

var target_velocity = Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction.x -= 1
	if Input.is_action_pressed("move_backward"):
		direction.x += 1
	if Input.is_action_pressed("move_right"):
		direction.z -= 1
	if Input.is_action_pressed("move_left"):
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.y += 1

	if direction != Vector3.ZERO:
		if is_on_floor():
			direction = direction.normalized()

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	target_velocity.y = direction.y * 10 

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()


	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)

	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, 0.5) 
	twist_input = 0.0
	pitch_input = 0.0
	
	
	
	
