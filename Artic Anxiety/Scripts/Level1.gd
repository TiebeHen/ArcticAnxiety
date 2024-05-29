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
	
	var x = 0
	var z = 0
	for j in range(lines.size()):
		var values = lines[j].split(',')
		for k in range(values.size()):
			var id = values[k]
			if id == ID_FULL_ICE_TILE:
				var tile = FullIceTile.instantiate() as Node3D
				tile.position = Vector3(x, 0, z)
				add_child_deferred(tile)
				tiles.append(ClassTile.new(ID_FULL_ICE_TILE, tile.position, tile))
			else:
				tiles.append(ClassTile.new(ID_WATER_TILE, Vector3(x, 0, z)))
			z += 2
		z = 0
		x += 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameManager.IsThisAServer == true:
		if GameManager.GamePaused == true:
			return
	
		for tile in tiles:
			if tile.get_id() == ID_WATER_TILE:
				if randf() < 0.00005: # Adjust probability for adding ice
					check_to_create_ice(tile)
					
			if tile.get_id() == ID_FULL_ICE_TILE:
				if randf() < 0.00002: # Adjust probability for breaking ice
					check_to_break_ice(tile)
					
			if tile.get_id() == ID_BROKEN_ICE_TILE:
				if randf() < 0.0005: # Adjust probability for deleting ice
					check_to_delete_ice(tile)
	else:
		pass
		
func check_to_create_ice(tile: ClassTile):
	var instance = FullIceTile.instantiate() as Node3D
	instance.position = tile.get_position()
	tile.set_instance(instance)
	tile.set_id(ID_FULL_ICE_TILE)
	add_child(instance)
	# Call RPC to create ice on other peers
	rpc("rpc_create_ice", tile.get_position())
	
@rpc("any_peer")
func rpc_create_ice(_position: Vector3):
	# This will be called on all peers
	var instance = FullIceTile.instantiate() as Node3D
	instance.position = _position
	add_child(instance)
	for tile in tiles:
		if tile.get_position() == _position:
			tile.set_instance(instance)
			tile.set_id(ID_FULL_ICE_TILE)
	
func check_to_break_ice(tile: ClassTile):
	var parent = tile.get_instance().get_parent()
	var children = tile.get_instance().get_children()
	for child in children:
		tile.get_instance().remove_child(child)
	if tile.get_instance() != null:
		parent.remove_child(tile.get_instance())
		
	var instance = BrokenIceTile.instantiate() as Node3D
	instance.position = tile.get_position()
	tile.set_instance(instance)
	tile.set_id(ID_BROKEN_ICE_TILE)
	add_child(instance)
	# Call RPC to create ice on other peers
	rpc("rpc_break_ice", tile.get_position())

@rpc("any_peer")
func rpc_break_ice(_position: Vector3):
	# This will be called on all peers
	var instance = BrokenIceTile.instantiate() as Node3D
	for tile in tiles:
		if tile.get_position() == _position:
			
			var parent = tile.get_instance().get_parent()
			var children = tile.get_instance().get_children()
			for child in children:
				tile.get_instance().remove_child(child)
			if tile.get_instance() != null:
				parent.remove_child(tile.get_instance())
				
			instance.position = tile.get_position()
			tile.set_instance(instance)
			tile.set_id(ID_BROKEN_ICE_TILE)
			add_child(instance)

func check_to_delete_ice(tile: ClassTile):
	if tile != null and tile.get_instance() != null:
		tile.get_instance().remove_child(tile.get_instance().get_children()[0])
		
	tile.set_id(ID_WATER_TILE)
	# Call RPC to create ice on other peers
	rpc("rpc_delete_ice", tile.get_position())
				
		
@rpc("any_peer")
func rpc_delete_ice(_position: Vector3):
	# This will be called on all peers
	for tile in tiles:
		if tile.get_position() == _position:
			tile.get_instance().remove_child(tile.get_instance().get_children()[0])
			tile.set_id(ID_WATER_TILE)

func startGame():
	start_gameplay = true

func delete_tile_with_radius(_position: Vector3, radius: int):
	if radius == 5:
		print("ok")

	var playerX = _position.x
	var playerZ = _position.z

	for i in tiles:
		var _pos = i.get_position()
		if sqrt(pow(_pos.x - playerX, 2) + pow(_pos.z - playerZ, 2)) <= radius:
			if i.get_id() != ID_WATER_TILE:
				var instance = i.get_instance()
				var parent = instance.get_parent()
				if parent != null:
					var children = instance.get_children()
					for child in children:
						instance.remove_child(child)
						parent.remove_child(instance)
				
				i.set_id(ID_WATER_TILE)
				
				# Make sure the instance is part of the tree before calling rpc
				if instance.is_inside_tree():
					rpc("rpc_delete_ice", i.get_position())

func delete_tile_at_position(_position: Vector3):
	delete_tile_with_radius(_position, 2)
	rpc_delete_tile_at_position.rpc(_position)
	
@rpc("any_peer")
func rpc_delete_tile_at_position(_position: Vector3):
	delete_tile_with_radius(_position, 2)
