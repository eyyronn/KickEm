extends StaticBody2D
class_name Kick

@onready var animation = $AnimationPlayer
@onready var charge_sound = $KickCharge
@onready var release_sound = $KickRelease
@onready var impact_sound = $KickImpact
@onready var hit_box = $HitBox
@onready var raycast = $RayCast

@export var force_multiplier := Vector2(500, 500)

var is_charging : bool
var released : bool
var force : float = 0
var impact : int

func _ready():
	pass
	
func _process(delta):
	
	if GameManager.game_is_paused:
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
		if success_hit() is Limb:
			kick_limb()
			
#	print_debug(force, constant_linear_velocity
	
func _physics_process(delta):
	
	if GameManager.game_is_paused:
		return
	
	if Input.is_action_just_pressed("Click"):
		charge_kick(delta)
		
	if Input.is_action_just_released("Click"):
		release_kick()

func _integrate_forces(state):
	pass
		
func charge_kick(delta):
	raycast.set_collision_mask_value(6, true)
	raycast.set_collision_mask_value(2, true)
	raycast.set_collision_mask_value(3, true)
	raycast.enabled = false
	is_charging = true
	force += 1
	charge_sound.pitch_scale = randf_range(1, 1.2)
	charge_sound.play()
	animation.play("kick_ready")
	animation.queue("kick_charge")

func release_kick():
	is_charging = false
	charge_sound.stop()
	release_sound.pitch_scale = randf_range(0.8, 1)
	release_sound.volume_db = randf_range(-4, -2)
	release_sound.play()
	animation.play("kick_release")
	
func success_hit() -> Object:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		return collider
	
	return null
	
func kick_blob():
	raycast.set_collision_mask_value(6, false)
	GameManager.active_blob.anim.play("Hurt")
	impact_sound.volume_db = randf_range(-5, -3)
	impact_sound.pitch_scale = randf_range(0.8, 1.3)
	impact_sound.play()
#	print_debug(GameManager.active_blob.size, impact * 3.33)
	GameManager.active_blob.shrink(impact)
#	print_debug("Hit", GameManager.active_blob.size, impact)

func kick_limb():
	raycast.set_collision_mask_value(2, false)
	raycast.set_collision_mask_value(3, false)
	impact_sound.volume_db = randf_range(0, 1)
	impact_sound.pitch_scale = randf_range(0.8, 1.6)
	impact_sound.play()
	
