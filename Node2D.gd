extends Node2D
export(String,FILE,"*.tscn" )var stage_one
var time=1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
func _physics_process(delta):
		$TextureProgress.set_value(time)
		time=time+1
		if time>1000:
			get_tree().change_scene(stage_one)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
