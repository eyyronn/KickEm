extends Node2D
class_name Passenger

@onready var shadow = $Shadow
@onready var torso = $Torso
@onready var anim = $PassengerPlayer
@onready var area = $Torso/Area2D
@onready var absorb = $AbsorbSound

@export var skins : Array[Array]
@export var center_of_mass := Vector2(0.0, 40.0)
@export var controllable := false
@export var movement_power := 500.0

var limbs = []
var size = 10
var is_on_bus = false
var type : int
var gravity_scale = 2.5
var available_types = [0]

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
	set_skin(type)
	
func get_available_types():
	match GameManager.score:
		1:	
			available_types.append(1)
		2:	
			available_types.append(1)
			available_types.append(2)
		3:	
			available_types.append(1)
			available_types.append(2)
			available_types.append(3)
		4:	
			available_types.append(1)
			available_types.append(2)
			available_types.append(3)
			available_types.append(4)
		
	if GameManager.score > 4:
		available_types.append(1)
		available_types.append(2)
		available_types.append(3)
		available_types.append(4)
	
	print_debug(available_types)
	return available_types

func set_skin(type):
	for limb in limbs:
		match limb.name:
#		
			"BUpperarm":	
					limb.back_upper.texture = skins[type][0]
			"BForearm":
					limb.back_fore.texture = skins[type][1]
			"BHand":
					limb.back_hand.texture = skins[type][2]
			"BFoot":
					limb.back_foot.texture = skins[type][3]
			"BLeg":
					limb.back_leg.texture = skins[type][4]
			"Foot":
					limb.foot.texture = skins[type][5]
			"Leg":
					limb.leg.texture = skins[type][6]
			"Torso":
					limb.torso.texture = skins[type][7]
			"Upperarm":
					limb.upper.texture = skins[type][8]
			"Forearm":
					limb.fore.texture = skins[type][9]
			"Hand":
					limb.hand.texture = skins[type][10]
			"Head":
					limb.head.texture = skins[type][11]

func set_weight(weight):
	for limb in limbs:
		limb.center_of_mass = Vector2(0.0, weight)
		
func _process(delta):	
	set_gravity()
	for limb in limbs:
		if limb.name == "Torso" and not is_on_bus:
			update_shadow(limb)

func set_gravity():
	for limb in limbs:
		limb.gravity_scale = gravity_scale
		
func _physics_process(delta):	
	for limb in limbs:
		if limb.enabled == true:

			if controllable:
				control_ragdoll(limb)	
			correct_rotation(limb, delta)	
		
func correct_rotation(limb, delta):
	var current_angle = limb.rotation;
	limb.angular_velocity = lerp_angle(current_angle, limb.desired_angle, (limb.force) * delta);

func control_ragdoll(limb):
	if Input.is_action_just_pressed("Click"):
		var velocity_vector = get_global_mouse_position() - limb.global_position     
		velocity_vector = velocity_vector.normalized()
		limb.apply_impulse(velocity_vector * movement_power)
	
func update_shadow(target):
	shadow.position = Vector2(target.position.x - 40, target.position.y)
	shadow.position.y = clamp(shadow.position.y, 80, 80)
	shadow.scale.x = 1.25 + target.position.y * 0.00375
	shadow.scale.x = clamp(shadow.scale.x, 0, 100)

func freeze() -> void:
	for limb in limbs:
		limb.freeze = true

func get_on_bus():
	self.freeze()
	for limb in limbs:
		var tween = create_tween().set_parallel(true)
		for child in limb.get_children():
			tween.tween_property(child, "scale", Vector2.ZERO, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
			tween.tween_property(child, "global_position", Vector2(1040, 448), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	
	self.shadow.queue_free()
	self.is_on_bus = true
	self.absorb.play()
	GameManager.remove_passenger(self)
