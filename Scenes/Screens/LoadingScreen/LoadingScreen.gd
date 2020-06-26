extends Node2D

var game_count = 1
var time = 1

onready var parallel_load_stage = null
onready var start_scene = null
func _ready():
	on_start_loading();
	pass
	
	
func _physics_process(delta):
	if time < ($TextureProgress.max_value * 85 / 100):
		time=time + randi() % 30
		$TextureProgress.set_value(time)

func on_start_loading():
	parallel_load_stage = Thread.new()
	parallel_load_stage.start(self,"load_scene", 0)
	



func load_scene(interactive_ldr):
	$Camera2D._set_current(true)
	interactive_ldr = ResourceLoader.load_interactive("res://Stages/Game.tscn")
	while (true):
		var err = interactive_ldr.poll();
		if(err == ERR_FILE_EOF):
			call_deferred("_on_load_level");
			return interactive_ldr.get_resource();

		
func _on_load_level():
	var level_res = parallel_load_stage.wait_to_finish()
	$TextureProgress.set_value(1000)
	for node in get_tree().get_nodes_in_group("game_group"):
		node.queue_free()
	var scene = level_res.instance();
	scene.add_to_group("game_group")
	game_count = game_count + 1 
	scene.set_name("Game")
	get_tree().get_root().add_child(scene);
	queue_free()
	
	



