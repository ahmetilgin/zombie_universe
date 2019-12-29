extends RichTextLabel
var count=0
var coin_memory
var count_size=1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var purchase = get_parent().get_parent().get_node("Market")
	coin_memory = purchase.coin_price
	pass # Replace with function body.
func on_purchase():
	count = coin_memory
	
	pass
func _process(delta):
	text=String(count)
	pass
func counting():
	count+=count_size
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
