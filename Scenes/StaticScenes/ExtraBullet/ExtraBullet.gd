extends Area2D


var gravity_force = Vector2(0, 3)  # gravity force
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not $Ground.is_colliding():
		set_global_position(get_global_position() + gravity_force)
	pass


func _on_ExtraBullet_body_shape_entered(body_id, body, body_shape, area_shape):
	if "player" in body.name:
		body.increase_bullet_count(10)
		queue_free()
	pass # Replace with function body.
