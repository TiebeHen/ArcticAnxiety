extends CharacterBody3D

@onready var anim_tree = $AnimationTree
@onready var nav_agent = $NavigationAgent3D
var speed = 10
var motion = Vector3.ZERO
var orcaLoc
var target_velocity = Vector3.ZERO

var targetFoundToEat = false
var target_position = Vector3.ZERO  # Variable to store the target position
var stopping_distance = 7.0  # Distance within which the orca should stop moving
var time_to_reach_target = 1.2 # Reach the target in set amount of seconds

# For random movement
const MOVE_INTERVAL = 2.0
var move_timer = 0.0
var random_target = Vector3.ZERO
var last_direction = Vector3.FORWARD

# Called when the node enters the scene tree for the first time.
func _ready():
	if targetFoundToEat:
		set_random_target()

func _process(delta):
	if GameManager.GamePaused == true:
		return
		
	var next_nav_point = null  # Declare next_nav_point outside of the if block

	if targetFoundToEat:
		# Calculate distance to target
		var distance_to_target = global_transform.origin.distance_to(target_position)
		
		# Check if the orca is close enough to the target position
		if distance_to_target <= stopping_distance:
			velocity = Vector3.ZERO  # Stop the orca
		else:
			# Adjust speed to ensure it reaches the target in 3 seconds
			# We use a function to have a higher speed initially and slow down as it approaches the target
			var t = min(1, delta / time_to_reach_target)  # Ensure t is a fraction of the total time (3 seconds)
			speed = max(10, distance_to_target / (time_to_reach_target - t))  # Ensure speed is at least 10 units per second
			
			# Navigation
			nav_agent.set_target_position(target_position)
			next_nav_point = nav_agent.get_next_path_position()  # Assign next_nav_point inside the if block

		# Call look_at only when actively navigating
		if next_nav_point != null:
			var new_direction = (next_nav_point - global_transform.origin).normalized()
			if abs(new_direction.dot(Vector3.UP)) > 0.99:
				# Use a different up vector to avoid alignment issues
				var alternative_up = Vector3(0, 0, 1) if new_direction.y > 0 else Vector3(0, 0, -1)
				look_at(next_nav_point, alternative_up)
			else:
				look_at(next_nav_point, Vector3.UP)

		# Move and slide logic
		if next_nav_point != null:
			velocity = (next_nav_point - global_transform.origin).normalized() * speed
			move_and_slide()

	else:
		# Random movement logic if target is not found
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

func SetTargetPos(pos: Vector3):
	target_position = pos
	targetFoundToEat = true
