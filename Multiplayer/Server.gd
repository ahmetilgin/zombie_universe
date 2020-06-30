extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting the server ...")
	print("Server port: " + str(global.SERVER_PORT))
	print("Max players: " + str(global.MAX_PLAYERS))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
