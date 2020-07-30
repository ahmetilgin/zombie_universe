extends Node2D
onready var coin_count =get_node("../../Game_UI/Coin_Counter")
var restart_screen = preload("res://Scenes/Screens/LoadingScreen/LoadingScreen.tscn")

func _ready():
	var screen_hide=get_parent().get_parent().get_node("player")
	screen_hide.connect("dead_signal",self,"on_dead_signal")
	visible = false

func on_dead_signal():
	visible=true
	$dead_zombie_text/dead_zombie_counter.text=String(get_parent().get_parent().get_node("player").killed_counter)
	$Coin/Coin_count.text=String( coin_count.count)

func _physics_process(delta):
	if $MarginContainer/CenterContainer/VBoxContainer/start.is_hovered():
		 $MarginContainer/CenterContainer/VBoxContainer/start.grab_focus()
	if  $MarginContainer/CenterContainer/VBoxContainer/quit.is_hovered():
		 $MarginContainer/CenterContainer/VBoxContainer/quit.grab_focus()

func _on_quit_pressed():
	get_tree().quit()

func _on_start_pressed():
	var instance_restart = restart_screen.instance()
	get_tree().get_root().add_child(instance_restart)
	get_tree().get_root().get_node("overlay").queue_free()
	visible = false


func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	save_nodes.invert()
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function
		var node_data = node.call("save")
#		print(node_data)
		# Store the save dictionary as a new line in the save file
		save_game.store_line(to_json(node_data))
	save_game.close()

func _on_save_pressed():
	save_game()
	pass # Replace with function body.
