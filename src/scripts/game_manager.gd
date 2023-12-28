extends Node2D

@onready var kick = kick_scene.instantiate() as Kick
@onready var clouds = $"Cloud Animation"

@export var spawn_count := 5.0
@export var spawn_range := [100, 650]
@export var spawn_offset := [10, 50]

var score = 0
var all_passengers = []
var current_passenger_count = 5.0
var active_bus = null
var active_blob = null
var hit_stop_enabled = true
var anti_gravity_enabled = false
var power_kick_enabled = false
var game_active = false
var game_is_paused = false

const passenger_scene = preload("res://scenes/passenger.tscn")
const bus_scene = preload("res://scenes/bus.tscn")
const kick_scene = preload("res://scenes/kick.tscn")
const blob_scene = preload("res://scenes/blob.tscn")

signal on_round_end
signal on_round_complete
signal on_resume
signal on_reset_ui

func _ready():
	start()

func _process(delta):
	if game_active:
		if not active_bus:
			spawn_bus()
		
		if Input.is_action_just_pressed("Click"):
			spawn_kick()
		
		if power_kick_enabled:
			hit_stop_enabled = false
			kick.force = 10
		else:
			hit_stop_enabled = true
			
		if kick.is_charging:
			kick.look_at(get_global_mouse_position())

		if current_passenger_count < spawn_count and active_blob == null:
			spawn_blob()
		
func _physics_process(delta):
	if game_active && all_passengers.size() > 0:
		for passenger in all_passengers:
			for limb in passenger.limbs:
				if anti_gravity_enabled:
					limb.gravity_scale = 0
			
		if hit_stop_enabled:
			if kick.success_hit() is Limb and kick.impact > 2:
				hit_stop(kick.impact)

func start():
	add_child(kick)
	kick.position.x = -1000
	spawn_bus()

func spawn_kick():
	kick.look_at(get_global_mouse_position())
	kick.position = get_global_mouse_position()
	
func spawn_bus():
	if game_active:
		var bus = bus_scene.instantiate() as Bus
		add_child(bus)
		active_bus = bus
		spawn_passengers()
		emit_signal("on_round_end")

func spawn_blob():
	var blob = blob_scene.instantiate() as Blob
	add_child(blob)
	active_blob = blob
	active_blob.first_grow = true

func spawn_passengers():
	for i in spawn_count:
		var passenger = passenger_scene.instantiate() as Passenger
		add_child(passenger)
		passenger.global_transform.origin = Vector2.ZERO
		passenger.global_transform.origin = Vector2(randf_range(spawn_range[0], spawn_range[1]), 506)
		passenger.global_transform.origin.x += randf_range(spawn_offset[0], spawn_offset[1])
		add_passenger(passenger)
	
func add_passenger(passenger):
	all_passengers.append(passenger)
	
func remove_passenger(passenger):
	current_passenger_count -= 1
	all_passengers.erase(passenger)
	
func round_complete():
	score += 1
	delete_blob()
	emit_signal("on_round_complete")

func hit_stop(impact):
	kick.impact_sound.pitch_scale = (5 - kick.impact + 1) * 0.1
	kick.impact_sound.volume_db = kick.impact - 4
	kick.impact_sound.play()

	Engine.time_scale = 1 - impact * 0.1 - 0.2
	await get_tree().create_timer(0.3, true, false, true).timeout
	Engine.time_scale = 1

func anti_gravity_on():
	anti_gravity_enabled = true
	await get_tree().create_timer(10).timeout
	anti_gravity_enabled = false

func power_kick_on():
	power_kick_enabled = true
	await get_tree().create_timer(3).timeout
	power_kick_enabled = false

func delete_entities():
	if game_active:
		if active_bus != null:
			remove_child(active_bus)
			active_bus = null

		if active_blob != null:
			remove_child(active_blob)
			active_blob = null

		for passenger in all_passengers:
			remove_child(passenger)
			passenger = null
			
func restart_game():
	delete_entities()
	all_passengers.clear()
	spawn_count = 5
	current_passenger_count = spawn_count
	score = 0
	game_active = true
	emit_signal("on_reset_ui")
	start()

func delete_bus(bus):
	bus.queue_free()
	active_bus = null

func delete_blob():
	if active_blob:
		active_blob.queue_free()
		active_blob = null
		current_passenger_count = spawn_count
	
func activate_game():
	game_active = true
	start()
	await get_tree().create_timer(0.0000000000000001).timeout
	restart_game()
	emit_signal("on_round_end")

func pause_game():
	game_is_paused = true
	game_active = false

func unpause_game():
	game_active = true

func resume_game():
	game_is_paused = false
	game_active = true
	return_state()
	emit_signal("on_resume")
	
func deactivate_game():
	if active_bus != null:
		remove_child(active_bus)
		active_bus = null

	if active_blob != null:
		remove_child(active_blob)
		active_blob = null

	for passenger in all_passengers:
		remove_child(passenger)
		passenger = null
	remove_child(kick)
	clouds.play()
	game_is_paused = false
	game_active = false
	
func stop_time():
	for passenger in all_passengers:
		passenger.anim.pause()
		for limb in passenger.limbs:
			print(limb)
			limb.gravity_scale = 0
			limb.lock_rotation = true
	active_bus.anim.pause()
	kick.animation.pause()
	if active_blob != null:
		active_blob.anim.pause()
	clouds.pause()
			
func return_state():
	game_is_paused = false
	active_bus.anim.play("", -1, 1.0, true )
	kick.animation.play("", -1, 1.0, true )
	if active_blob != null:
		active_blob.anim.play("", -1, 1.0, true )
	clouds.play()
	for passenger in all_passengers:
		passenger.anim.play()
		for limb in passenger.limbs:
			print(limb)
			limb.lock_rotation = false
			limb.gravity_scale = 2.5
			limb.freeze = false
