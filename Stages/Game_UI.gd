extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var screen_size = get_parent().get_node(".").get_viewport_rect().size
	var screen_size_calibration = screen_size / Vector2(1200,800)
	set_transform(Transform2D(Vector2(screen_size_calibration.x , 0),Vector2(0,screen_size_calibration.x ), Vector2(0,0)))
	$accept_button.rect_position.y -=  ($accept_button.rect_position.y * abs(screen_size_calibration.x - 1)) * 2 / 3
	$SelectPositionLabel.rect_position.y -=  ($SelectPositionLabel.rect_position.y * abs(screen_size_calibration.x - 1)) * 2 / 3

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
