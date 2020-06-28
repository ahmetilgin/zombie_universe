extends Area2D

var blood_anim = preload("res://Scenes/StaticScenes/BloodAnimation/BloodAnimation.tscn")
var motion=Vector2()
var direction=1
const speed=1000

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_bullet_direction(dir):
	direction=dir
	$Sprite.play("shoots")
func _physics_process(delta):
	motion.x=speed*delta*direction
	translate(motion)
	
func _on_VisibilityEnabler2D_screen_exited():
	queue_free()


func _on_TrackedBullet_body_shape_entered(body_id, body, body_shape, area_shape):
	if "Zombie" in body.name:
		body.dead(5,"player") 
		var blood_instance = blood_anim.instance()
		body.add_child(blood_instance)
		blood_instance.set_global_position(get_global_position())
	queue_free()
	pass # Replace with function body.
