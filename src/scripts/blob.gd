extends StaticBody2D
class_name Blob

@onready var anim = $BlobPlayer
@onready var sound = $BlobFX
@onready var first_grow = true
@onready var size = 10
@onready var active = true

@export var impact_multiplier := 3.33
@export var squish_sound : AudioStream
@export var absorb_sound : AudioStream

var grow_amount : Vector2

func _ready():
	pass
#	blob.connect("body_entered", _on_kick_hit)
#	blob.connect("body_exited", _on_kick_exit)

func _process(delta):	
	size = max(0, size)
#	print_debug(first_grow)
#	print(GameManager.active_blob)
	if GameManager.kick.success_hit():
		if GameManager.kick.success_hit() is Blob:
			sound.stream = squish_sound
			sound.pitch_scale = randf_range(0.6, 1.5)
			sound.volume_db = randf_range(-2, 2)
			sound.play()
			if size < 1 and GameManager.all_passengers.size() == 0:
				active = false
				push_to_bus()
				await get_tree().create_timer(1.4).timeout
				GameManager.round_complete()
				GameManager.active_bus.bus_go()
		
func _physics_process(delta):
	pass

func push_to_bus():
	var pushed = false
	if not pushed:
		pushed = true
		sound.stream = squish_sound
		sound.play()
		await get_tree().create_timer(0.1).timeout
		sound.stream = absorb_sound
		sound.play()
		anim.play_backwards("Appear")

func grow(amount):
	if not active:
		return
		
	size += amount
	size = min(size, 180)
	
	if not first_grow:
		var tween = create_tween().set_parallel(true)
		var grow_amount = Vector2(amount * 0.01, amount * 0.01)
		
		print_debug(grow_amount)
		tween.tween_property(self, "position", Vector2(1068, 449), 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "scale", scale + grow_amount, 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)

func shrink(amount):
	if not active:
		return
		
	size -= amount * impact_multiplier
#	
	var tween = create_tween().set_parallel(true)
	var shrink_amount = Vector2(amount * 0.058, amount * 0.058)
#	var max_scale = 1 + 0.01 * size / amount * impact_multiplier
#	shrink_amount.x = clamp(shrink_amount.x, 0.15, max_scale)
#	shrink_amount.y = clamp(shrink_amount.y, 0.25, max_scale)
	
	tween.tween_property(self, "position", Vector2(1068, 449), 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	if scale > Vector2(0.90, 0.95):
		tween.tween_property(self, "scale", scale - shrink_amount, 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	
#func _on_kick_hit(body : Kick):
#	kick = body
#
#func _on_kick_exit(body : Kick):
#	kick = null
#func is_hit() ->  bool:
#	if GameManager.kick.raycast.is_colliding():
#		return GameManager.kick.raycast.get_collider().get_parent() is Blob
#
#	return false
#	if not kick_hit_box.disabled:
#
##		print_debug(abs(kick_hit_box.global_transform.x.dot(area.global_position)))
##		var distance = kick_hit_box.global_position.distance_to(area.global_position)
#		var distance = get_distance(Vector2(328, 1064), Vector2(560, 1064), kick_hit_box.global_position)
#		print_debug(distance)
#
#		if distance < hit_distance:
#			return true
			
#func get_distance(start, end, point):
#	var line = end - start
#	var len = line.length()
#	line.normalized()
#
#	var v = point - start
#	var d = Vector2.ONE.dot(Vector2(v.length(), len))
#	d = clampf(d, 0.0, len)
#	return start + line * d
	
		

