extends Area2D

const speed = 1000

var direction = Vector2()
var motion = Vector2()

func _ready():
	set_global_position(get_parent().get_node("Base/Top/Radar/Position2D").get_global_position())

func fire(zombie_position):
	var degree = get_parent().get_node("Base/Top/Radar").get_rotation_degrees()
	if degree < 0:
		degree = degree + 360
	
	degree = degree + 90
	var x_dir = cos(deg2rad(degree))
	var y_dir = sin(deg2rad(degree))
	direction = Vector2(x_dir,y_dir)
	
func _physics_process(delta):
	motion = speed * delta * direction
	translate(motion)
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass


func _on_bullet_body_entered(body):
	if "Zombie" in body.name:
		body.dead(1,"player") 
	queue_free()

