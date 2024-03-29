extends Area2D
var no_hurt = false
var  speed=1000
var motion=Vector2()
var direction=1
var grv = 0
var blood_anim = preload("res://Scenes/StaticScenes/BloodAnimation/BloodAnimation.tscn")

func set_bullet_direction(dir):
	$SuzulmeTimer.start()
	direction=dir
	if dir==-1:
		$AnimatedSprite.flip_h=true
	else:
		$AnimatedSprite.flip_h=false
	

func _physics_process(delta):
	motion.y += grv
	motion.x=speed*delta*direction
	translate(motion)
	$AnimatedSprite.play("shoot2")

	
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass



func _on_Crossbowbullet_body_entered(body):
	if "Zombie" in body.name and !no_hurt:
		body.dead(1,"player")
		var blood_instance = blood_anim.instance()
		body.add_child(blood_instance) 
		blood_instance.set_global_position(get_global_position()) 
		queue_free()
	else:
		no_hurt = true
		speed = 0
		grv = 0
		motion.y = 0
		$Timer.start()
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.


func _on_SuzulmeTimer_timeout():
	grv = 0.01
	pass # Replace with function body.
