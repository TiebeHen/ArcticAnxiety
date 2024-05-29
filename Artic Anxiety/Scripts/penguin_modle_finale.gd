extends CharacterBody3D

@export var victory_camera : Camera3D
@onready var anim_tree = $AnimationTree
@onready var anim_tree_vic = $VictoryPOV/AnimationTree
@onready var jump = $jump_sfx
@onready var victoryPOV = $VictoryPOV

const SPEED = 8.0
const JUMP_VELOCITY = 12.0
const LERP_VAL = .15
static var player_position

var abilityNr = 1


var GameNode = load("res://Scripts/SceneManager.gd")
static var victory = false

var isUnderwater := false
var isAlive := true
var maxtimeLeftUntilDeathScreen = 3
var timeLeftUntilDeathScreen = maxtimeLeftUntilDeathScreen

#voor de timer om door de tile te vallen
var maxTime = 5
var timeLeft = maxTime

#voor de timer voor de ability
var maxTimeAbility = 6
var timeLeftAbility = 0
#voor de timer voor de Jesus
var  maxTimeJesus = 3
var timeLeftJesus = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 4

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0


@onready var twist_pivot := $Twistpivot
@onready var pitch_pivot := $Twistpivot/PitchPivot
@onready var RPG = $rpgBaseglb

var syncPos = Vector3(0,0,0)
var syncRot = 0

func _ready() -> void:
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	GameNode.new()
	#RPG.visible = false

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if GameManager.GamePaused == true:
			return
			
		if isAlive == false:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_file("res://Scenes/Game/DeadScene.tscn")
			return
			
		if isUnderwater == true:
			timeLeftUntilDeathScreen -= delta
			
		if(timeLeftUntilDeathScreen < 0):
			isAlive = false
			EndGame.rpc()
			
		if (Input.is_action_just_pressed("victory")):
			on_player_wins()
			
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle jump.
		if (Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("jump")) and is_on_floor():
			#if RPG.visible == false:
				velocity.y = JUMP_VELOCITY

		var direction = Vector3.ZERO
		var target_velocity = Vector3.ZERO
		var speed = 14
		if (victory == false and isUnderwater == false):
			#if RPG.visible == false:
				if Input.is_action_pressed("move_forward"):
					direction.x -= 1
				if Input.is_action_pressed("move_backward"):
					direction.x += 1
				if Input.is_action_pressed("move_right"):
					direction.z += 1
				if Input.is_action_pressed("move_left"):
					direction.z -= 1
				if Input.is_action_just_pressed("jump"):
					jump.play()
			
		if direction != Vector3.ZERO:
			direction = direction.normalized()

		# Ground Velocity
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
		target_velocity.y = velocity.y
		
		velocity = target_velocity
		
		
		var input_dir = Input.get_vector("move_forward", "move_backward", "move_left", "move_right")

		if isUnderwater == false:
			anim_tree.set("parameters/conditions/idle", input_dir == Vector2.ZERO && is_on_floor())
			anim_tree.set("parameters/conditions/beginGliding", input_dir != Vector2.ZERO && is_on_floor())
			anim_tree.set("parameters/conditions/stopGliding", input_dir != Vector2.ZERO && is_on_floor())
			anim_tree.set("parameters/conditions/idleJump", input_dir == Vector2.ZERO && !is_on_floor())
			anim_tree.set("parameters/conditions/glideJump", input_dir != Vector2.ZERO && !is_on_floor())
			anim_tree.set("parameters/conditions/throwSnow", Input.is_action_just_pressed("click_throw"))
			anim_tree.set("parameters/conditions/rpgHold", Input.is_action_just_pressed("Ability1"))
		
		move_and_slide()
		
			#twist_pivot.rotate_y(twist_input)
		pitch_pivot.rotate_x(pitch_input)
		pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, 0.5) 
		twist_input = 0.0
		pitch_input = 0.0

				
		var camerarecords
		if get_viewport() != null:
			camerarecords = cameraToPlayer(get_viewport().get_mouse_position())
		
		
		
		if Input.is_action_just_pressed("Ability1"):
			abilityNr = 1
			RPG.visible = false #making rpg invisible
		if Input.is_action_just_pressed("Ability2"):
			abilityNr = 2
			RPG.visible = false #making rpg invisible
		if Input.is_action_just_pressed("Ability3"):
			abilityNr = 3
			RPG.visible = true #making rpg visible
		
		timeLeftJesus -= delta
		timeLeftAbility -= delta
		#timeLeftAbility  maxTimeAbility
		if Input.is_action_pressed("click_throw") and isUnderwater == false:
			if (victory == false):
				if timeLeftAbility <= 3:
					if abilityNr == 1: #Sneeuwbal ability
						fireSnowBall.rpc(camerarecords)

						timeLeftAbility = maxTimeAbility
						
					if timeLeftAbility <= 0:
						if abilityNr == 2: #Jesus ability
							position.y += 0.5
							gravity = 0
							timeLeftAbility = maxTimeAbility
							timeLeftJesus = maxTimeJesus
							
					if abilityNr == 3: #Rocket ability
						shootRPG.rpc(camerarecords)
						RPG.visible = true
						timeLeftAbility = maxTimeAbility
					#LevelNode.DeleteTileWRadius(Vector3(camerarecords.x, 0, camerarecords.y),5)
			
		if timeLeftJesus < 0:
			gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 4
			
			
			
				
				
		
		#print(get_viewport().size)
				
		#print("Viewport cords: ", camerarecords)
		player_position = position
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
			if (victory == false):
				#$"../Level1".delete_tile_at_position(player_position)
				pass
				
		#player die dood gaat voor de cam
		if player_position.y <= -1:
			if (victory == false):
				on_player_falling_in_water()
	else:
		pass
		#global_position = global_position.lerp(syncPos, .5)
		#rotation_degrees = lerp(rotation_degrees, syncRot, .5)
	
