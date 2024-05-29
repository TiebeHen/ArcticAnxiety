extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_home_mouse_entered():
	get_node("Home/TextureHomeHover").show()
	get_node("Home/LineEditHomeHover").show()


func _on_button_home_mouse_exited():
	get_node("Home/TextureHomeHover").hide()
	get_node("Home/LineEditHomeHover").hide()

func _on_button_home_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game/Main.tscn")
	



func _on_button_exit_mouse_entered():
	get_node("Exit/TextureExitHover").show()
	get_node("Exit/LineEditExitHover").show()

func _on_button_exit_mouse_exited():
	get_node("Exit/TextureExitHover").hide()
	get_node("Exit/LineEditExitHover").hide()
	
func _on_button_exit_pressed():
	get_tree().quit()
