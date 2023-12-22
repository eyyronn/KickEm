extends StaticBody2D
#class_name Kick

@onready var animation = $AnimationPlayer
@onready var charge_audio = $KickCharge
@onready var release_audio = $KickRelease

#@export var constant_linear_velocity := Vector2(800, 0)
#@export var strength  := constant_linear_velocity
@export var force_multiplier := Vector2(500, 500)

var is_charging : bool
var released : bool
var force : float = 0
var impact : int

func _ready():
	pass
	
func _process(delta):
	var direction = global_transform.origin.direction_to(get_global_mouse_position())
	
	if Input.is_action_pressed("Click"):
		if force < 5:
			force += delta
#			print(force, delta)
				
	if Input.is_action_just_released("Click"):
		force = round(force)	
		constant_linear_velocity = force_multiplier * Vector2(force, force) * direction
		impact = force
		force = 0
#	print_debug(force, constant_linear_velocity
	
func _physics_process(delta):
	if Input.is_action_just_pressed("Click"):
		charge_kick(delta)
		
	if Input.is_action_just_released("Click"):
		release_kick()

func _integrate_forces(state):
	pass
		
func charge_kick(delta):
	is_charging = true
	force += 1
	charge_audio.play()
	animation.play("kick_ready")
	animation.queue("kick_charge")

func release_kick():
	is_charging = false
	charge_audio.stop()
	release_audio.play()
	animation.play("kick_release")
	

	
	

	
