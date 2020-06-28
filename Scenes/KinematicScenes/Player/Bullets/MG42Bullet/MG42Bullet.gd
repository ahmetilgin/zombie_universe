extends Area2D

var blood_anim = preload("res://Scenes/StaticScenes/BloodAnimation/BloodAnimation.tscn")
const speed=1000

var motion=Vector2()
var direction=1
func set_bullet_direction(dir):
	direction=dir
	if dir==-1:
		$AnimatedSprite.flip_h=true
	else:
		$AnimatedSprite.flip_h=false
	

func _physics_process(delta):
	motion.x=speed*delta*direction
	translate(motion)
	$AnimatedSprite.play("shoot2")
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass


func _on_MG42_body_entered(body):
	if "Zombie" in body.name:
		body.dead(1,"player")
		var blood_instance = blood_anim.instance()
		body.add_child(blood_instance) 
		blood_instance.set_global_position(get_global_position())
	queue_free()

	pass # Replace with function body.
