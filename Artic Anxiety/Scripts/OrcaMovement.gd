extends CharacterBody3D

@onready var anim_tree = $AnimationTree
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
const speed = 7
var motion = Vector3.ZERO
var player = null
var orcaLoc
var target_velocity = Vector3.ZERO


#Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)

func _process(delta):
	velocity = Vector3.ZERO

	# Navigation
	nav_agent.set_target_position(player.global_transform.origin)
	
	var next_nav_point = nav_agent.get_next_path_position()
	
	if (next_nav_point != null):
		velocity = (next_nav_point - global_transform.origin).normalized() * speed
	
	
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z ),Vector3.UP)

	move_and_slide()

func SetPlayerPos(pos: Vector3):
	player = pos
