extends TextureButton

var qnt_buyed = 0
onready var status_boxes_container = get_parent().get_parent().get_parent().get_node("Rigth_container/Status_boxes_container")

func disable_btn():
	$Price.text = "MAXIMIZADO"
	disabled = true

func get_upgrade_price():
	pass

func make_upgrade():
	pass

func update_status_box():
	pass

func update_price_label():
	$Price.text = "$" + str(get_upgrade_price())


func _on_Btn_shop_buy_pressed():
	var upgrade_price = get_upgrade_price()
	if Game.Player.get_money() >= upgrade_price:
		make_upgrade()
		Game.Player.decrease_money(upgrade_price)
		qnt_buyed += 1
		
		update_status_box()
		update_price_label()
		Game.Player.update_money_interface()
		var shop_main = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
		shop_main.update_money_label()

func _ready():
	update_status_box()
	update_price_label()
