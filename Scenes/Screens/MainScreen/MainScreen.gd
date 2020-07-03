extends Node

var loading_screen = preload("res://Scenes/Screens/LoadingScreen/LoadingScreen.tscn")
var loading_screen_instance = null
func _ready():
	pass
	
func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/Start_Button.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/Start_Button.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/Quit_Button.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/Quit_Button.grab_focus()

func go_to_loading_screen():
	loading_screen_instance = loading_screen.instance()
	get_tree().get_root().add_child(loading_screen_instance)

func _on_Start_Button_pressed():
	go_to_loading_screen()
	loading_screen_instance.set_continue_clicked(false)
	queue_free()

func _on_Quit_Button_pressed():
	get_tree().quit()
	pass # Replace with function body.

func _on_Continue_Button_pressed():
	loading_screen_instance = loading_screen.instance()
	loading_screen_instance.set_continue_clicked(true)
	get_tree().get_root().add_child(loading_screen_instance)
	pass # Replace with function body.
