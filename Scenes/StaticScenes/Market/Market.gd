extends CanvasLayer
onready var coin = get_node("../Game_UI/Coin_Counter")
signal item_sold(item)
var constants = preload("res://Stages/constants.gd").new()
var no_money_sound = AudioStreamPlayer.new()
var no_money_sound_file = load("res://Resources/AudioFiles/GunShoot/emptyselect.wav")
var selected_item_id = 0

func set_sounds():
	no_money_sound.set_stream(no_money_sound_file)
	no_money_sound.volume_db = 1
	no_money_sound.pitch_scale = 1
	add_child(no_money_sound)
	
func _ready():
	set_sounds()
	hide_question_panel()
	pass

func show_item_info(item_id):
	var item_text = constants.items[item_id][0] 
	$BuyQuestion/Price.add_text(str(constants.items[item_id][1]))
	$BuyQuestion/ItemInfo.add_text(item_text)

func show_question_panel(item_id):
	$BuyQuestion/Price.clear()
	$BuyQuestion/ItemInfo.clear()
	$BuyQuestion.set_visible(true)
	show_item_info(item_id)
	selected_item_id = item_id

func hide_question_panel():
	$BuyQuestion.set_visible(false)
	

func market_calculator(item_id):
	if item_id in constants.items:
		if  coin.count >= constants.items[item_id][1]:
			show_question_panel(item_id)
			return true
		else:
			no_money_sound.play()
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
	market_calculator(101)
	pass # Replace with function body.

func _on_FireBulletButton_pressed():
	market_calculator(102)
	
func _on_LaserBullet_pressed():
	market_calculator(103)
	
func _on_Crossbow_pressed():
	market_calculator(107)
	pass # Replace with function body.

func _on_M1Garand_pressed():
	market_calculator(108)
	pass # Replace with function body.

func _on_M4A1_pressed():
	market_calculator(109)
	pass # Replace with function body.

func _on_M60E4_pressed():
	market_calculator(110)
	
	pass # Replace with function body.

func _on_MG42_pressed():
	market_calculator(111)
	pass # Replace with function body.

func _on_PRD_pressed():
	market_calculator(112)
	pass # Replace with function body.

func _on_RifleGun_pressed():
	market_calculator(113)
	pass # Replace with function body.

func _on_HealthButton_pressed():
	market_calculator(104)

func _on_WoodWall_pressed():
	market_calculator(401)
		
func _on_SteelWall_pressed():
	market_calculator(402)

func _on_GoldWall_pressed():
	market_calculator(403)

func _on_Portal_pressed():
	market_calculator(500)

func _on_Sword_pressed():
	market_calculator(105)
	
func _on_Trambolin_pressed():
	market_calculator(404)

func _on_Turret_pressed():
	market_calculator(801)

func _on_MachineTurret_pressed():
	market_calculator(802)

func _on_LaserTurret_pressed():
	market_calculator(803)

func _on_BazukaTurret_pressed():
	market_calculator(804)

func _on_AmmoButton_pressed():
	market_calculator(106)

func _on_YesButton_pressed():
	coin.decrease_coins(constants.items[selected_item_id][1])
	buy_item(selected_item_id)
	hide_question_panel()
	pass # Replace with function body.

func _on_NoButton_pressed():
	hide_question_panel()
	pass # Replace with function body.




func _on_CheckAvailableItems_timeout():
	for	 button in $HBoxContainer/GridContainer.get_children():
		if int(button.get_node("price").get_text()) > coin.count:
			button.modulate = Color(0.239216, 0.239216, 0.239216)
		else:
			button.modulate = Color(1, 1, 1)
		
	pass # Replace with function body.
