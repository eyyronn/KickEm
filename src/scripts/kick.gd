extends StaticBody2D

#@export var constant_linear_velocity := Vector2(800, 0)
#@export var strength  := constant_linear_velocity

@onready var released = false
@onready var stress = 0
@onready var animation = $AnimationPlayer

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_pressed("Click"):
		if stress < 5:
			stress += delta
			
	if Input.is_action_just_released("Click"):
		
#		stress = round(stress)
#		print(stress)
#		constant_linear_velocity.x = 100 * stress**2
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
	animation.play("kick_ready")
	animation.queue("kick_charge")

func release_kick():
	animation.play("kick_release")


	
