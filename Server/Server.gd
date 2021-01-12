extends Node

var network: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var port: int = 30000
var max_players: int = 6

func _ready() -> void:
	VisualServer.render_loop_enabled = false
	start_server()

func start_server() -> void:
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server init")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	
func _peer_connected(player_id) -> void:
	print("User " + str(player_id) + " has connected")
	
func _peer_disconnected(player_id) -> void:
	print("User" + str(player_id) + " has disconnected")
