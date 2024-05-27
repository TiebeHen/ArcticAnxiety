extends Node3D

class_name ClassTile

var instance: Node3D
var id: String

func _init(_id: String, _position: Vector3 = Vector3(), _instance: Node3D = null):
	id = _id
	instance = _instance
	position = _position
	if _instance != null:
		position = _instance.position

func get_instance() -> Node3D:
	return instance

func set_instance(_instance: Node3D) -> void:
	instance = _instance

func get_id() -> String:
	return id

func set_id(_id: String) -> void:
	id = _id

func print_info() -> String:
	if instance != null:
		return "ID: " + id + " Pos: " + str(instance.position)
	else:
		return "ID: " + id + " Pos: Null"
