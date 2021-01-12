extends Node

var network: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var ip: String = "127.0.0.1"
#var ip: String = "47.208.69.57"
var port: int = 30000

func _ready() -> void:
	connect_to_server()

func connect_to_server() -> void:
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")
	
func _on_connection_succeeded() -> void:
	print("Succesfully connected")
	
func _on_connection_failed() -> void:
	print("Failed to connect")
