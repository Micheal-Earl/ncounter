extends KinematicBody2D

export var _max_hp: int = 100
var _current_hp: int

func _ready()  -> void:
	_current_hp = _max_hp

func on_hit(damage) -> void:
	_current_hp -= damage
	get_node("HPBar").value = int((float(_current_hp) / _max_hp) * 100)
	if(_current_hp <= 0):
		self_destruct()

func self_destruct() -> void:
	queue_free()
