extends CanvasLayer
var coin_price = 0
onready var coin = get_node("../Game_UI/Coin_Counter")
signal item_sold(item)
var constants = preload("res://Stages/constants.gd").new()
func _ready():
	pass

func market_calculator(item_id):
	if item_id in constants.items:
		if  coin.count >= constants.items[item_id][1]:
			coin.decrease_coins(constants.items[item_id][1])
			return true
		else:
			return false
			
func _process(delta):
 
	pass
	

func buy_item(item_id):
	if item_id in constants.items:	
		emit_signal("item_sold",item_id)
	else:
		print("Yanlış item id geldi.")
	pass
	


func _on_RasenganButton_pressed():
	if  market_calculator(101):
		buy_item(101)
	pass # Replace with function body.


func _on_FireBulletButton_pressed():
	if market_calculator(102):
		buy_item(102)
	pass # Replace with function body.
	
func _on_LaserBullet_pressed():
	if market_calculator(103):
		buy_item(103)
	pass # Replace with function body.

func _on_HealthButton_pressed():
	if market_calculator(104):
		buy_item(104)
	pass # Replace with function body.


func _on_WoodWall_pressed():
	if market_calculator(401):
		buy_item(401)
	pass # Replace with function body.


func _on_SteelWall_pressed():
	if market_calculator(402):
		buy_item(402)
	
	pass # Replace with function body.


func _on_GoldWall_pressed():
	if market_calculator(403):
		buy_item(403)
	
	pass # Replace with function body.


func _on_Portal_pressed():
	if market_calculator(500):
		buy_item(500)
	pass # Replace with function body.


func _on_Sword_pressed():
	if market_calculator(105):
		buy_item(105)
	pass # Replace with function body.
	
	
	
	
func _on_Trambolin_pressed():
	if market_calculator(404):
		buy_item(404)
	pass # Replace with function body.

func _on_Turret_pressed():
	if market_calculator(801):
		buy_item(801)
	pass # Replace with function body.


func _on_MachineTurret_pressed():
	if market_calculator(802):
		buy_item(802)
	pass # Replace with function body.


func _on_LaserTurret_pressed():
	if market_calculator(803):
		buy_item(803)
	
	pass # Replace with function body.


func _on_BazukaTurret_pressed():
	if market_calculator(804):
		buy_item(804)
	
	pass # Replace with function body.



