extends KinematicBody2D

export (float) var speed
export (Texture) var crit_sprite
export (int) var damage
var velocity = Vector2.ZERO


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


func _on_Life_timer_timeout():
	queue_free()
