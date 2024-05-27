extends Node3D

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
var WaterTile = preload("res://Scenes/Game/Tiles/Water/WaterTile.tscn")
var SeaBottomTile = preload("res://Scenes/Game/Tiles/Ground/SeaBottomTile.tscn")
var BrokenIceTile = preload("res://Scenes/Game/Tiles/Level/BrokenIceTile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_map()
	#load_water()
	load_sea_bottom()
	   # For the Sea Bottom tiles
	

	
	

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

func load_water():
	var x = -20
	var y = -20
	for i in range(70):
		for z in range(90):
			var instance = WaterTile.instantiate() as Node3D
			instance.position = Vector3(x, -0.5, y)
			add_child_deferred(instance)
			y += 150
		y = -20
		x += 150
		
func load_sea_bottom():
	var x = -20
	var y = -20
	for i in range(70):
		for z in range(90):
			var instance = SeaBottomTile.instantiate() as Node3D
			instance.position = Vector3(x, -5, y)
			add_child_deferred(instance)
			y += 2
		y = -20
		x += 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
