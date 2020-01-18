extends Area2D


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
	if dir==-1:
		$Sprite.flip_h=true
		$Sprite.position.x+=45
		$CollisionShape2D.position.x+=45

func _physics_process(delta):
	motion.x=speed*delta*direction
	translate(motion)
	pass
	
func _on_VisibilityEnabler2D_screen_exited():
	queue_free()
	pass # Replace with function body.
