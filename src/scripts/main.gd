extends Node2D

func _ready():
	GameManager.connect("on_restart", restart_scene)
#	GameManager.connect("reload", restart_scene)
	
func restart_scene():
	GameManager.restart_game()
