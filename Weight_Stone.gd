extends StaticBody2D
var velocity=Vector2(0,0)
var gravity=30
var down=true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	"""
	if down==true:
		velocity.y+=gravity
		
	if is_on_floor():
		down=false
		velocity.y-=gravity
		$Timer.start()
	print(get_floor_velocity())
	velocity=move_and_slide(velocity,Vector2(0,-1))
	"""
	set_constant_linear_velocity(Vector2(0,30))
	get_constant_linear_velocity()

func _on_Timer_timeout():
	down=true


func _on_Area2D_body_exited(body):
	if "player" in body.name:
		body.dead(50)
	if "Zombie" in body.name:
		body.dead(50) 
