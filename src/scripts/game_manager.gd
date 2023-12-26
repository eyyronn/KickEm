extends Node2D

@onready var kick = kick_scene.instantiate() as Kick
#@onready var blob = blob_scene.instantiate()
#@onready var active = false
#@onready var bus_anim = bus.anim

#@export var aim_speed := 1
@export var spawn_count := 5.0
@export var spawn_range := [100, 650]
@export var spawn_offset := [10, 50]

var all_passengers = []
var current_passenger_count = 5.0
var active_bus = null
var active_blob = null
var score = 0
var is_player_lost = false
var bus_incoming = false
var hit_stop_enabled = true
var difficulty = 0
var anti_gravity_enabled = false
var power_kick_enabled = false
var game_active = false

const passenger_scene = preload("res://scenes/passenger.tscn")
const bus_scene = preload("res://scenes/bus.tscn")
const kick_scene = preload("res://scenes/kick.tscn")
const blob_scene = preload("res://scenes/blob.tscn")

signal on_lose
signal on_restart
signal round_done

func _ready():
	add_child(kick)
	kick.position.x = -1000
	spawn_bus()

func _process(delta):
#	print_debug(power_kick_enabled)
#	print(kick.force)
	if game_active:
		if not active_bus and not bus_incoming:
			spawn_bus()
		
		if Input.is_action_just_pressed("Restart"):
			restart_game()
			emit_signal("on_restart")
			get_tree().reload_current_scene()
		
		if Input.is_action_just_pressed("Click"):
			spawn_kick()
		
		if power_kick_enabled:
			kick.force = 10
			
		if kick.is_charging:
	#		kick.rotation_degrees =  lerp(kick.rotation_degrees, rad_to_deg(get_angle_to(get_global_mouse_position())), aim_speed)
			kick.look_at(get_global_mouse_position())

		if current_passenger_count < spawn_count and active_blob == null:
				spawn_blob()
		
func _physics_process(delta):
	if game_active:
		for passenger in all_passengers:
			for limb in passenger.limbs:
				if anti_gravity_enabled:
					limb.gravity_scale = 0
		if hit_stop_enabled:
			if kick.success_hit() is Limb and kick.impact > 2:
				hit_stop(kick.impact)
		
func spawn_kick():
#	if game_active:
	kick.look_at(get_global_mouse_position())
	kick.position = get_global_mouse_position()
	
func spawn_bus():
	if game_active:
		var bus = bus_scene.instantiate() as Bus
		add_child(bus)
		bus_incoming = true
		active_bus = bus
		spawn_passengers()
		emit_signal("round_done")
#	print_debug("bus", active_blob, active_bus)

func spawn_blob():
#	if game_active:
	var blob = blob_scene.instantiate() as Blob
	add_child(blob)
	active_blob = blob
	active_blob.first_grow = true
#	print_debug("blob", active_blob, active_bus)

func spawn_passengers():
#	if game_active:
	for i in spawn_count:
		var passenger = passenger_scene.instantiate() as Passenger
		add_child(passenger)
		passenger.global_transform.origin = Vector2.ZERO
		passenger.global_transform.origin = Vector2(randf_range(spawn_range[0], spawn_range[1]), 506)
		passenger.global_transform.origin.x += randf_range(spawn_offset[0], spawn_offset[1])
		add_passenger(passenger)
		await get_tree().create_timer(randf_range(0.1,0.5)).timeout
	
func add_passenger(passenger):
#	if game_active:
	all_passengers.append(passenger)
	
func remove_passenger(passenger):
#	if game_active:
	current_passenger_count -= 1
	all_passengers.erase(passenger)
	
func round_complete():
#	if game_active:
	score += 1
	delete_blob()
	print("Next Round!")

func hit_stop(impact):
	kick.impact_sound.pitch_scale = (5 - kick.impact + 1) * 0.1
	kick.impact_sound.volume_db = kick.impact - 4
	kick.impact_sound.play()
#		print(1 - impact * 0.1 - 0.2)
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
	if active_bus != null:
		active_bus.queue_free()
		active_bus = null
	
	if active_blob != null:
		active_blob.queue_free()
		active_blob = null
		
	for passenger in all_passengers:
		if passenger != null:
			passenger.queue_free()
			passenger = null
		
func restart_game():
	all_passengers.clear()
	spawn_count = 5
	current_passenger_count = spawn_count
	emit_signal("on_restart")
	spawn_bus()
	
func delete_entities():
	if active_bus != null:
		active_bus.queue_free()
		active_bus = null
	
	if active_blob != null:
		active_blob.queue_free()
		active_blob = null
		
	for passenger in all_passengers:
		if passenger != null:
			passenger.queue_free()
			passenger = null
		
func delete_bus(bus):
	bus.queue_free()
	active_bus = null
	bus_incoming = false

func delete_blob():
#	remove_child(active_blob)
	active_blob.queue_free()
	active_blob = null
	current_passenger_count = spawn_count
	
func game_activation():
	game_active = true
	print(game_active)