extends Control

# Static list to hold player info
var maxPlayersPerLobby = 2
var Players = {}

var Fullscreen = false
var IsThisAServer = false

var Connected = false
var CreatePlayers = false
var GameIsRunning = false
var GameIsEnding = false
var GameIsFinished = false


var GameLost = false
var GameWon = false

var PlayerID = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	if Fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	pass
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			
	if GameIsFinished == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	 #if GameIsEnding:
	#	check_players()
	
func check_players():
	var howManyPlayers = Players.size()
	var howManyAlive = howManyPlayers
	#for p in Players:
		#if p["is_alive"] == false:
		#	howManyAlive -= 1
	if howManyAlive == 1:
		print("game can end, only 1 survivor")
		pass
