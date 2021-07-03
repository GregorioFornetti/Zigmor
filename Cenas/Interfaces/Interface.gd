extends CanvasLayer

onready var current_weapon_sprite = $Weapon_status_box/Current_weapon
onready var ammo_info_label = $Weapon_status_box/Ammo_info


func _ready():
	pass # Replace with function body.


func update_weaponAndAmmo_interface(weapon_index, current_ammo, total_ammo):
	current_weapon_sprite.frame = weapon_index
	print(total_ammo)
	if total_ammo >= 0:
		ammo_info_label.text = str(current_ammo) + "/" + str(total_ammo)
	else:
		ammo_info_label.text = str(current_ammo)
