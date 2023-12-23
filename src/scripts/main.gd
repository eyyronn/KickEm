extends Node2D

func _ready():
	GameManager.connect("on_restart", restart_scene)
	
func restart_scene():
	pass

