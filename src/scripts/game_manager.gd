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
var hit_stop_enabled = true

const passenger_scene = preload("res://scenes/passenger.tscn")
const bus_scene = preload("res://scenes/bus.tscn")
const kick_scene = preload("res://scenes/kick.tscn")
const blob_scene = preload("res://scenes/blob.tscn")

signal on_lose
signal on_restart


func _ready():
	add_child(kick)
	kick.position.x = -1000
	spawn_bus()

func _process(delta):
	
	if Input.is_action_just_pressed("Restart"):
		restart_game()
		emit_signal("on_restart")
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("Click"):
		spawn_kick()
		
	if kick.is_charging:
#		kick.rotation_degrees =  lerp(kick.rotation_degrees, rad_to_deg(get_angle_to(get_global_mouse_position())), aim_speed)
		kick.look_at(get_global_mouse_position())
	
	if (spawn_count - current_passenger_count == 1.0) and active_blob == null:
		spawn_blob()
		active_blob.first_grow = true
		
func _physics_process(delta):
	if kick.success_hit() is Limb and kick.impact > 2:
		hit_stop(kick.impact)
		
func spawn_kick():
	kick.position = get_global_mouse_position()

func spawn_bus():
	var bus = bus_scene.instantiate() as Bus
	add_child(bus)
	active_bus = bus
	spawn_passengers()
#	print_debug("bus", active_blob, active_bus)

func spawn_blob():
	var blob = blob_scene.instantiate() as Blob
	add_child(blob)
	active_blob = blob
#	print_debug("blob", active_blob, active_bus)

func spawn_passengers():
	for i in spawn_count:
		var passenger = passenger_scene.instantiate() as Passenger
		add_child(passenger)
		passenger.global_transform.origin = Vector2.ZERO
		passenger.global_transform.origin = Vector2(randf_range(spawn_range[0], spawn_range[1]), 506)
		passenger.global_transform.origin.x += randf_range(spawn_offset[0], spawn_offset[1])
		add_passenger(passenger)
		await get_tree().create_timer(randf_range(0.1,0.5)).timeout
		
func add_passenger(passenger):
	all_passengers.append(passenger)
	
func remove_passenger(passenger):
	current_passenger_count -= 1
	all_passengers.erase(passenger)
	
func bus_go():
	score += 1

func hit_stop(impact):
	if hit_stop_enabled:
#		print(1 - impact * 0.1 - 0.2)
		Engine.time_scale = 1 - impact * 0.1 - 0.2
		await get_tree().create_timer(0.3, true, false, true).timeout
		Engine.time_scale = 1

func restart_game():
	if active_bus != null:
		active_bus.queue_free()
		
	for i in all_passengers.size():
		all_passengers[i].queue_free()
		
	all_passengers.clear()
	spawn_count = 5
	current_passenger_count = spawn_count
	spawn_bus()

	

