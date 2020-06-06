extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var shadow_module = CanvasModulate.new()
	shadow_module.set_color(Color( 0.5, 0.5, 0.5, 1 ))
	shadow_module.set_name("overlay")
	get_tree().get_root().add_child(shadow_module)
	shadow_module.set_z_index(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
