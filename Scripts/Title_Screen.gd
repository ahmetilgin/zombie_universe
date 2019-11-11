extends Node
export(String,FILE,"*.tscn" )var stage_one
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	 pass


func _physics_process(delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/Start_Button.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/Start_Button.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/Quit_Button.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/Quit_Button.grab_focus()


func _on_Start_Button_pressed():
	get_tree().change_scene(stage_one)
	 


func _on_Quit_Button_pressed():
	get_tree().quit()
	pass # Replace with function body.

