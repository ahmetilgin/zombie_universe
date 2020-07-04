extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_jump=false
# Called when the node enters the scene tree for the first time.
func _physics_process(delta): 
	if not is_jump:
		$AnimatedSprite.play("salik")
	else:
		$AnimatedSprite.play("gergin")

	pass # Replace with function body.
func _ready():
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	is_jump=false

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if"player" in body.name and body_shape==0:
		body.tramboline_jump(get_global_position())
		is_jump=true
	pass # Replace with function body.

func save():
	var data = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"position_x":get_global_position().x,
		"position_y":get_global_position().y
	}
	return data

func load_data(node_data):
	set_global_position(Vector2(node_data["position_x"], node_data["position_y"]))
	pass
