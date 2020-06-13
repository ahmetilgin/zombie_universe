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
