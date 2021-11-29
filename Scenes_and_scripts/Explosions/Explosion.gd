extends Area2D

export (int) var damage

func get_damage():
	return damage

func _ready():
	$Duration.start($ExplosionEffect.lifetime)
	$ExplosionEffect.emitting = true

func _on_Duration_timeout():
	queue_free()
