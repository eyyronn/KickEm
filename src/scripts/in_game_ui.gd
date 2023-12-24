extends Control

@onready var progress_bar = $ProgressBar
@onready var score_label = $Score

var progress_bar_speed = 4.0
var smooth_val = 0.0

signal enable_anti_gravity
signal enable_power_kick

func _ready():
	GameManager.connect("on_lose", open_lose_screen)
	GameManager.connect("on_restart", restart_scene)
	connect("enable_power_kick", GameManager.power_kick_on)
	connect("enable_power_kick", GameManager.anti_gravity_on)

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

func _on_anti_gravity_pressed():
	print("p")
	emit_signal("enable_anti_gravity")

func _on_power_kick_pressed():
	print("s")
	emit_signal("enable_power_kick")
