extends Control

var _has_lobby = false

# TEMP BUTTON FOR QUICK DEBUGGING - NO MULTIPLAYER
func _on_button_test_play_pressed():
	hide()

func _ready():
	pass

func _process(_delta):
	pass

func _on_button_multiplayer_pressed():
	$MultiplayerMenuOverlay.show()
	$StartMenuOverlay.hide()
	
	# Show this Button
	$Back.show()
	
	# Show buttons to create lobby again if there is no lobby
	if not _has_lobby:
		$MultiplayerMenuOverlay/LobbyNameInput.show()
		$MultiplayerMenuOverlay/LobbyNameInput.text = ""
		$MultiplayerMenuOverlay.show()

func _on_button_settings_pressed():
	$StartMenuOverlay.hide()
	$SettingsMenuOverlay.show()
	
	# Show this Button
	$Back.show()

func _on_button_exit_pressed():
	get_tree().quit()
	# endregion

func _on_button_create_lobby_pressed():
	$MultiplayerMenuOverlay/LobbyNameInput.hide()
	$MultiplayerMenuOverlay/Create.hide()
	_has_lobby = true

# Back Button always goes to StartMenuOverlay
func _on_button_back_pressed():
	$SettingsMenuOverlay.hide()
	$MultiplayerMenuOverlay.hide()
	$StartMenuOverlay.show()
	
	# Hide this Button
	$Back.hide()
	
	# Cancel lobby
	_has_lobby = false

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

# Back Button always goes to StartMenuOverlay
func _on_button_back_mouse_entered():
	$Back/TextureBackHover.show()
	$Back/LineEditBackHover.show()

func _on_button_back_mouse_exited():
	$Back/TextureBackHover.hide()
	$Back/LineEditBackHover.hide()
