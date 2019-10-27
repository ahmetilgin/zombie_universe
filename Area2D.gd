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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimatedSprite_animation_finished():
	is_jump=false


func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	print(body_shape)
	if"player" in body.name and body_shape==0:
		body.tramboline_jump()
		is_jump=true
	pass # Replace with function body.

