extends Node


signal start_load_scene
onready var loading_screen =preload("res://Main_Screen/Loading_Screen.tscn")

func _ready():
	 pass


func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/Start_Button.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/Start_Button.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/Quit_Button.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/Quit_Button.grab_focus()

func go_to_loading_screen():
	add_child(loading_screen.instance())

func _on_Start_Button_pressed():
	go_to_loading_screen()
	emit_signal("start_load_scene")

func _on_Quit_Button_pressed():
	get_tree().quit()
	pass # Replace with function body.

