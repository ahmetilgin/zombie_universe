extends Node2D
var dead_counter=0
func _ready():
	var screen_hide=get_parent().get_parent().get_node("player")
	screen_hide.connect("dead_signal",self,"on_dead_signal")
	var dead_zombie_counter_basic=get_parent().get_parent().get_node("Basic_Zombie")
	dead_zombie_counter_basic.connect("dead_counter",self,"on_dead_zombie_counter")
	var dead_zombie_counter_big=get_parent().get_parent().get_node("Big_Zombie")
	dead_zombie_counter_big.connect("dead_counter",self,"on_dead_zombie_counter")
	var dead_zombie_counter_follow=get_parent().get_parent().get_node("Female_Zombie")
	dead_zombie_counter_follow.connect("dead_counter",self,"on_dead_zombie_counter")
	var dead_zombie_counter_punk=get_parent().get_parent().get_node("Punk_Zombie")
	dead_zombie_counter_punk.connect("dead_counter",self,"on_dead_zombie_counter")
func on_dead_zombie_counter():
	dead_counter+=1
	$dead_zombie_text/dead_zombie_counter.text=String(dead_counter)
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
