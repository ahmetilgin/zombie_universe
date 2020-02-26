extends Node



onready var loading_screen = null
func _ready():
	loading_screen = preload("res://Scenes/Screens/LoadingScreen/LoadingScreen.tscn").instance()


func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/Start_Button.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/Start_Button.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/Quit_Button.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/Quit_Button.grab_focus()

func go_to_loading_screen():
	get_tree().get_root().add_child(loading_screen)

func _on_Start_Button_pressed():
	go_to_loading_screen()
	loading_screen.on_start_loading()
	queue_free()


func _on_Quit_Button_pressed():
	get_tree().quit()
	pass # Replace with function body.

