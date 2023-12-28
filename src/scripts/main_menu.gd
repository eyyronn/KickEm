extends Control

@onready var game_scene = "res://scenes/bus_stop.tscn"

signal on_play_pressed

func _ready():
	connect("on_play_pressed", GameManager.activate_game)
	
func _on_play_pressed():
	get_tree().change_scene_to_file(game_scene)
	emit_signal("on_play_pressed")

func _on_quit_pressed():
	get_tree().quit()
