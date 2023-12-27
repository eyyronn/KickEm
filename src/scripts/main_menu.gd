extends Control

@onready var game_scene = "res://scenes/bus_stop.tscn"

signal play_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("play_pressed", GameManager.game_activation)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	



func _on_play_pressed():
	print("hiiiiiiiiiii")
	get_tree().change_scene_to_file(game_scene)
	emit_signal("play_pressed")


func _on_settings_pressed():
	print('asdjadad')
	
	
func _on_quit_pressed():
	get_tree().quit()
