extends Node2D

func _ready():
	var screen_hide=get_parent().get_parent().get_node("player")
	screen_hide.connect("dead_signal",self,"on_dead_signal")
	
func on_dead_signal():
	visible=true
	


	pass # Replace with function body.





func _physics_process(delta):
	if $MarginContainer/CenterContainer/VBoxContainer/start.is_hovered():
		 $MarginContainer/CenterContainer/VBoxContainer/start.grab_focus()
	if  $MarginContainer/CenterContainer/VBoxContainer/quit.is_hovered():
		 $MarginContainer/CenterContainer/VBoxContainer/quit.grab_focus()



func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_start_pressed():

	pass # Replace with function body.
