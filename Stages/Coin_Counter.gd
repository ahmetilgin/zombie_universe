extends RichTextLabel
var count=0
var count_size=100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.
func counting():
	count+=count_size
	text=String(count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
