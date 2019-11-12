extends KinematicBody2D
var velocity=Vector2(0,0)
var gravity=Vector2(0,30)
var down=1
# onready var floore=get_node("Stage1")

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
	if down==-1:
		 
		set_global_position(get_global_position()+gravity*delta*5)
	else:
		 
		set_global_position(get_global_position()-gravity*delta*5)
		
	
	
	

func _on_Timer_timeout():
	down*=-1


func _on_Area2D_body_exited(body):
	if "player" in body.name:
		body.dead(101)
	if "Zombie" in body.name:
		body.dead(101) 
