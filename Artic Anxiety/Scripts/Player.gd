extends RigidBody3D

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot:= $Twistpivot
@onready var pitch_pivot := $Twistpivot/PitchPivot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var input = Input.get_action_strength("move_forward")
	#apply_central_force(input * Vector3.FORWARD * 1200.0 * delta)
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left","move_right")
	input.z = Input.get_axis("move_forward","move_backward")
	input.y = Input.get_axis("move_down", "move_up")
	
	apply_central_force(input * 1200.0 * delta)
	 
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	#$Twistpivot.rotate_y(twist_input)
	twist_pivot.rotate_y(twist_input)
	
	
	#$Twistpivot.rotation.y = clamp($Twistpivot.rotation.y,-0.2,0.2) #max twisten
	
	#$Twistpivot/PitchPivot.rotate_x(pitch_input)
	#$Twistpivot/PitchPivot.rotation.x = clamp($Twistpivot/PitchPivot.rotation.x,-0.5,0.5) #max pitchen
	
	pitch_pivot.rotate_x(pitch_input)
	
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x,-0.5,0.5) 
	
	twist_input = 0.0
	pitch_input = 0.0
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
