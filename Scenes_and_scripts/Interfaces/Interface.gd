extends CanvasLayer

onready var current_weapon_sprite = $Top_right_interface/Center_container/Weapon_status_box/Current_weapon
onready var ammo_info_label = $Top_right_interface/Center_container/Weapon_status_box/Ammo_info
onready var health_bar = $Top_right_interface/Center_container/Player_status_box/HealthBar
onready var health_bar_label = $Top_right_interface/Center_container/Player_status_box/HealthBar/HealthInfo
onready var reload_bar = $ReloadBar
onready var time_label = $Top_right_interface/Top_container/Time_box/Time_label
onready var enemy_label = $Top_right_interface/Top_container/Enemy_box/Enemy_label
onready var money_label = $Top_right_interface/Center_container/Money_label
onready var dash_box = $Bottom_interface/Left_interface/DashBox
onready var weapon_power_box = $Bottom_interface/Left_interface/Weapon_power_box
var qnt_enemies_alive = 0

func _ready():
	Game.timer.connect("timeout", self, "_on_Timer_1sec_timeout")


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

func update_enemies_qnt(enemies_qnt):
	enemy_label.text = str(enemies_qnt)

func update_money(money):
	money_label.text = "$ " + str(money)

func update_dash_box(current_time, total_time, stack):
	var progress_bar = dash_box.get_node("CircleLoadingBar/TextureProgress")
	
	dash_box.get_node("Counter").text = str(stack)
	progress_bar.value = current_time * 100
	progress_bar.max_value = total_time * 100

func update_weapon_power_icon(new_icon):
	weapon_power_box.get_node("Icon").texture = new_icon

func update_weapon_power_progress_bar(current_time, total_time):
	var progress_bar = weapon_power_box.get_node("CircleLoadingBar/TextureProgress")
	progress_bar.value = current_time * 100
	progress_bar.max_value = total_time * 100


func _on_Timer_1sec_timeout():
	time_label.text = GeneralCommands.seconds_to_time_string(Game.current_time)

func _on_enemy_death(_enemy):
	qnt_enemies_alive -= 1
	update_enemies_qnt(qnt_enemies_alive)

func _on_enemy_spawn(_enemy):
	qnt_enemies_alive += 1
	update_enemies_qnt(qnt_enemies_alive)
