extends Area2D
var another_position
var body 
var is_animation_finished = false
var is_body_exited = false
var is_body_entered = false
func _ready():
	pass
func _process(delta):

	if is_body_entered:
		$AnimatedSprite.play("GateActive")
	else:
		$AnimatedSprite.play("Gate")
		
func set_other_pos(pos):
	another_position = pos

func _on_Teleport_body_entered(body):
	if"player" in body.name : 
		body.set_teleport(another_position)
		is_body_entered = true

	pass # Replace with function body

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "GateActive":
		is_body_entered = false
		
	pass # Replace with function body.


func _on_Teleport_body_exited(body):
	if"player" in body.name : 
		is_body_entered = false
		body.teleport_is_stoped()
	pass # Replace with function body.

