extends Node2D
class_name Passenger

@onready var shadow = $Shadow
@onready var torso = $Torso
@onready var anim = $PassengerPlayer
@onready var area = $Torso/Area2D
@onready var absorb = $AbsorbSound

@export var center_of_mass := Vector2(0.0, 40.0)
@export var controllable := false
@export var movement_power := 500.0
# @export_flags_2d_physics var layers_2d_physics
# @export_flags_2d_render var layers_2d_render
# @onready var limb_script = preload("res://src/scripts/limb.gd")
#var initial_y = 0.0

var limbs = []
var size = 10
var is_on_bus = false
var type : int
var gravity = 2.5

func _ready():
	initialize_limbs()
	initialize_type()
		
func initialize_limbs():
	for limb in get_children():
		if limb is Limb: limbs.append(limb)

func initialize_type():
	var available_types = get_available_types()
	type = available_types[randi_range(0, available_types.size() - 1)]
	
	match type:
		0:	
			size = 10
		1: 	
			size = 20
		2:	
			size = 30
		3:	
			size = 40
		4:	
			size = 50
			
	set_weight(size * 4.0)
	
func get_available_types():
	var available_types = [0]
	match GameManager.difficulty:
		1:	
			available_types.append(1)
		2:	
			available_types.append(2)
		3:	
			available_types.append(3)
		4:	
			available_types.append(4)
			
	return available_types
	
func set_weight(weight):
	for limb in limbs:
		limb.center_of_mass = Vector2(0.0, weight)
		
func _process(delta):	
	set_gravity()
	for limb in limbs:
		
		if limb.name == "Torso" and not is_on_bus:
			update_shadow(limb)
#			self.position = limb.global_position

func set_gravity():
#	var gravity = 2.5
#	if GameManager.anti_gravity_pressed():
#		gravity = 0
#	else:
#		gravity = 2.5
#	return gravity
	for limb in limbs:
		limb.gravity_scale = gravity
		
func _physics_process(delta):	
	for limb in limbs:
		if limb.enabled == true:

			if controllable:
				control_ragdoll(limb)	
				
#			if limb.name == "Torso":
#				update_shadow(limb)
##				self.position = limb.global_position - Vector2(0, 60)
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

#func get_true_position() -> Array:
#	var limb_positions = []
#	for limb in limbs:
#		limb_positions.append(limb.position)
#
#	return limb_positions

func freeze() -> void:
	for limb in limbs:
		limb.freeze = true

func get_on_bus():
	self.freeze()
##	anim.play("Absorb")
##	if not anim.is_playing(): queue_free()
#	var tween_body = create_tween().set_parallel(true)
##	tween_body.tween_property(self, "position", Vector2(1040, 448), 0.5)
	for limb in limbs:
		var tween = create_tween().set_parallel(true)
		for child in limb.get_children():
			tween.tween_property(child, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
			tween.tween_property(child, "global_position", Vector2(1040, 448), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	
	self.shadow.queue_free()
	self.is_on_bus = true
	self.absorb.play()
	GameManager.remove_passenger(self)
	
#	if GameManager.active_blob:
#		GameManager.active_blob.grow(self.size)
#		GameManager.active_blob.first_grow = false
	
#func is_hit() ->  bool:
#	if GameManager.kick.raycast.is_colliding():
#		return GameManager.kick.raycast.get_collider() is Limb
#	return false
