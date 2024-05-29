extends Control

# Static list to hold player info
var maxPlayersPerLobby = 2
var Players = {}
var GameJustStarted = true
var GamePaused = true
var fullscreen = false

var GameFinished = false
var CloseServer = false

var StartConnection = false
var Connecting = false
var Connected = false
var ConnectionEnded = false

var IsThisAServer = false

var ThisPlayerID = -1

var AmountOfActivePlayers = 99

var DiedPlayerID = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	CloseServer = false
	if fullscreen == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameJustStarted == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			
	if GameFinished == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func check_players():
	var howManyPlayers = Players.size()
	var howManyAlive = howManyPlayers
	for p in Players.keys():
		var player = Players[p]
		if !player["is_alive"]:
			howManyAlive -= 1
	if howManyAlive == 0:
		print("game can end, only 1 survivor")
		pass

func PlayerHasDied():
	AmountOfActivePlayers -= 1
	
func CanGameEnd():
	if AmountOfActivePlayers == 1:
		return true
	return false
	
func KillPlayer(id: int):
	AmountOfActivePlayers -= 1
	var player = Players[id]
	if player["is_alive"]:
		player["is_alive"] = false
		print("killed")
		print(id)
		print(player["is_alive"])
		print(CanGameEnd())
		DiedPlayerID = id
