extends "res://Scenes_and_scripts/Interfaces/Upgrades_shop/Shop_buttons/Btn_shop_buy.gd"


func get_upgrade_price():
	return 5 + qnt_buyed * 5

func make_upgrade():
	var magazine_size = Game.Player.attributes[Game.Player.SHOTGUN].magazine_capacity
	Game.Player.attributes[Game.Player.SHOTGUN].status.qnt_total_bullets += magazine_size

func update_status_box():
	var qnt_not_reloaded_bullets = Game.Player.attributes[Game.Player.SHOTGUN].status.qnt_total_bullets
	var qnt_reloaded_bullets = Game.Player.attributes[Game.Player.SHOTGUN].status.qnt_reloaded_bullets
	status_boxes_container.get_node("Qnt_bullets_status/Attribute_label").text =  \
		str(qnt_not_reloaded_bullets + qnt_reloaded_bullets)
