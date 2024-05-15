extends CharacterBody3D

@onready var anim_tree = $AnimationTree
@onready var anim_player = $AnimationPlayer

const SPEED = 8.0
const JUMP_VELOCITY = 6.0
const LERP_VAL = .15

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $Twistpivot
@onready var pitch_pivot := $Twistpivot/PitchPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_forward", "move_backward", "move_left", "move_right")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		
	move_and_slide()


	anim_tree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor())
	anim_tree.set("parameters/conditions/BeginnenGlijden", input_dir != Vector2.ZERO && is_on_floor())
	anim_tree.set("parameters/conditions/Stoppen_Glijden", input_dir != Vector2.ZERO && is_on_floor())
	anim_tree.set("parameters/conditions/idle_jump", input_dir == Vector2.ZERO && !is_on_floor())
	anim_tree.set("parameters/conditions/glijden_jump", input_dir != Vector2.ZERO && !is_on_floor())
	
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, 0.5) 
	twist_input = 0.0
	pitch_input = 0.0

	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			
	var cameracords = cameraToPlayer(get_viewport().get_mouse_position())
			
			
	print("Viewport cords: ", cameracords)
	var player_position = position
	print("Player position: ", player_position)
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
			
func cameraToPlayer(camera_position: Vector2) -> Vector2:
		# Define the size of the camera viewport
		var camera_size = Vector2(960, 585)
		# Define the size of the player map
		var player_map_size = Vector2(100, 60)
		# Calculate the scale factor for the translation
		var scale_factor = player_map_size / camera_size
		# Translate camera coordinates to player coordinates
		var player_position = camera_position * scale_factor
		
		player_position.x -= 9
		player_position.y -= 4
		
		var pX = player_position.x
		player_position.x = player_position.y
		player_position.y = pX
		return player_position
