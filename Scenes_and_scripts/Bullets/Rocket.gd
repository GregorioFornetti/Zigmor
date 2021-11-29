extends KinematicBody2D

onready var Explosion = preload("res://Scenes_and_scripts/Explosions/Explosion.tscn")
export (float) var speed
export (int) var damage
const rotation_fix = PI / 2
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_force = 0.7
var target

func seek():
	var desired = ((Game.Player.position - position).normalized() * speed)
	return (desired - velocity).normalized() * steer_force

func explode():
	var explosion = Explosion.instance()
	explosion.damage = damage
	explosion.global_position = global_position
	get_parent().call_deferred("add_child", explosion)
	queue_free()

func _process(delta):
	acceleration += seek()
	velocity += (acceleration * delta)
	velocity = velocity.clamped(speed)
	rotation = velocity.angle() + rotation_fix
	if move_and_collide(velocity):
		explode()
	

func initialize_bullet(initial_pos, damage):
	self.damage = damage
	self.global_position = initial_pos


func get_damage():
	return damage

func _on_Duration_timeout():
	explode()

func _on_Hitbox_area_entered(_area):
	explode()
