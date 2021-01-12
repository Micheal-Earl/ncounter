extends RigidBody2D

var _projectile_speed: float = 1000
var _life_time: float = 3
var _damage = 25

func _ready():
	get_node("AnimationPlayer").play("Projectile")
	apply_impulse(Vector2(), Vector2(_projectile_speed, 0).rotated(rotation))
	self_destruct()

func self_destruct() -> void:
	yield(get_tree().create_timer(_life_time), "timeout")
	queue_free()

func _on_Spell_body_entered(body) -> void:
	get_node("CollisionShape2D").set_deferred("disabled", true)
	if(body.is_in_group("Mobs")):
		body.get_owner().on_hit(_damage)
	self.hide()
