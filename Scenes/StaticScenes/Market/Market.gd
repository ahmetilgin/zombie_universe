extends CanvasLayer
var turret = preload("res://Scenes/KinematicScenes/Turrent/Turret.tscn")
var turret2 = preload("res://Scenes/KinematicScenes/Turrent/Turret.tscn")
onready var coin = get_node("../Game_UI/Coin_Counter")
signal item_sold(item_price, item)
var coin_price = 0
var selected_item = null
var selected_item_price = null
var turret_price = 20
var turret2_price = 1 # silinecek deneme için yapıyorum

func _ready():
	pass # Replace with function body.
func _process(delta):
	coin_price = coin.count

func market_calculator(item_price_tag):
	if coin_price > item_price_tag:
		coin_price -= item_price_tag
		coin.count = coin_price
		return true
	else:
		return false
	
func _on_TurrenButton2_focus_entered():
	selected_item = turret2
	selected_item_price = turret2_price
	pass # Replace with function body.


func _on_TurrenButton_focus_entered():
	selected_item = turret
	selected_item_price = turret_price
	pass # Replace with function body.


func _on_BuyButton_pressed():
	if market_calculator(selected_item_price):
		emit_signal("item_sold", selected_item_price, selected_item)
		
	pass # Replace with function body.
