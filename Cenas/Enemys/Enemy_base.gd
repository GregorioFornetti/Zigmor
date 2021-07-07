extends KinematicBody2D

var attributes = {}
onready var Player = get_parent().get_node("Player")
onready var healthbar_timer = $HealthBar_timer
onready var healthbar = $HealthBar

func set_default_attributes(health, speed, damage, money_drop):
	attributes['health'] = health
	attributes['max_health'] = health
	attributes['speed'] = speed
	attributes['damage'] = damage
	attributes['money_drop'] = money_drop

func _on_Hurtbox_body_entered(player_bullet):
	print("OI")
	attributes['health'] -= player_bullet.damage
	if attributes['health'] <= 0:
		die()
	else:
		update_healthbar()

func update_healthbar():
	healthbar.visible = true
	healthbar.value = attributes['health']
	healthbar.max_value = attributes['max_health']
	healthbar_timer.start()

func die():
	Player.attributes["status"]['money'] += attributes['money_drop']
	queue_free()


func _on_HealthBar_timer_timeout():
	healthbar.visible = false


func _on_Hurtbox_area_entered(area):
	var player_bullet = area.get_parent()
	attributes['health'] -= player_bullet.damage
	if attributes['health'] <= 0:
		die()
	else:
		update_healthbar()

