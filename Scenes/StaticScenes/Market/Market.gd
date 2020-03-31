extends CanvasLayer

signal item_sold(item)
var constants = preload("res://Stages/constants.gd").new()
func _ready():
	pass # Replace with function body.
func _process(delta):
	pass
	

func buy_item(item_id):
	if item_id in constants.items:	
		emit_signal("item_sold",item_id)
	else:
		print("Yanlış item id geldi.")
	pass
	


func _on_RasenganButton_pressed():
	buy_item(101)
	pass # Replace with function body.


func _on_FireBulletButton_pressed():
	buy_item(102)
	pass # Replace with function body.
	
func _on_LaserBullet_pressed():
	buy_item(103)
	pass # Replace with function body.

func _on_HealthButton_pressed():
	buy_item(104)
	pass # Replace with function body.


func _on_WoodWall_pressed():
	buy_item(401)
	pass # Replace with function body.


func _on_SteelWall_pressed():
	buy_item(402)
	pass # Replace with function body.


func _on_GoldWall_pressed():
	buy_item(403)
	pass # Replace with function body.


func _on_Portal_pressed():
	buy_item(500)
	pass # Replace with function body.


func _on_Sword_pressed():
	buy_item(104)
	pass # Replace with function body.
	
	
	
	
func _on_Trambolin_pressed():
	buy_item(404)
	pass # Replace with function body.

func _on_Turret_pressed():
	buy_item(801)
	pass # Replace with function body.


func _on_MachineTurret_pressed():
	buy_item(802)
	pass # Replace with function body.


func _on_LaserTurret_pressed():
	buy_item(803)
	pass # Replace with function body.


func _on_BazukaTurret_pressed():
	buy_item(804)
	pass # Replace with function body.



