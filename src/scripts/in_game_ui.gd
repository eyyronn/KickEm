extends Control

func _ready():
	GameManager.connect("on_lose", open_lose_screen)
	GameManager.connect("on_restart", restart_scene)

func _process(delta):
	pass

func open_lose_screen():
	pass

func restart_scene():
	get_tree().reload_current_scene()
	

