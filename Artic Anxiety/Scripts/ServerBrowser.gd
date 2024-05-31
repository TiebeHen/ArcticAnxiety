extends Control

signal  found_server
signal  server_removed
signal joinGame(ip)
var broadcastTimer : Timer

var RoomInfo = {"name":"name", "playerCount": 0, "maxPlayers": 0}
var broadcaster : PacketPeerUDP
var listner : PacketPeerUDP
@export var listenPort : int = 8911
@export var broadcastPort : int = 8912
@export var broadcastAddress : String = '192.168.0.255'
#@export var broadcastAddress : String = '25.11.10.180' #HAMACHI van client(milan)
#@export var broadcastAddress : String = '25.53.201.211' # HAMACHI van server (jonathan)

@export var serverInfo : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	broadcastTimer = $BroadcastTimer
	setUp()
	pass # Replace with function body.
	
func setUp():
	listner = PacketPeerUDP.new()
	var ok = listner.bind(listenPort)
	
	if ok == OK:
		print("Bound to listen Port "  + str(listenPort) +  " Successful!")
		$Label.text="Bound To Listen Port: true"
	else:
		print("Failed to bind to listen port!")
		$Label.text="Bound To Listen Port: false"
		

func setUpBroadCast(_name):
	RoomInfo.name = _name
	RoomInfo.playerCount = GameManager.Players.size()
	RoomInfo.maxPlayers = GameManager.maxPlayersPerLobby
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcastAddress, listenPort)
	
	var ok = broadcaster.bind(broadcastPort)
	
	if ok == OK:
		print("Bound to Broadcast Port "  + str(broadcastPort) +  " Successful!")
	else:
		print("Failed to bind to broadcast port!")
		
	$BroadcastTimer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
			
	if listner.get_available_packet_count() > 0:
		var serverip = listner.get_packet_ip()
		var serverport = listner.get_packet_port()
		var bytes = listner.get_packet()
		var data = bytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)
		
		print("server Ip: " + serverip +" serverPort: "+ str(serverport) + " room info: " + str(roomInfo))
		
		for i in $"../MultiplayerMenuOverlay/BackgroundLobbies/VBoxContainer".get_children():
			if i.name == roomInfo.name:
				i.get_node("Ip").text = serverip
				i.get_node("PlayerCount").text = str(roomInfo.playerCount) + " / " + str(GameManager.maxPlayersPerLobby)
				return

		var currentInfo = serverInfo.instantiate()
		currentInfo.name = roomInfo.name
		currentInfo.get_node("Name").text = roomInfo.name
		currentInfo.get_node("Ip").text = serverip
		currentInfo.get_node("PlayerCount").text = str(roomInfo.playerCount) + " / " + str(GameManager.maxPlayersPerLobby)
		$"../MultiplayerMenuOverlay/BackgroundLobbies/VBoxContainer".add_child(currentInfo)
		currentInfo.joinGame.connect(joinbyIp)
		pass
	pass


func _on_broadcast_timer_timeout():
	print("Broadcasting Game!")
	RoomInfo.playerCount = GameManager.Players.size()
	var data = JSON.stringify(RoomInfo)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)
	pass # Replace with function body.

func cleanUp():
	listner.close()
	
	$BroadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()

func _exit_tree():
	cleanUp()

func joinbyIp(ip):
	joinGame.emit(ip)
