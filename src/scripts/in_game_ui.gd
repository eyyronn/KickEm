extends Control

@onready var progress_bar = $ProgressBar
@onready var score_label = $Score
@onready var anti_gravity = $AntiGravity
@onready var power_kick = $PowerKick
@onready var round_timer = $RoundTime
@onready var round_time = $RoundTime/Round_TIME
@onready var lose_screen = preload("res://scenes/UI/lose_screen.tscn") as PackedScene

var progress_bar_speed = 4.0
var smooth_val = 0.0
var sec = 30
@onready var paused_menu = $Pause
var paused = false

@onready var ag_cooldown = $AntiGravity/AG_Cooldown
@onready var ag_cooldown_percentage
@onready var ag_button = $AntiGravity/AntiGravity
@onready var pk_cooldown = $PowerKick/PK_Cooldown
@onready var pk_cooldown_percentage
@onready var pk_button = $PowerKick/PowerKick

signal enable_anti_gravity
signal enable_power_kick
signal game_is_paused
signal game_not_paused

func _ready():
	GameManager.connect("pause_timer", Timer_pause)
	GameManager.connect("round_done", Reset_Timer)
	GameManager.connect("on_lose", open_lose_screen)
	GameManager.connect("on_restart", restart_scene)
	GameManager.connect("on_resume", pause_menu)
	GameManager.connect("restarted", restarted)
	connect("enable_power_kick", GameManager.power_kick_on)
	connect("enable_anti_gravity", GameManager.anti_gravity_on)
	connect("game_is_paused", GameManager.game_paused)
	connect("game_not_paused", GameManager.game_unpaused)

func _process(delta):
	update_score()
	update_progress_bar(delta)
	Round_Timer()
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
			
	if Input.is_action_just_pressed("Pause"):
		pause_menu()
		
func update_progress_bar(delta):
	progress_bar.max_value = GameManager.spawn_count
	smooth_val = lerp(smooth_val, GameManager.spawn_count - GameManager.current_passenger_count, delta * progress_bar_speed)
	progress_bar.value = smooth_val
		
func update_score():
	var score_string = "Buses Packed: {str}"
	score_label.text = score_string.format({"str" : GameManager.score})

func open_lose_screen():
	get_tree().change_scene_to_packed(lose_screen)


func restart_scene():
	get_tree().reload_current_scene()

#func _on_power_kick_pressed():
#	print("s")
#	emit_signal("enable_power_kick")

func _on_ag_cooldown_timeout():
	ag_button.disabled = false

func _on_anti_gravity_pressed():
#	print("ag")
	emit_signal("enable_anti_gravity")
	ag_button.disabled = true
	ag_cooldown.start()


func _on_pk_cooldown_timeout():
	pk_button.disabled = false

func _on_power_kick_pressed():
#	print("ag")
	emit_signal("enable_power_kick")
	pk_button.disabled = true
	pk_cooldown.start()
	
var new_sec = sec

func Reset_Timer():
	$RoundTime.paused = false
	sec = new_sec + (GameManager.score * 5)
	sec = min(sec, 60)
	
	Round_Timer()
	$RoundTime.start()
	
func Round_Timer():
	$RoundTime.set_wait_time(sec)
	$RoundTime/Round_TIME.text = str(round($RoundTime.time_left))

func _on_round_time_timeout() -> void:
	if progress_bar.value != GameManager.spawn_count or GameManager.active_blob != null:
		open_lose_screen()

func Timer_pause():
	$RoundTime.paused = true
	
func pause_menu():
	if paused:
		paused_menu.hide()
#		Engine.time_scale = 1
		$RoundTime.paused = false
		emit_signal("game_not_paused")
	else:
		paused_menu.show()
#		Engine.time_scale = 0.01
		$RoundTime.paused = true
		emit_signal("game_is_paused")
		
	paused = !paused
	
func restarted():
	ag_cooldown.start()
	pk_cooldown.start()

		
