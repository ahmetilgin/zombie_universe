extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("mdoulate çağrıldı.")
	var shadow_module = CanvasModulate.new()
	shadow_module.set_color(Color( 0, 0, 0, 1 ))
	shadow_module.set_name("modulets")
	get_tree().get_root().add_child(shadow_module)
	print(shadow_module.get_global_position(),shadow_module)
	shadow_module.set_z_index(1)
	print_tree_pretty()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
