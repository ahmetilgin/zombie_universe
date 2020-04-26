extends Area2D

const speed=1000

var motion=Vector2()
var direction=1
func set_bullet_direction(dir):
	direction=dir
	if dir==-1:
		$AnimatedSprite.flip_h=true
		$AnimatedSprite.position.x+=45
		$CollisionShape2D.position.x+=45
	

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
	queue_free()

	pass # Replace with function body.
