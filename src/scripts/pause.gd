extends Control

@onready var main_menu = "res://scenes/UI/main_menu.tscn"

signal on_resume
signal on_restart
signal on_main_menu

func _ready():
	connect("on_resume", GameManager.resume_game)
	connect("on_restart", GameManager.restart_game)
	connect("on_main_menu", GameManager.deactivate_game)
	
func _on_resume_pressed():
	emit_signal("on_resume")
	
func _on_restart_pressed():
	emit_signal("on_resume")
	emit_signal("on_restart")

func _on_main_menu_pressed():
	emit_signal("on_main_menu")
	get_tree().change_scene_to_file(main_menu)

func _on_quit_pressed():
	get_tree().quit()



