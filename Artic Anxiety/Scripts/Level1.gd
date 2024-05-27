extends Node3D

class_name Level1

var tiles = []
var ID_WATER_TILE: String = "105"
var ID_FULL_ICE_TILE: String = "49"
var ID_BROKEN_ICE_TILE: String = "48"

# This is to toggle gameplay when the player starts the game
var start_gameplay: bool = false

# For the timer of breaking tiles
var maxTimeTileBreaking = 4.0
var timeLeftTileBreaking = 4.0

# Tiles
var FullIceTile = preload("res://Scenes/Game/Tiles/Level/FullIceTile.tscn")
var BrokenIceTile = preload("res://Scenes/Game/Tiles/Level/BrokenIceTile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_map()	

func add_child_deferred(node):
	call_deferred("add_child", node)
	
func load_map():
	var filePath = "Assets/Map/Level1.txt"
	var lines = FileAccess.open(filePath, FileAccess.READ).get_as_text().split("\n")
	
	var x = 0;
	var z = 0;
	for j in range(lines.size()):
		var values = lines[j].split(',')
		for k in range(values.size()):
			var id = values[k]
			if id == ID_FULL_ICE_TILE:
				var tile = FullIceTile.instantiate() as Node3D
				tile.position = Vector3(x, 0, z)
				add_child_deferred(tile)
				tiles.append(ClassTile.new(id, tile.position, tile))
			else:
				tiles.append(ClassTile.new(ID_WATER_TILE, Vector3(x, 0, z)))
			z += 2
		z = 0
		x += 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_gameplay == true:
		
		pass
	

func startGame():
	start_gameplay = true;
	
func rpcDamageTile():
	pass
	
func rpcDeleteTile():
	pass
	
func rpcCreateIce():
	pass
	
func delete_tile_with_radius(position: int, radius: int):
	pass
	
func delete_tile_at_position(position: int):
	pass
