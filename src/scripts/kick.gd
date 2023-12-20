extends StaticBody2D

#@export var constant_linear_velocity := Vector2(800, 0)
#@export var strength  := constant_linear_velocity

@onready var released = false
@onready var stress = 0
@onready var animation = $AnimationPlayer
@onready var charge_audio = $KickCharge
@onready var release_audio = $KickRelease

func _ready():
	pass
	
func _process(delta):
	var direction = global_transform.origin.direction_to(get_global_mouse_position())
	
	if Input.is_action_pressed("Click"):
		if stress < 5:
			stress += delta
			
	if Input.is_action_just_released("Click"):
		stress = round(stress)
		constant_linear_velocity = Vector2(500 * stress, 500 * stress) * direction
		stress = 0
		
#	print_debug(stress, constant_linear_velocity
	
func _physics_process(delta):
	if Input.is_action_just_pressed("Click"):
		charge_kick(delta)
		
		
	if Input.is_action_just_released("Click"):
		release_kick()
		
func _integrate_forces(state):
	pass
		
func charge_kick(delta):
	stress += 1
	charge_audio.play()
	animation.play("kick_ready")
	animation.queue("kick_charge")

func release_kick():
	charge_audio.stop()
	release_audio.play()
	animation.play("kick_release")
	
