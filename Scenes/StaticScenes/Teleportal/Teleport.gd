extends Area2D
var another_position

signal find_pos

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	emit_signal("find_pos",get_global_position())
	connect("find_pos",self,"_on_find_pos",[get_global_position()])
	pass

func _on_find_pos():
	another_position 


func _on_Teleport_body_entered(body):
	if"player" in body.name  :
		body.set_global_position(another_position)
	pass # Replace with function body

