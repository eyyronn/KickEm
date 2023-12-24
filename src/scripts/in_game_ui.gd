extends Control

@onready var progress_bar = $ProgressBar
@onready var score_label = $Score

var progress_bar_speed = 4.0
var smooth_val = 0.0

func _ready():
	GameManager.connect("on_lose", open_lose_screen)
	GameManager.connect("on_restart", restart_scene)

func _process(delta):
	update_score()
	
	progress_bar.max_value = GameManager.spawn_count
	smooth_val = lerp(smooth_val, GameManager.spawn_count - GameManager.current_passenger_count, delta * progress_bar_speed)
	progress_bar.value = smooth_val

func update_score():
	var score_string = "Buses Packed: {str}"
	score_label.text = score_string.format({"str" : GameManager.score})

func open_lose_screen():
	pass

func restart_scene():
	get_tree().reload_current_scene()
	

