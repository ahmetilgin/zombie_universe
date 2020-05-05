extends RigidBody2D

onready var coin_number =get_node("../Game_UI/Coin_Counter")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	$AnimatedSprite.play("coin")
	$Tween.interpolate_property($AnimatedSprite,'scale',$AnimatedSprite.scale,
								$AnimatedSprite.scale*1.5,0.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite,'modulate',Color(1,1,1,1),
								Color(1,1,1,0),0.3,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var gravity_force = Vector2(0, 3)  # gravity force
var velocity = Vector2()  # the area's velocity


var is_entered = false
func _on_area_body_entered(body):
	if "player" in body.name and !is_entered :
		is_entered = true
		coin_number.counting()
		$Sound.play()
		set_deferred("monitoring",true)
		$Tween.start()


	pass # Replace with function body.


func _on_Sound_finished():
	queue_free()
	pass # Replace with function body.
