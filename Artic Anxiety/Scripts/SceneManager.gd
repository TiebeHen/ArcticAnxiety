extends Control

# Packed scenes
var snowBallScene = preload("res://Scenes/Game/Abilities/Snowball.tscn")
var rocketScene = preload("res://Scenes/Game/Abilities/Rocket_Laucher_Rocket.tscn")
var playerScene = preload("res://Scenes/Game/Player.tscn")

func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameManager.StartConnection == true:
		var index = 0
		for i in GameManager.Players:
			var currentPlayer = playerScene.instantiate()
			print(str(GameManager.Players[i].id))
			print(str(GameManager.Players[i].name))
			currentPlayer.name = str(GameManager.Players[i].id)
			add_child(currentPlayer)
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
				print(spawn.name)
				print(str(index))
				if spawn.name == str(index):
					print("created player")
					currentPlayer.global_position = spawn.global_position
					print(currentPlayer.global_position)
			index += 1
		GameManager.StartConnection = false
		GameManager.Connecting = true
		GameManager.GamePaused = false


func RPG(nodi, positionS, velocity, targetPosition):
	# Instantiate the rocket
	var instance = rocketScene.instantiate()
	instance.position = positionS
	instance.set_target_position(targetPosition)
	instance.set_velocity(velocity)
	nodi.add_child(instance)

func throw_snowball(nodi, _position, velocity):
	var instance = snowBallScene.instantiate()
	instance.position = _position
	instance.set_velocity(velocity)
	nodi.add_child(instance)
