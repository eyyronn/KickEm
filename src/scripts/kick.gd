extends StaticBody2D
class_name Kick

#@export var constant_linear_velocity := Vector2(800, 0)

@onready var released = false
@onready var animation = $AnimationPlayer

func _ready():
	pass
	
func _process(delta):
	pass
	
func _physics_process(delta):
	if Input.is_action_just_pressed("Click"):
		charge_kick()
	if Input.is_action_just_released("Click"):
		release_kick()
		
func _integrate_forces(state):
	pass
		
func charge_kick():
	animation.play("kick_ready")
	animation.queue("kick_charge")

func release_kick():
	animation.play("kick_release")
		
	
