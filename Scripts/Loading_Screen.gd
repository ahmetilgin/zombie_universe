extends Node2D

var time = 1

onready var parallel_load_stage = Thread.new()

func _ready():
	var start_scene = get_tree().get_root().get_node("Start_Screen")
	start_scene.connect("start_load_scene", self, "on_start_loading")
	pass
	
func _physics_process(delta):
		$TextureProgress.set_value(time)
		time=time+1

func on_start_loading():
	parallel_load_stage.start(self,"load_scene", ResourceLoader.load_interactive("res://Stages/Stage1.tscn"))


func load_scene(interactive_ldr):
	while (true):
	    var err = interactive_ldr.poll();
	    if(err == ERR_FILE_EOF):
	        call_deferred("_on_load_level_done");
	        return interactive_ldr.get_resource();

		
func _on_load_level_done():
	var level_res = parallel_load_stage.wait_to_finish()
	var scene = level_res.instance();
	$TextureProgress.set_value(1000)
	add_child(scene);
	emit_signal("level_load_completed")
	