extends Node2D

func _ready():
	var shadow_module = CanvasModulate.new()
	shadow_module.set_color(Color( 0.5, 0.5, 0.5, 1 ))
	shadow_module.set_name("overlay")
	get_tree().get_root().add_child(shadow_module)
	shadow_module.set_z_index(1)
	pass 
