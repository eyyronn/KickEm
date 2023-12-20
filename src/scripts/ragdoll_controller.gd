extends Node2D
class_name Passenger

@onready var shadow = $Shadow
@onready var torso = $Torso

var initial_y = 0.0
var limbs = []

@export var center_of_mass := Vector2(0.0, 0.0)
@export var controllable := false
@export var movement_power := 500.0

# @export_flags_2d_physics var layers_2d_physics
# @export_flags_2d_render var layers_2d_render
# @onready var limb_script = preload("res://src/scripts/limb.gd")

func _ready():
	for limb in get_children():
		if limb is Limb: limbs.append(limb)
		
	for limb in limbs:
		limb.center_of_mass = center_of_mass

func _process(delta):
	for limb in limbs:
		if limb.name == "Torso":
			update_shadow(limb)

func _physics_process(delta):		
	for limb in limbs:
		if limb.enabled == true:

			if controllable:
				control_ragdoll(limb)	

#			if limb.name.ends_with("arm") or limb.name.ends_with("Hand"):
#				pivot_arm(limb, delta)
#				continue

			correct_rotation(limb, delta)	
			
#func _integrate_forces(state):
#	for limb in limbs:
#		if limb.enabled == true:
#
#			if controllable:
#				control_ragdoll(limb)	
#
##			if limb.name.ends_with("arm") or limb.name.ends_with("Hand"):
##				pivot_arm(limb, delta)
##				continue
#
#			correct_rotation(limb, state)	
		
func correct_rotation(limb, delta):
	var current_angle = limb.rotation;
	
	var heading_vector = Vector2.ZERO;
	heading_vector.x = cos(limb.desired_angle);
	heading_vector.y = sin(limb.desired_angle);

	var current_vector = Vector2.ZERO;
	current_vector.x = cos(current_angle);
	current_vector.y = sin(current_angle);

	var magnitude = current_vector.distance_to(heading_vector);
	var applied_force = limb.force;
	
	limb.angular_velocity = lerp_angle(current_angle, limb.desired_angle, (limb.force) * delta);
		
# Supposed to restrict arm movement to an arc
#func pivot_arm(limb, delta):
#	var current_angle = limb.rotation
#
#	if not (current_angle <= 0 and current_angle > -120):
#		var new_rot = clamp(current_angle, -120, 0)
#		limb.desired_angle = new_rot
#
#		correct_rotation(limb, delta)

# Pull ragdoll on mouse click position // for debug
func control_ragdoll(limb):
	if Input.is_action_just_pressed("Click"):
		var velocity_vector = get_global_mouse_position() - limb.global_position     
		velocity_vector = velocity_vector.normalized()
		limb.apply_impulse(velocity_vector * movement_power)
	
	# Push ragdoll away on mouse release
#	elif Input.is_action_just_released("Click"):
#		var velocity_vector = get_global_mouse_position() - limb.global_position
#		velocity_vector = velocity_vector.normalized()     
#		limb.apply_impulse(velocity_vector * -1)

func update_shadow(target):
	shadow.position = Vector2(target.position.x - 40, target.position.y)
	shadow.position.y = clamp(shadow.position.y, 80, 80)
	shadow.scale.x = 1.25 + target.position.y * 0.00375
	shadow.scale.x = clamp(shadow.scale.x, 0, 100)
#	print_debug(target.position.y * 0.01, shadow.scale.x)