func cameraToPlayer(camera_position: Vector2) -> Vector2:
		# Define the size of the camera viewport
		#var camera_size = Vector2(960, 585)
		var camera_size = Vector2(get_viewport().size.x - 192,get_viewport().size.y - 63 )
		# Define the size of the player map
		var player_map_size = Vector2(100, 60)
		# Calculate the scale factor for the translation
		var scale_factor = player_map_size / camera_size
		# Translate camera coordinates to player coordinates
		var player_position2 = camera_position * scale_factor
		
		player_position2.x -= 9
		player_position2.y -= 4
		
		var pX = player_position2.x
		player_position2.x = player_position2.y
		player_position2.y = pX
		return player_position2

#func on_player_wins():
	#$VictoryPOV.current = true
	#victory = true
	#anim_tree.set("parameters/conditions/Victory", is_on_floor)
	#anim_tree_vic.set("parameters/conditions/zoom", true)
	#get_tree().change_scene_to_file("res://Scenes/Menus/VictoryMenu.tscn")
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func add_child_deferred(node):
	call_deferred("add_child", node)

func remove_child_deferred(node):
	call_deferred("remove_child", node)
		
func on_player_wins() -> void:
	if get_tree() == null:
		push_error("Scene tree is null, cannot change scene.")
		return
		
	victory = true
	if victoryPOV:
		victoryPOV.current = true
		anim_tree_vic.set("parameters/conditions/zoom", true)
	if anim_tree:
		anim_tree.set("parameters/conditions/Victory", true)
			
func _on_victory_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/VictoryMenu.tscn")

func on_player_falling_in_water():
	isUnderwater = true
	$"../orca".SetTargetPos(position)
	
func GetPlayerPos():
	return player_position
	
@rpc("any_peer","call_local")
func fireSnowBall(_camerarecords: Vector2):
	if(_camerarecords != null):
		$"..".throw_snowball(get_parent().get_node("Abilities"), position, Vector3(_camerarecords.x - position.x, 0, _camerarecords.y - position.z))
	else:
		print("Can't find camerarecords")
		print(get_viewport())
		
@rpc("any_peer","call_local")
func shootRPG(_camerarecords: Vector2):
	if(_camerarecords != null):
		$"..".RPG(get_parent().get_node("Abilities"), position, Vector3(_camerarecords.x - position.x, 0, _camerarecords.y - position.z),Vector3(_camerarecords.x, 0, _camerarecords.y))
	else:
		print("Can't find camerarecords")
		print(get_viewport())
		
@rpc("any_peer","call_local")
func EndGame():
	GameManager.GameFinished = true
	GameManager.GamePaused = true
	
func IsAlive() -> bool:
	return isAlive
