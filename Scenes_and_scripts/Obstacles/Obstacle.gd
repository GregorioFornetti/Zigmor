extends StaticBody2D

export (int) var health
signal die

func _ready():
	connect("die", Game, "_on_obstacle_destruction")
	$HealthBar.visible = false
	$HealthBar.max_value = health

func die():
	if not is_queued_for_deletion():
		emit_signal("die")
		queue_free()

func update_health_bar():
	$HealthBar.visible = true
	$HealthBar.value = health
	$Timer.start()


func _on_Hurt_box_area_entered(area):
	var bullet = area.get_parent()
	health -= bullet.damage
	if health <= 0:
		die()
	else:
		update_health_bar()

func _on_Timer_timeout():
	$HealthBar.visible = false
