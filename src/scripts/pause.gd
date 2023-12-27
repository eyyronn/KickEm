extends Control

@onready var main_menu = "res://scenes/main_menu.tscn"

signal resume
signal on_restart
signal on_main_menu

func _ready():
	connect("resume", GameManager.pause_to_gm)
#	GameManager.connect("on_restart", _on_restart_pressed)
	connect("on_restart", GameManager.pause_on_restart)
	connect("on_main_menu", GameManager.deactivate_game)
	
func _on_resume_pressed():
	emit_signal("resume")
	
func _on_restart_pressed():
	emit_signal("resume")
	emit_signal("on_restart")
	
func _on_settings_pressed():
	pass # Replace with function body.

func _on_main_menu_pressed():
	emit_signal("on_main_menu")
#	emit_signal("resume")
#	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(main_menu)

func _on_quit_pressed():
	get_tree().quit()
