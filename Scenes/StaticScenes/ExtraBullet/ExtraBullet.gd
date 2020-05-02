extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	$Ammo.play("Ammo")
	$Tween.interpolate_property($Ammo,'scale',$Ammo.scale,
								$Ammo.scale*1.5,0.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Ammo,'modulate',Color(1,1,1,1),
								Color(1,1,1,0),0.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var gravity_force = Vector2(0, 3)  # gravity force
var velocity = Vector2()  # the area's velocity

func _on_Tween_tween_completed(object, key):
	queue_free()
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if "player" in body.name:
		body.increase_bullet_count(10)
		$Sound.play()
		$Tween.start()
		$Timer.start()

	pass # Replace with function body.
	pass # Replace with function body.
