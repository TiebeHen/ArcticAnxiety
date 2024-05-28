extends CharacterBody3D

@onready var anim_tree = $AnimationTree
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
var speed = 10
var motion = Vector3.ZERO
var player = null
var orcaLoc
var target_velocity = Vector3.ZERO

#for random movement
const MOVE_INTERVAL = 2.0
var move_timer = 0.0
var random_target = Vector3.ZERO
var last_direction = Vector3.FORWARD


#Called when the node enters the scene tree for the first time.
func _ready():
	if player != null:
		player = get_node(player_path)
		if player.position.y > 0:
			set_random_target()

func _process(delta):
	var next_nav_point = null  # Declare next_nav_point outside of the if block
	
	if player != null:
		if player.position.y < 0:
			speed = 30
			velocity = Vector3.ZERO

		# Navigation
		nav_agent.set_target_position(player.global_transform.origin)
		
		next_nav_point = nav_agent.get_next_path_position()  # Assign next_nav_point inside the if block
		
	if next_nav_point != null:  # Check next_nav_point outside of the if block
		velocity = (next_nav_point - global_transform.origin).normalized() * speed
		
		# Check if the direction vector is aligned with the up vector
		var new_direction = (next_nav_point - global_transform.origin).normalized()
		if abs(new_direction.dot(Vector3.UP)) > 0.99:
			# Use a different up vector to avoid alignment issues
			var alternative_up = Vector3(0, 0, 1) if new_direction.y > 0 else Vector3(0, 0, -1)
			look_at(next_nav_point, alternative_up)
		else:
			look_at(next_nav_point, Vector3.UP)
		
	move_and_slide()

		
	move_timer -= delta
	if move_timer <= 0:
		set_random_target()
		move_timer = MOVE_INTERVAL

	nav_agent.set_target_position(random_target)
	next_nav_point = nav_agent.get_next_path_position()

	if next_nav_point != null:
		var new_direction = (next_nav_point - global_transform.origin).normalized()
		velocity = new_direction * speed

	# Check if the direction vector is aligned with the up vector
		if abs(new_direction.dot(Vector3.UP)) > 0.99:
		# Use a different up vector to avoid alignment issues
			var alternative_up = Vector3(0, 0, 1) if new_direction.y > 0 else Vector3(0, 0, -1)
			look_at(next_nav_point, alternative_up)
		else:
			look_at(next_nav_point, Vector3.UP)
		
		last_direction = new_direction
		move_and_slide()

		
func set_random_target():
	var confined_area_min = Vector3(0, 0, 0) # Minimum corner of the confined space
	var confined_area_max = Vector3(150, 0, 150)   # Maximum corner of the confined space
	random_target = Vector3(
		confined_area_min.x + randi() % int(confined_area_max.x - confined_area_min.x),
		0, # Assuming movement is confined to the XZ plane
		confined_area_min.z + randi() % int(confined_area_max.z - confined_area_min.z))
		
#func check_turn_angle(old_direction: Vector3, new_direction: Vector3):
	#var dot_product = old_direction.dot(new_direction)
	#var angle = acos(dot_product)

	#if angle > PI / 2:
		#var cross_product = old_direction.cross(new_direction)
		#if cross_product.y > 0:
			#anim_tree.set("parameters/conditions/right", true)
		#else:
			#anim_tree.set("parameters/conditions/left", true)

func SetPlayerPos(pos: Vector3):
	player = pos
