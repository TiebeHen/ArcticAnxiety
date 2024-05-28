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
	set_process(true)

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
				tiles.append(ClassTile.new(id, tile.position, tile))
			else:
				tiles.append(ClassTile.new(ID_WATER_TILE, Vector3(x, 0, z)))
			z += 2
		z = 0
		x += 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.IsThisAServer == true:
		if GameManager.GamePaused == true:
			return
		
		if start_gameplay == true:
			var newInstances = [] # Create a new list to hold instances to be added

			for t in tiles: # Iterate over a copy of instances to avoid modification during enumeration
				if t.get_id() == ID_WATER_TILE:
					if randi() % 100000 < 3: # Adjust probability for adding ice
						var instance = FullIceTile.instantiate() as Node3D
						instance.position = t.get_position()
						t.set_instance(instance)
						t.set_id(ID_FULL_ICE_TILE) # Add new instance to the temporary list
						add_child(instance)
						# Call RPC to create ice on other peers
						rpc("rpc_create_ice", t.get_position())

			# Add new instances to the main collection after the loop
			for newInstance in newInstances:
				tiles.append(newInstance)
			
			BreakTiles(delta)
	else:
		pass

func startGame():
	start_gameplay = true

@rpc("any_peer")
func rpc_create_ice(_position: Vector3):
	# This will be called on all peers
	var instance = FullIceTile.instantiate() as Node3D
	instance.position = _position
	add_child(instance)
	for t in tiles:
		if t.get_position() == _position:
			t.set_instance(instance)
			t.set_id(ID_FULL_ICE_TILE)

@rpc("any_peer")
func rpc_delete_tile(_position: Vector3):
	# This will be called on all peers
	delete_tile_at_position(_position)

func delete_tile_with_radius(_position: Vector3, radius: int):
	if radius == 5:
		print("ok")
	var playerX = _position.x
	var playerZ = _position.z
	for i in tiles:
		var _pos = i.get_position()
		if sqrt(pow(_pos.x - playerX, 2) + pow(_pos.z - playerZ, 2)) <= radius:
			if i.get_id() != ID_WATER_TILE:
				var parent = i.get_instance().get_parent()
				var children = i.get_instance().get_children()
				for child in children:
					i.get_instance().remove_child(child)
				if i.get_instance() != null:
					parent.remove_child(i.get_instance())
				i.set_id(ID_WATER_TILE)
				# Call RPC to delete tile on other peers
				rpc("rpc_delete_tile", i.get_position())

func delete_tile_at_position(_position: Vector3):
	var playerX = _position.x
	var playerZ = _position.z
	for i in tiles:
		var _pos = i.get_position()
		if abs(_pos.x - playerX) <= 2 and abs(_pos.z - playerZ) <= 2:
			if i.get_id() != ID_WATER_TILE:
				var parent = i.get_instance().get_parent()
				var children = i.get_instance().get_children()
				for child in children:
					i.get_instance().remove_child(child)
				parent.remove_child(i.get_instance())
				i.set_id(ID_WATER_TILE)
				# Call RPC to delete tile on other peers
				rpc("rpc_delete_tile", _pos)

func BreakTiles(delta):
	timeLeftTileBreaking -= delta
	if timeLeftTileBreaking < 0:
		for t in tiles:
			if t.get_id() == ID_FULL_ICE_TILE:
				if randi() % 300000 < 3: # Adjust probability for breaking ice
					delete_tile_with_radius(t.get_position(), 1)
					var instance = BrokenIceTile.instantiate() as Node3D
					instance.position = t.get_position()
					t.set_instance(instance)
					t.set_id(ID_BROKEN_ICE_TILE)
					add_child(instance)
					# Call RPC to create broken ice on other peers
					rpc("rpc_create_broken_ice", t.get_position())
		timeLeftTileBreaking = maxTimeTileBreaking

@rpc("any_peer")
func rpc_create_broken_ice(_position: Vector3):
	# This will be called on all peers
	var instance = BrokenIceTile.instantiate() as Node3D
	instance.position = _position
	add_child(instance)
	for t in tiles:
		if t.get_position() == _position:
			t.set_instance(instance)
			t.set_id(ID_BROKEN_ICE_TILE)
