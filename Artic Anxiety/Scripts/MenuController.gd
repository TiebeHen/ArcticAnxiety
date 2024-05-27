extends Control

var _has_lobby = false

# TEMP BUTTON FOR QUICK DEBUGGING - NO MULTIPLAYER
func _on_button_test_play_pressed():
	hide()

func _ready():
	pass

func _process(delta):
	pass

func _on_button_multiplayer_pressed():
	get_node("StartMenuOverlay").hide()
	get_node("MultiplayerMenuOverlay").show()
	
	# Show this Button
	get_node("Back").show()
	
	# Show buttons to create lobby again if there is no lobby
	if not _has_lobby:
		get_node("MultiplayerMenuOverlay/LobbyNameInput").show()
		get_node("MultiplayerMenuOverlay/LobbyNameInput").text = ""
		get_node("MultiplayerMenuOverlay/Create").show()

func _on_button_settings_pressed():
	get_node("StartMenuOverlay").hide()
	get_node("SettingsMenuOverlay").show()
	
	# Show this Button
	get_node("Back").show()

func _on_button_exit_pressed():
	get_tree().quit()
	# endregion

func _on_button_create_lobby_pressed():
	get_node("MultiplayerMenuOverlay/LobbyNameInput").hide()
	get_node("MultiplayerMenuOverlay/Create").hide()
	_has_lobby = true

# Back Button always goes to StartMenuOverlay
func _on_button_back_pressed():
	get_node("SettingsMenuOverlay").hide()
	get_node("MultiplayerMenuOverlay").hide()
	get_node("StartMenuOverlay").show()
	
	# Hide this Button
	get_node("Back").hide()
	
	# Cancel lobby
	_has_lobby = false

func _on_button_multiplayer_mouse_entered():
	get_node("StartMenuOverlay/Multiplayer/TextureMultiplayerHover").show()
	get_node("StartMenuOverlay/Multiplayer/LineEditMultiplayerHover").show()

func _on_button_multiplayer_mouse_exited():
	get_node("StartMenuOverlay/Multiplayer/TextureMultiplayerHover").hide()
	get_node("StartMenuOverlay/Multiplayer/LineEditMultiplayerHover").hide()

func _on_button_settings_mouse_entered():
	get_node("StartMenuOverlay/Settings/TextureSettingsHover").show()
	get_node("StartMenuOverlay/Settings/LineEditSettingsHover").show()

func _on_button_settings_mouse_exited():
	get_node("StartMenuOverlay/Settings/TextureSettingsHover").hide()
	get_node("StartMenuOverlay/Settings/LineEditSettingsHover").hide()

func _on_button_exit_mouse_entered():
	get_node("StartMenuOverlay/Exit/TextureExitHover").show()
	get_node("StartMenuOverlay/Exit/LineEditExitHover").show()

func _on_button_exit_mouse_exited():
	get_node("StartMenuOverlay/Exit/TextureExitHover").hide()
	get_node("StartMenuOverlay/Exit/LineEditExitHover").hide()
	
func _on_button_create_lobby_mouse_entered():
	get_node("MultiplayerMenuOverlay/Create/TextureCreateLobbyHover").show()
	get_node("MultiplayerMenuOverlay/Create/LineEditCreateLobbyHover").show()

func _on_button_create_lobby_mouse_exited():
	get_node("MultiplayerMenuOverlay/Create/TextureCreateLobbyHover").hide()
	get_node("MultiplayerMenuOverlay/Create/LineEditCreateLobbyHover").hide()

# Back Button always goes to StartMenuOverlay
func _on_button_back_mouse_entered():
	get_node("Back/TextureBackHover").show()
	get_node("Back/LineEditBackHover").show()

func _on_button_back_mouse_exited():
	get_node("Back/TextureBackHover").hide()
	get_node("Back/LineEditBackHover").hide()
