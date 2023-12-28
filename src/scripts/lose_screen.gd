extends Control

@onready var score = $MarginContainer/VBoxContainer/score
@onready var replay = $MarginContainer/HBoxContainer/VBoxContainer/replay as Button
@onready var menu = $MarginContainer/HBoxContainer/VBoxContainer/menu as Button
@onready var menu_scene = preload("res://scenes/UI/main_menu.tscn") as PackedScene
@onready var sfx = $AudioStreamPlayer2D
@onready var container = $MarginContainer

signal on_restart
signal on_menu

func _ready():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(container, "position", Vector2(0, 0), 0.5).from(Vector2(0, -500)).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
	sfx.play()
	game_over_score()
	replay.button_down.connect(on_replay_pressed)
	menu.button_down.connect(on_menu_pressed)
	connect("on_restart", GameManager.restart_game)
	connect("on_restart", GameManager.unpause_game)
	connect("on_menu", GameManager.delete_entities)
	GameManager.deactivate_game()
	
func game_over_score():
	var score_string = "SCORE: {str}"
	score.text = score_string.format({"str" : GameManager.score})

func on_replay_pressed() -> void:
	emit_signal("on_restart")
	get_tree().change_scene_to_file("res://scenes/bus_stop.tscn")
	
func on_menu_pressed() -> void:
	get_tree().change_scene_to_packed(menu_scene)
	emit_signal("on_menu")
