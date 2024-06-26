extends Control

# Packed scenes
var snowBallScene = preload("res://Scenes/Game/Abilities/Snowball.tscn")
var rocketScene = preload("res://Scenes/Game/Abilities/Rocket_Laucher_Rocket.tscn")
var playerScene = preload("res://Scenes/Game/Player.tscn")
var deadScene = preload("res://Scenes/Menus/DeadMenu.tscn")
var victoryScene = preload("res://Scenes/Menus/VictoryMenu.tscn")

@onready var victory_scene = $VictoryScene
@onready var victory_pov = $VictoryScene/VictoryPOV
@onready var lose = $Startup/Lose
@onready var win = $Startup/win

func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameManager.CreatePlayers == true:
		var index = 0
		for i in GameManager.Players:
			var currentPlayer = playerScene.instantiate()
			currentPlayer.name = str(GameManager.Players[i].id)
			currentPlayer.SetID(GameManager.Players[i].id)
			add_child(currentPlayer)
			for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
				if spawn.name == str(index):
					currentPlayer.global_position = spawn.global_position
			index += 1
		GameManager.CreatePlayers = false
		GameManager.GameIsRunning = true
		GameManager.GameIsEnding = false
		GameManager.GameIsFinished = false
		
	if GameManager.GameIsFinished:
		DeleteUi()
		GameManager.GameIsFinished = false
		
	if GameManager.GameIsEnding:
		if GameManager.GameWon:
			SetVictoryScene()
		if GameManager.GameLost:
			SetDeadScene()
		
		

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
	
func SetDeadScene():
	$Startup/Backgroundmusic.stop()
	lose.play()
	$EndScene/CameraDeath.current = true
	$EndScene.add_child(deadScene.instantiate())
	GameManager.GameIsFinished = true
	GameManager.GameIsEnding = false
	GameManager.GameIsRunning = false
	
func DeleteUi():
	$PlayerUi.remove_child($PlayerUi/UserInterface)
	
func SetVictoryScene():
	$Startup/Backgroundmusic.stop()
	win.play()
	victory_scene.show()
	victory_pov.current = true
	$VictoryScene.add_child(victoryScene.instantiate())
	GameManager.GameIsFinished = true
	GameManager.GameIsEnding = false
	GameManager.GameIsRunning = false
