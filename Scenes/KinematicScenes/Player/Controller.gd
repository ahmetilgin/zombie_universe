extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_parent().get_parent().get_node(".").get_viewport_rect().size
	var screen_size_calibration = (screen_size )/ Vector2(1200,800)
	$action.position.x = screen_size_calibration.x * $action.position.x
	$move/right.scale *= screen_size_calibration.x
	$move/left.scale *= screen_size_calibration.x
	$action.scale *= screen_size_calibration.x
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
