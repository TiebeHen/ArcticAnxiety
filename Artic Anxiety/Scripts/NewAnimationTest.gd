extends CharacterBody3D

@onready var anim_tree = $AnimationTree

const SPEED = 8.0
const JUMP_VELOCITY = 6.0
const LERP_VAL = .15

var LevelScript = load("res://Scripts/Level.cs")
var LevelNode = LevelScript.new()


#voor de timer
var maxTime = 5
var timeLeft = maxTime


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 
var SnowballScene = preload("res://Scenes/Game/Abilities/Snowball.tscn")


var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := $Twistpivot
@onready var pitch_pivot := $Twistpivot/PitchPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if (Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("jump")) and is_on_floor():
		velocity.y = JUMP_VELOCITY


#OLd Movemont
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
	#	velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
	#	velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
	#else:
	#	velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
	#	velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
	var direction = Vector3.ZERO
	var target_velocity = Vector3.ZERO
	var speed = 14
	var movement
	if Input.is_action_pressed("move_forward"):
		direction.x -= 1
		movement = 1
	if Input.is_action_pressed("move_backward"):
		direction.x += 1
		movement = 1
	if Input.is_action_pressed("move_right"):
		direction.z += 1
		movement = 1
	if Input.is_action_pressed("move_left"):
		direction.z -= 1
		movement = 1
		
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	target_velocity.y = velocity.y
	
	velocity = target_velocity
	
	
	var input_dir = Input.get_vector("move_forward", "move_backward", "move_left", "move_right")

	anim_tree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor())
	anim_tree.set("parameters/conditions/BeginnenGlijden", input_dir != Vector2.ZERO && is_on_floor())
	anim_tree.set("parameters/conditions/Stoppen_Glijden", input_dir != Vector2.ZERO && is_on_floor())
	anim_tree.set("parameters/conditions/idle_jump", input_dir == Vector2.ZERO && !is_on_floor())
	anim_tree.set("parameters/conditions/Glijden_Jump", input_dir != Vector2.ZERO && !is_on_floor())

	move_and_slide()
	
	#twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, 0.5) 
	twist_input = 0.0
	pitch_input = 0.0

	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			
	
			
			
	if Input.is_action_just_pressed("click_throw"):
		print("gooi sneeuwbal")
		#var snowball_instance = SnowballScene.instantiate()
		#snowball_instance.position = Vector3(position.x, 1.5, position.z)
		#add_child_deferred(snowball_instance)
		
			
			
			
	var camerarecords = cameraToPlayer(get_viewport().get_mouse_position())
	#print(get_viewport().size)
			
	#print("Viewport cords: ", camerarecords)
	var player_position = position
	#print("Player position: ", player_position)
	look_at(Vector3(camerarecords.x, 0, camerarecords.y), Vector3(0, 1, 0)) 
	
	#stilstaan = aan dood gaan
	if direction != Vector3.ZERO:
		timeLeft = maxTime	
	
	#timer 
	if timeLeft > 0:
		timeLeft -= delta
		#print(timeLeft)
	else:
		timeLeft = 0
		timeLeft = maxTime
		
		LevelNode.DeleteTileNearPlayer(player_position)
		
		
		#var test = LevelNode.PrintTest() # werkt ook
		#print(test)
		#print(LevelNode.PrintTest()) # werkt
		
		
		
#func _unhandled_input(event: InputEvent) -> void:
#	if event is InputEventMouseMotion:
#		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#			twist_input = -event.relative.x * mouse_sensitivity
#			pitch_input = -event.relative.y * mouse_sensitivity
			
func cameraToPlayer(camera_position: Vector2) -> Vector2:
		# Define the size of the camera viewport
		#var camera_size = Vector2(960, 585)
		var camera_size = Vector2(get_viewport().size.x - 192,get_viewport().size.y - 63 )
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



func add_child_deferred(node):
	call_deferred("add_child", node)

func remove_child_deferred(node):
	call_deferred("remove_child", node)
