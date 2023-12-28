extends Control

@onready var progress_bar = $ProgressBar
@onready var score_label = $Score
@onready var anti_gravity = $AntiGravity
@onready var power_kick = $PowerKick
@onready var round_timer = $RoundTimer
@onready var round_timer_label = $RoundTimer/RoundTimerLabel
@onready var blur = $Blur
@onready var shade = $ColorRect
@onready var lose_screen = preload("res://scenes/UI/lose_screen.tscn") as PackedScene
@onready var pause = $Pause

var progress_bar_speed = 4.0
var smooth_val = 0.0
var sec = 60
var paused = false
var new_sec = sec

@onready var ag_cooldown = $AntiGravity/AGCooldown
@onready var ag_cooldown_percentage
@onready var ag_button = $AntiGravity/AntiGravity
@onready var pk_cooldown = $PowerKick/PKCooldown
@onready var pk_cooldown_percentage
@onready var pk_button = $PowerKick/PowerKick

signal enable_anti_gravity
signal enable_power_kick
signal on_game_pause
signal on_game_unpause

func _ready():
	GameManager.connect("on_round_complete", pause_timer)
	GameManager.connect("on_round_end", reset_timer)
	GameManager.connect("on_resume", toggle_pause_menu)
	GameManager.connect("on_reset_ui", reset_ui)
	connect("enable_power_kick", GameManager.power_kick_on)
	connect("enable_anti_gravity", GameManager.anti_gravity_on)
	connect("on_game_pause", GameManager.pause_game)
	connect("on_game_unpause", GameManager.unpause_game)
	reset_timer()

func _process(delta):
	update_score()
	update_progress_bar(delta)
	set_timer()
	if ag_cooldown.time_left > 0:
		ag_cooldown_percentage = (
			(1 - ag_cooldown.time_left / ag_cooldown.wait_time) * 100
			)
		anti_gravity.value = ag_cooldown_percentage
		if paused:
			ag_cooldown.paused = true
		else:
			ag_cooldown.paused = false
		
	if pk_cooldown.time_left > 0:
		pk_cooldown_percentage = (
			(1 - pk_cooldown.time_left / pk_cooldown.wait_time) * 100
			)
		power_kick.value = pk_cooldown_percentage
		if paused == true:
			pk_cooldown.paused = true
		else:
			pk_cooldown.paused = false
			
func update_progress_bar(delta):
	progress_bar.max_value = GameManager.spawn_count
	smooth_val = lerp(smooth_val, GameManager.spawn_count - GameManager.current_passenger_count, delta * progress_bar_speed)
	progress_bar.value = smooth_val
		
func update_score():
	var score_string = "Buses Packed: {str}"
	score_label.text = score_string.format({"str" : GameManager.score})

func open_lose_screen():
	get_tree().change_scene_to_packed(lose_screen)

func _on_ag_cooldown_timeout():
	ag_button.disabled = false

func _on_anti_gravity_pressed():
	emit_signal("enable_anti_gravity")
	ag_button.disabled = true
	ag_cooldown.start()

func _on_pk_cooldown_timeout():
	pk_button.disabled = false

func _on_power_kick_pressed():
	emit_signal("enable_power_kick")
	pk_button.disabled = true
	pk_cooldown.start()

func reset_timer():
	round_timer.paused = false
	sec = new_sec + (GameManager.score * 5)
	sec = min(sec, 60)
	
	set_timer()
	round_timer.start()
	
func set_timer():
	round_timer.set_wait_time(sec)
	round_timer_label.text = str(round(round_timer.time_left))

func _on_round_time_timeout() -> void:
	if progress_bar.value != GameManager.spawn_count or GameManager.active_blob != null:
		open_lose_screen()

func pause_timer():
	round_timer.paused = true
	
func toggle_pause_menu():
	if paused:
		blur.hide()
		shade.hide()
		pause.hide()
#		Engine.time_scale = 1
		round_timer.paused = false
		emit_signal("on_game_unpause")
	else:
		blur.show()
		shade.show()
		pause.show()
#		Engine.time_scale = 0.01
		round_timer.paused = true
		emit_signal("on_game_pause")
		
	paused = !paused
	
func reset_ui():
	ag_cooldown.start()
	pk_cooldown.start()

func _on_pause_button_button_down():
	toggle_pause_menu()
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_method(set_blur, 0.0, 2.5, 0.5)
	tween.tween_property(shade, "modulate", Color(1, 1, 1, 1), 0.5).from(Color(1, 1, 1, 0))
	tween.tween_property(pause, "position", Vector2(-577, -236), 0.5).from(Vector2(-1025, -236)).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
	GameManager.stop_time()

func set_blur(value : float):
	blur.material.set_shader_parameter("lod", value)
