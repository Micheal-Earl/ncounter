extends KinematicBody2D

onready var _animation_player: Node = get_node("AnimationPlayer")

# statistics
export var _movement_speed: float = 30000
export var _max_hp: int = 100
var _current_hp: int

# state machine
enum states {
	MOVING,
	IDLE,
	ATTACK
}
var current_state: int = states.IDLE

# 8 way directional facing properties
enum facing { N, NE, E, SE, S, SW, W, NW }
var current_facing: int = facing.S

# ability properties
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
	if(!_is_animation_locked): 
		set_facing_from_vector(movement_dir)
		use_abilities()
	move_and_slide(movement_dir.normalized() * _movement_speed * delta)
	animation_loop(movement_dir)
	
	# todo
	match current_state:
		states.IDLE:
			pass
		states.MOVING:
			pass
		states.ATTACK:
			pass

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

func use_abilities() -> void:
	if(Input.is_action_pressed("m1") && _m1_can_fire == true):
		_m1_can_fire = false
		_is_animation_locked = true
		var temp_movement_speed = _movement_speed
		_movement_speed = 0
		var angle_to_mouse = get_angle_to(get_global_mouse_position())
		set_facing_from_vector(Vector2(cos(angle_to_mouse), sin(angle_to_mouse)))
		yield(get_tree().create_timer(_m1_anim_delay), "timeout")
		var proj_instance = projectile.instance()
		get_node("Pivot").rotation = angle_to_mouse
		proj_instance.position = get_node("Pivot/CastPoint").get_global_position()
		proj_instance.rotation = angle_to_mouse
		get_parent().add_child(proj_instance)
		yield(get_tree().create_timer(_m1_cooldown), "timeout")
		_m1_can_fire = true
		_is_animation_locked = false
		_movement_speed = temp_movement_speed

func animation_loop(movement_vector) -> void:
	var anim_mode: String
	
	if(movement_vector == Vector2(0, 0) && not _is_animation_locked):
		anim_mode = "Idle"
	elif(_is_animation_locked):
		anim_mode = "Proj"
		var dir = get_angle_to(get_global_mouse_position())
		var dir_vec = Vector2(cos(dir), sin(dir))
	else:
		anim_mode = "Walk"
	
	_animation_player.play(anim_mode + "_" + facing_to_string(current_facing))

func set_facing_from_vector(vec: Vector2) -> void:
	var dir: String
	
	if((vec.x <= 0.2 && vec.x >= -0.2) && vec.y < 0):
		current_facing = facing.N
	elif(vec.x > 0 && (vec.y <= 0.2 && vec.y >= -0.2)):
		current_facing = facing.E
	elif((vec.x <= 0.2 && vec.x >= -0.2) && vec.y > 0):
		current_facing = facing.S
	elif(vec.x < 0 && (vec.y <= 0.2 && vec.y >= -0.2)):
		current_facing = facing.W
	elif(vec.x > 0 && vec.y < 0):
		current_facing = facing.NE
	elif(vec.x > 0 && vec.y > 0):
		current_facing = facing.SE
	elif(vec.x < 0 && vec.y > 0):
		current_facing = facing.SW
	elif(vec.x< 0 && vec.y < 0):
		current_facing = facing.NW
	
func facing_to_string(direction) -> String:
	var direction_string: String
	
	match direction:
		facing.N:
			direction_string = "N"
		facing.NE:
			direction_string = "NE"
		facing.E:
			direction_string = "E"
		facing.SE:
			direction_string = "SE"
		facing.S:
			direction_string = "S"
		facing.SW:
			direction_string = "SW"
		facing.W:
			direction_string = "W"
		facing.NW:
			direction_string = "NW"
		
	return direction_string
		
func state_to_string(state) -> String:
	var state_string: String
	
	match state:
		states.IDLE:
			state_string = "Idle"
		states.MOVING:
			state_string = "Walk"
		states.ATTACK:
			state_string = "Proj"
		
	return state_string
		
