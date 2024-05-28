extends Control

#@export var Address = "204.48.28.159"
@export var Address = "127.0.0.1"
@export var port = 8910
var peer

static var HasCreatedLobby := false
var IsLobbyFull := false
var maxPlayerCount = GameManager.maxPlayersPerLobby
var currentPlayerCount := 0

# TEMP BUTTON FOR QUICK DEBUGGING - NO MULTIPLAYER
func _on_button_test_play_pressed():
	GameManager.GamePaused = false
	hide()

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		hostGame()
		
	$ServerBrowser.joinGame.connect(JoinByIP)
		

func _process(_delta):
	pass

# this get called on the server and clients
func peer_connected(id):
	print("Player " + str(id) + " is connected")
	if multiplayer.is_server():
		currentPlayerCount += 1
		$MultiplayerMenuOverlay/LobbiesText/OpenLobbyCurrentPlayers.show()
		$MultiplayerMenuOverlay/LobbiesText/OpenLobbyCurrentPlayers.text = str(currentPlayerCount)
		if currentPlayerCount == maxPlayerCount:
			IsLobbyFull = true
			print("lobby is full")
		if IsLobbyFull == true:
			$MultiplayerMenuOverlay/Start.show()
			
	
# this get called on the server and clients
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	GameManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
			
# called only from clients
func connected_to_server():
	print("connected To Sever!")
	print("player " + str(currentPlayerCount) + " is connected to server")
	SendPlayerInformation.rpc_id(1, "EnemyPlayer", multiplayer.get_unique_id())
	$MultiplayerMenuOverlay/LobbyNameInput.hide()
	$MultiplayerMenuOverlay/Create.hide()

# called only from clients
func connection_failed():
	print("Couldnt Connect")

@rpc("any_peer")
func SendPlayerInformation(_name, _id):
	if !GameManager.Players.has(_id):
		GameManager.Players[_id] ={
			"name" : _name,
			"id" : _id,
			"is_alive" : true
		}
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			SendPlayerInformation.rpc(GameManager.Players[i].name, i)

@rpc("any_peer","call_local")
func StartGame():
	if GameManager.Players.size() == maxPlayerCount:
		GameManager.StartConnection = true
		hide()
	
func hostGame():		
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, maxPlayerCount)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players!")
	HasCreatedLobby = true
	
	$MultiplayerMenuOverlay/LobbyNameInput.hide()
	$MultiplayerMenuOverlay/Create.hide()
	$TestJoin.hide()
	#$TestLeave.show()
	GameManager.IsThisAServer = true
	currentPlayerCount += 1
	$MultiplayerMenuOverlay/LobbiesText/OpenLobbyCurrentPlayers.show()
	$MultiplayerMenuOverlay/LobbiesText/OpenLobbyCurrentPlayers.text = str(currentPlayerCount)
	
	$MultiplayerMenuOverlay/LobbiesText/OpenLobbyText.text = $MultiplayerMenuOverlay/LobbyNameInput.text
	$MultiplayerMenuOverlay/LobbiesText/OpenLobbyText.show()
	$MultiplayerMenuOverlay/LobbiesText/OpenLobbyIPAdress.text = Address
	$MultiplayerMenuOverlay/LobbiesText/OpenLobbyIPAdress.show()
	$MultiplayerMenuOverlay/LobbiesText/OpenLobbyMaxPlayers.text = " / " + str(maxPlayerCount)
	$MultiplayerMenuOverlay/LobbiesText/OpenLobbyMaxPlayers.show()
	
func _on_button_multiplayer_pressed():
	$MultiplayerMenuOverlay.show()
	$StartMenuOverlay.hide()
	
	# Show this Button
	$Back.show()
	
	if HasCreatedLobby == false:
		$MultiplayerMenuOverlay/LobbyNameInput.show()
		$MultiplayerMenuOverlay/LobbyNameInput.text = ""
		$MultiplayerMenuOverlay/Create.show()
		#$TestJoin.show()
	else:
		$MultiplayerMenuOverlay/Start.show()
	
			

func _on_button_settings_pressed():
	$StartMenuOverlay.hide()
	$SettingsMenuOverlay.show()
	$TestJoin.hide()
	
	# Show this Button
	$Back.show()

func _on_button_exit_pressed():
	get_tree().quit()
	# endregion

func _on_button_create_lobby_pressed():
	hostGame()
	SendPlayerInformation("Player 0", multiplayer.get_unique_id())
	$ServerBrowser.setUpBroadCast($MultiplayerMenuOverlay/LobbyNameInput.text + "'s server")
	
func _on_button_test_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)	
	
	if HasCreatedLobby == false:
		$MultiplayerMenuOverlay/LobbyNameInput.hide()
		$MultiplayerMenuOverlay/Create.hide()
		$TestJoin.hide()
		
func JoinByIP(ip):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)

func _on_button_start_lobby_pressed():
	StartGame.rpc()
	
func _on_button_test_leave_pressed():
	pass # Replace with function body.
	
# Back Button always goes to StartMenuOverlay
func _on_button_back_pressed():
	$SettingsMenuOverlay.hide()
	$MultiplayerMenuOverlay.hide()
	$StartMenuOverlay.show()
	
	# Hide this Button
	$Back.hide()
	
	# Cancel lobby

func _on_button_multiplayer_mouse_entered():
	$StartMenuOverlay/Multiplayer/TextureMultiplayerHover.show()
	$StartMenuOverlay/Multiplayer/LineEditMultiplayerHover.show()

func _on_button_multiplayer_mouse_exited():
	$StartMenuOverlay/Multiplayer/TextureMultiplayerHover.hide()
	$StartMenuOverlay/Multiplayer/LineEditMultiplayerHover.hide()

func _on_button_settings_mouse_entered():
	$StartMenuOverlay/Settings/TextureSettingsHover.show()
	$StartMenuOverlay/Settings/LineEditSettingsHover.show()

func _on_button_settings_mouse_exited():
	$StartMenuOverlay/Settings/TextureSettingsHover.hide()
	$StartMenuOverlay/Settings/LineEditSettingsHover.hide()

func _on_button_exit_mouse_entered():
	$StartMenuOverlay/Exit/TextureExitHover.show()
	$StartMenuOverlay/Exit/LineEditExitHover.show()

func _on_button_exit_mouse_exited():
	$StartMenuOverlay/Exit/TextureExitHover.hide()
	$StartMenuOverlay/Exit/LineEditExitHover.hide()
	
func _on_button_create_lobby_mouse_entered():
	$MultiplayerMenuOverlay/Create/TextureCreateLobbyHover.show()
	$MultiplayerMenuOverlay/Create/LineEditCreateLobbyHover.show()

func _on_button_create_lobby_mouse_exited():
	$MultiplayerMenuOverlay/Create/TextureCreateLobbyHover.hide()
	$MultiplayerMenuOverlay/Create/LineEditCreateLobbyHover.hide()

func _on_button_start_lobby_mouse_entered():
	$MultiplayerMenuOverlay/Start/TextureStartLobbyHover.show()
	$MultiplayerMenuOverlay/Start/LineEditStartLobbyHover.show()


func _on_button_start_lobby_mouse_exited():
	$MultiplayerMenuOverlay/Start/TextureStartLobbyHover.hide()
	$MultiplayerMenuOverlay/Start/LineEditStartLobbyHover.hide()

# Back Button always goes to StartMenuOverlay
func _on_button_back_mouse_entered():
	$Back/TextureBackHover.show()
	$Back/LineEditBackHover.show()

func _on_button_back_mouse_exited():
	$Back/TextureBackHover.hide()
	$Back/LineEditBackHover.hide()





