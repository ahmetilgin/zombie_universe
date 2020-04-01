extends RichTextLabel
var count = 10000
var coin_memory
var count_size = 1

func _ready():
	pass # Replace with function body.
	
func on_purchase():
	pass
func _process(delta):
	
	pass
	
func counting():
	count += count_size
	text = String(count)
	
func decrease_coins(price):
	count -= price
	text = String(count)
	
func increase_coins(price):
	count += price
	text = String(count)
