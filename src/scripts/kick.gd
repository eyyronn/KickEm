extends StaticBody2D
class_name Kick

@onready var animation = $AnimationPlayer
@onready var charge_audio = $KickCharge
@onready var release_audio = $KickRelease
@onready var hit_box = $HitBox
@onready var raycast = $RayCast
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
	
	if GameManager.is_player_lost:
		return

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
		
	if success_hit():
		if success_hit() is Blob:
			kick_blob()
#	print_debug(force, constant_linear_velocity
	
func _physics_process(delta):
	
	if GameManager.is_player_lost:
		return
	
	if Input.is_action_just_pressed("Click"):
		charge_kick(delta)
		
	if Input.is_action_just_released("Click"):
		release_kick()

func _integrate_forces(state):
	pass
		
func charge_kick(delta):
	raycast.set_collision_mask_value(6, true)
	raycast.enabled = false
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
	
func success_hit() -> Object:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		return collider
	
	return null
	
func kick_blob():
	raycast.set_collision_mask_value(6, false)
	GameManager.active_blob.anim.play("Hurt")
#	print_debug(GameManager.active_blob.size, impact * 3.33)
	GameManager.active_blob.shrink(impact)
#	print_debug("Hit", GameManager.active_blob.size, impact)

	
