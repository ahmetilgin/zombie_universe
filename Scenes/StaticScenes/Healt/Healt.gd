extends Area2D
var healt = 20
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("Healt")
	$Tween.interpolate_property($AnimatedSprite,'scale',$AnimatedSprite.scale,
								$AnimatedSprite.scale*1.5,0.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite,'modulate',Color(1,1,1,1),
								Color(1,1,1,0),0.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var gravity_force = Vector2(0, 3)  # gravity force
var velocity = Vector2()  # the area's velocity

func _on_Healt_body_entered(body):
	if "player" in body.name:
		body.healt_kit(healt)
		 
		set_deferred("monitoring",false)
		$Tween.start()
		$Timer.start()



func _on_Tween_tween_completed(object, key):
	queue_free()
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
func _process(delta):
	if not $Ground.is_colliding():
		set_global_position(get_global_position() + gravity_force)



