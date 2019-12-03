extends Area2D


func _ready():
	pass # Replace with function body.


func _on_upgrade_body_entered(body):
	if "player" in body.name:
		body.upgrade_power_up()
		queue_free()
