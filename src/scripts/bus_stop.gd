extends Node2D

@onready var kick_scene = preload("res://scenes/kick.tscn")
@onready var kick = kick_scene.instantiate()
@onready var active = false
@onready var animation = $BusAnimationPlayer

@export var aim_speed := 1


func _ready():
	add_child(kick)
	kick.position.x = -1000
	spawn_bus()

func _process(delta):
	pass
	
func _physics_process(delta):
	if Input.is_action_just_pressed("Click"):
		spawn_kick()
	if active:
#		kick.rotation_degrees =  lerp(kick.rotation_degrees, rad_to_deg(get_angle_to(get_global_mouse_position())), aim_speed)
		kick.look_at(get_local_mouse_position())
	if Input.is_action_just_released("Click"):
		active = !active
		
func spawn_kick():
	kick.position = get_global_mouse_position()
	active = true

func spawn_bus():
	animation.play("bus_arrive")
	animation.queue("bus_open")
	
