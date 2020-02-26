extends Node2D

var time = 1

onready var parallel_load_stage = null
var start_scene = null
func _ready():
	pass
	
	
func _physics_process(delta):
		if time < ($TextureProgress.max_value * 85 / 100):
			time=time + randi() % 30
			$TextureProgress.set_value(time)

func on_start_loading():
	parallel_load_stage = Thread.new()
	parallel_load_stage.start(self,"load_scene", ResourceLoader.load_interactive("res://Stages/Game.tscn"))


func load_scene(interactive_ldr):
	while (true):
		var err = interactive_ldr.poll();
		if(err == ERR_FILE_EOF):
			call_deferred("_on_load_level");
			return interactive_ldr.get_resource();

		
func _on_load_level():
	var level_res = parallel_load_stage.wait_to_finish()
	$TextureProgress.set_value(1000)
	var scene = level_res.instance();
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().get_root().add_child(scene);
	queue_free()
	
	



