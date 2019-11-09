extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$CollisionShape2D.disabled=false
	


func _on_Area2D_body_entered(body):
	if "Zombie" in body.name:
		body.dead(1)
	if "player" in body.name:
		body.dead(1)


func _on_Timer_timeout():
	$CollisionShape2D.disabled=true
	
