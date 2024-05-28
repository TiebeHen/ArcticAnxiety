extends Node3D

class_name Level1

static var tiles = []
var ID_WATER_TILE: String = "105"
var ID_FULL_ICE_TILE: String = "49"
var ID_BROKEN_ICE_TILE: String = "48"

# This is to toggle gameplay when the player starts the game
var start_gameplay: bool = true

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
		var newInstances = [] # Create a new list to hold instances to be added
		
		for t in tiles: # Iterate over a copy of instances to avoid modification during enumeration
			if t.get_id() == ID_WATER_TILE: # ID_FULL_ICE_TILE ID_WATER_TILE
				if randi() % 100000 < 3: # number between 0 and 49, 10% to change to ice
					var instance = FullIceTile.instantiate() as Node3D
					instance.position = t.get_position()
					t.set_instance(instance)
					t.set_id(ID_FULL_ICE_TILE) # Add new instance to the temporary list
					add_child(instance)

	# Add new instances to the main collection after the loop
		for newInstance in newInstances:
			tiles.append(newInstance)
		
		BreakTiles(delta)
	

func startGame():
	start_gameplay = true;
	
func rpcDamageTile():
	pass
	
func rpcDeleteTile():
	pass
	
func rpcCreateIce():
	pass
	
func delete_tile_with_radius(_position: Vector3, radius: int):
	if radius == 5:
		print("ok")
	var playerX = _position.x
	var playerZ = _position.z
	for i in tiles:
		var _pos = i.get_position()
		if sqrt(pow(_pos.x - playerX, 2) + pow(_pos.z - playerZ, 2)) <= radius:
			if i.get_id() != ID_WATER_TILE: # ID_FULL_ICE_TILE ID_WATER_TILE
				var parent = i.get_instance().get_parent()
				var children = i.get_instance().get_children()
				for child in children:
					i.get_instance().remove_child(child)
				if i.get_instance() != null:
					parent.remove_child(i.get_instance())
				i.set_id(ID_WATER_TILE)
	
func delete_tile_at_position(_position: Vector3):
	var playerX = _position.x
	var playerZ = _position.z
	for i in tiles:
		var _pos = i.get_position()
		if abs(_pos.x - playerX) <= 2 and abs(_pos.z - playerZ) <= 2:
			if i.get_id() != ID_WATER_TILE: # ID_FULL_ICE_TILE ID_WATER_TILE
				var parent = i.get_instance().get_parent()
				var children = i.get_instance().get_children()
				for child in children:
					i.get_instance().remove_child(child)
				parent.remove_child(i.get_instance())
				i.set_id(ID_WATER_TILE)

func BreakTiles(delta):
	for t in tiles: # Iterate over a copy of instances to avoid modification during enumeration
		if t.get_id() == ID_FULL_ICE_TILE: # ID_FULL_ICE_TILE ID_WATER_TILE
			if randi() % 300000 < 3:
				delete_tile_with_radius(t.get_position(), 1)
				var instance = BrokenIceTile.instantiate() as Node3D
				instance.position = t.get_position()
				t.set_instance(instance)
				t.set_id(ID_BROKEN_ICE_TILE)
				add_child(instance)
				
		if timeLeftTileBreaking < 0:
			if t.get_id() == ID_BROKEN_ICE_TILE: # ID_FULL_ICE_TILE ID_WATER_TILE
				delete_tile_with_radius(t.get_position(), 1)
				pass
			timeLeftTileBreaking = maxTimeTileBreaking
		
		timeLeftTileBreaking -= delta
