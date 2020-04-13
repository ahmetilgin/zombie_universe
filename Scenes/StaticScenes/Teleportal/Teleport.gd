extends Area2D
var another_position
var body 

func _ready():
	pass

func set_other_pos(pos):
	another_position = pos


func _on_Teleport_body_entered(body):
	if"player" in body.name  :
		body.set_global_position(another_position)
	pass # Replace with function body



