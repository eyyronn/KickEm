extends Control

@onready var score = $MarginContainer/VBoxContainer/score
@onready var replay = $MarginContainer/HBoxContainer/VBoxContainer/replay as Button
@onready var menu = $MarginContainer/HBoxContainer/VBoxContainer/menu as Button
@onready var menu_scene = preload("res://scenes/main_menu.tscn") as PackedScene

signal on_restart_game
signal on_menu

func _ready():
	game_over_score()
	replay.button_down.connect(on_replay_pressed)
	menu.button_down.connect(on_menu_pressed)
	connect("on_restart_game", GameManager.restart_game)
	connect("on_menu", GameManager.main_menu)
	GameManager.delete_entities
	
func game_over_score():
	var score_string = "SCORE: {str}"
	score.text = score_string.format({"str" : GameManager.score})

func on_replay_pressed() -> void:
	emit_signal("on_restart_game")
	get_tree().change_scene_to_file("res://scenes/bus_stop.tscn")
	
func on_menu_pressed() -> void:
	emit_signal("on_menu")
	get_tree().change_scene_to_packed(menu_scene)
	
