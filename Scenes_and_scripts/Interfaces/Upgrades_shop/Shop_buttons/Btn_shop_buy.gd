extends TextureButton

# Esse é o código do botão base para compra de upgrades
# Para criar um novo upgrade, é preciso criar uma nova cena que herda esse botão
# e criar as funções: get_upgrade_price(), make_upgrade() e update_status_box().
# Depois de criar, basta adcionar o botão em uma das paginas da loja e associar
# um status box a esse botão

var qnt_buyed = 0
onready var status_boxes_container = get_parent().get_parent().get_parent().get_node("Rigth_container/Status_boxes_container")

func disable_btn():
	$Price.text = "MAXIMIZADO"
	disabled = true

func get_upgrade_price():  # Retorna o preço para comprar o upgrade atualmente
	pass

func make_upgrade(): # Função que deve fazer o upgrade em si
	pass

func update_status_box(): # Função que deve atualizar o status box associado ao botão.
	pass

func update_price_label():
	$Price.text = "$" + str(get_upgrade_price())


func _on_Btn_shop_buy_pressed():
	if not disabled:
		var upgrade_price = get_upgrade_price()
		if Game.Player.get_money() >= upgrade_price:
			make_upgrade()
			Game.Player.decrease_money(upgrade_price)
			qnt_buyed += 1
			
			update_status_box()
			if not disabled:
				update_price_label()
			Game.Player.update_money_interface()
			var shop_main = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
			shop_main.update_money_label()
			SoundSystem.play_sound_effect(load("res://Sound/Effects/Interface/shop-buy.wav"))
			

func _ready():
	update_status_box()
	update_price_label()
