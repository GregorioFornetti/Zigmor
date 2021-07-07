extends CanvasLayer

onready var current_weapon_sprite = $Weapon_status_box/Current_weapon
onready var ammo_info_label = $Weapon_status_box/Ammo_info
onready var health_bar = $Player_status_box/HealthBar
onready var health_bar_label = $Player_status_box/HealthBar/HealthInfo
onready var reload_bar = $Weapon_status_box/ReloadBar


func _ready():
	pass # Replace with function body.


func update_weaponAndAmmo(weapon_index, current_ammo, total_ammo):
	current_weapon_sprite.frame = weapon_index
	if total_ammo >= 0:
		ammo_info_label.text = str(current_ammo) + "/" + str(total_ammo)
	else:
		ammo_info_label.text = str(current_ammo)

func update_healthbar(current_health, max_health):
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar_label.text = str(current_health) + "/" + str(max_health)

func update_reloadbar(time_left, final_time, reloading):
	if reloading:
		reload_bar.visible = true
		reload_bar.value = final_time - time_left
		reload_bar.max_value = final_time
	else:
		reload_bar.visible = false
