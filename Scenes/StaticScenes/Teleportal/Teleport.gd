extends Area2D
var another_position
var body 
var is_animation_finished = false
var is_body_exited = false
var player_body
var is_body_entered = false
var is_animated_finished = false
func _ready():
	pass
func _process(delta):

	if is_body_entered:
		$AnimatedSprite.play("GateActive")
	else:
		$AnimatedSprite.play("Gate")
	if is_body_entered and is_animated_finished:
		is_animated_finished = false
		is_body_entered = false
		player_body.set_global_position(another_position)
		
func set_other_pos(pos):
	another_position = pos

func _on_Teleport_body_entered(body):
	if"player" in body.name : 
		player_body = body
		is_body_entered = true

	pass # Replace with function body

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "GateActive":
		is_animated_finished = true
		
		
		
	pass # Replace with function body.


func _on_Teleport_body_exited(body):
	if"player" in body.name : 
		is_body_entered = false
		is_animated_finished = false
		
	pass # Replace with function body.

