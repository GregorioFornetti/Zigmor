extends KinematicBody2D

export (float) var speed
export (Texture) var crit_sprite
export (int) var damage
export (bool) var have_knockback
var velocity = Vector2.ZERO
var attributes


func _process(delta):
	if move_and_collide(velocity * speed * delta):
		queue_free()
	

func initialize_bullet(initial_pos, damage, direction):
	self.damage = damage
	self.global_position = initial_pos
	self.velocity = direction.normalized()

func apply_critical(crit_buff):
	speed *= 1.5
	damage *= crit_buff
	$Sprite.texture = crit_sprite

func get_damage():
	return damage

func _on_Life_timer_timeout():
	queue_free()


func _on_Hitbox_area_entered(_area):
	queue_free()
