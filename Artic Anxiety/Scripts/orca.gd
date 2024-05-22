extends CharacterBody3D

@onready var anim_tree = $AnimationTree
@onready var twist_pivot := $Twistpivot
@onready var pitch_pivot := $Twistpivot/PitchPivot

const SPEED = 8.0
const JUMP_VELOCITY = 6.0
var twist_input := 0.0
var pitch_input := 0.0


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func _physics_process(delta):
	
	var direction = Vector3.ZERO
	var target_velocity = Vector3.ZERO
	var speed = 14
	if Input.is_action_pressed("swim_up"):
		direction.x -= 1
	if Input.is_action_pressed("swim_down"):
		direction.x += 1
	if Input.is_action_pressed("swim_right"):
		direction.z += 1
	if Input.is_action_pressed("swim_left"):
		direction.z -= 1
	
		# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	target_velocity.y = velocity.y
	
	var player_position = position
	
	velocity = target_velocity
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	var input_dir = Input.get_vector("swim_up", "swim_down", "swim_left", "swim_right")
	
	anim_tree.set("parameters/conditions/idle", input_dir == Vector2.ZERO || input_dir != Vector2.ZERO )
	anim_tree.set("parameters/conditions/jump", input_dir == Vector2.ZERO || input_dir != Vector2.ZERO && position.y > 0.5)
	anim_tree.set("parameters/conditions/left", Input.is_action_just_pressed("swim_left"))
	anim_tree.set("parameters/conditions/right", Input.is_action_just_pressed("swim_right"))
	
	move_and_slide()
	
	
