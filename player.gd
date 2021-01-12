extends KinematicBody2D

export var _movement_speed: float = 30000
export var _max_hp: int = 100
var _current_hp: int

var _move_direction: String = "S"

var _is_animation_locked: bool = false

var _m1_cooldown: float = 0.4
var _m1_anim_delay: float = 0.4
var _m1_can_fire: bool = true

# Pre load in projectile texture
var projectile = preload("res://Projectile.tscn")

func _ready() -> void:
	_current_hp = _max_hp

func _physics_process(delta) -> void:
	var movement_dir: Vector2 = movement()
	move_and_slide(movement_dir.normalized() * _movement_speed * delta)
	animation_loop(movement_dir)
	use_ability()

func movement() -> Vector2:
	var movement_vector: Vector2
	var updown_movement: Vector2
	var leftright_movement: Vector2
	
	if(Input.is_action_pressed("move_up")):
		updown_movement = Vector2(0, -1)
	elif(Input.is_action_pressed("move_down")):
		updown_movement = Vector2(0, 1)

	if(Input.is_action_pressed("move_left")):
		leftright_movement = Vector2(-1, 0)
	elif(Input.is_action_pressed("move_right")):
		leftright_movement = Vector2(1, 0)
	
	movement_vector = (updown_movement + leftright_movement)#.normalized()
	
	return movement_vector

func animation_loop(movement_vector) -> void:
	var anim_mode: String = "Walk"
	
	#_move_direction = get_dir_from_vec(movement_vector)
	
	if(movement_vector == Vector2(0, -1)):
		_move_direction = "N"
	elif(movement_vector == Vector2(1, -1)):
		_move_direction = "NE"
	elif(movement_vector == Vector2(1, 0)):
		_move_direction = "E"
	elif(movement_vector == Vector2(1, 1)):
		_move_direction = "SE"
	elif(movement_vector == Vector2(0, 1)):
		_move_direction = "S"
	elif(movement_vector == Vector2(-1, 1)):
		_move_direction = "SW"
	elif(movement_vector == Vector2(-1, 0)):
		_move_direction = "W"
	elif(movement_vector == Vector2(-1, -1)):
		_move_direction = "NW"
	elif(movement_vector == Vector2(0, 0) && not _is_animation_locked):
		anim_mode = "Idle"
		
	if(_is_animation_locked):
		anim_mode = "Proj"
		var dir = get_angle_to(get_global_mouse_position())
		var dir_vec = Vector2(cos(dir), sin(dir))
		_move_direction = get_dir_from_vec(dir_vec)
	
	get_node("AnimationPlayer").play(anim_mode + "_" + _move_direction)

func use_ability() -> void:
	if (Input.is_action_pressed("m1") && _m1_can_fire == true):
		_m1_can_fire = false
		_is_animation_locked = true
		var temp_movement_speed = _movement_speed
		_movement_speed = 0
		yield(get_tree().create_timer(_m1_anim_delay), "timeout")
		var proj_instance = projectile.instance()
		var angle_to_mouse = get_angle_to(get_global_mouse_position())
		get_node("Pivot").rotation = angle_to_mouse
		proj_instance.position = get_node("Pivot/CastPoint").get_global_position()
		proj_instance.rotation = angle_to_mouse
		get_parent().add_child(proj_instance)
		yield(get_tree().create_timer(_m1_cooldown), "timeout")
		_m1_can_fire = true
		_is_animation_locked = false
		_movement_speed = temp_movement_speed


# does nothing atm possible utility function
func get_dir_from_vec(vec: Vector2) -> String:
	var dir: String
	
	if((vec.x <= 0.2 && vec.x >= -0.2) && vec.y < 0):
		dir = "N"
	elif(vec.x > 0 && (vec.y <= 0.2 && vec.y >= -0.2)):
		dir = "E"
	elif((vec.x <= 0.2 && vec.x >= -0.2) && vec.y > 0):
		dir = "S"
	elif(vec.x < 0 && (vec.y <= 0.2 && vec.y >= -0.2)):
		dir = "W"
	elif(vec.x > 0 && vec.y < 0):
		dir = "NE"
	elif(vec.x > 0 && vec.y > 0):
		dir = "SE"
	elif(vec.x < 0 && vec.y > 0):
		dir = "SW"
	elif(vec.x< 0 && vec.y < 0):
		dir = "NW"
		
	return dir
	
