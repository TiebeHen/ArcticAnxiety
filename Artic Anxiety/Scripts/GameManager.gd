extends Control

# Static list to hold player info
var Players = {}
var GameJustStarted = true
var GamePaused = true
var fullscreen = false

var GameFinished = false

var StartConnection = false
var Connecting = false
var Connected = false
var ConnectionEnded = false

var IsThisAServer = false


# Called when the node enters the scene tree for the first time.
func _ready():
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
		
		#check_players()
	
func check_players():
	var howManyPlayers = Players.size()
	var howManyAlive = howManyPlayers
	#for p in Players:
		#if p["is_alive"] == false:
		#	howManyAlive -= 1
	if howManyAlive == 1:
		print("game can end, only 1 survivor")
		pass
