extends Node2D

var game_count = 1
var time = 1

onready var parallel_load_stage = null
onready var start_scene = null
var is_continue = false
func _ready():
	on_start_loading();
	pass

func set_continue_clicked(is_clicked):
	is_continue = is_clicked
	
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
	var scene = level_res.instance();
	scene.is_continue = is_continue
	if(get_tree().get_root().get_node("Game") != null):
		get_tree().get_root().get_node("Game").queue_free()
		get_tree().get_root().remove_child(get_tree().get_root().get_node("Game"))
#	get_tree().get_root().print_tree_pretty()
	get_tree().get_root().add_child(scene);
	scene.set_name("Game")
#	get_tree().get_root().print_tree_pretty()

	if is_continue:
		load_game()
		scene.init()
	queue_free()
	
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.load_data(node_data)
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "position_x" or i == "position_y":
				continue
			new_object.set(i, node_data[i])
	save_game.close()







