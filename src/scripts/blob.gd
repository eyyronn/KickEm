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

func _process(delta):	
	
	# Check if player kicked blob
	if GameManager.kick.success_hit():
		if GameManager.kick.success_hit() is Blob:
			sound.stream = squish_sound
			sound.pitch_scale = randf_range(0.6, 1.5)
			sound.volume_db = randf_range(-2, 2)
			sound.play()
			# if player kicked blob at its smallest size and all the passengers are in the bus, complete round
			if size < 1 and GameManager.all_passengers.size() == 0:
				active = false
				push_to_bus()
				await get_tree().create_timer(1.4).timeout
				GameManager.round_complete()
				GameManager.active_bus.bus_go()
				
# Bus absorbing blob FX
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

# Grow blob relative to passenger size
func grow(amount):
	if not active:
		return
		
	size += amount
	size = min(size, 180) # Limit size to 180
	
	if not first_grow:
		var tween = create_tween().set_parallel(true)
		var grow_amount = Vector2(amount * 0.01, amount * 0.01)
		tween.tween_property(self, "position", Vector2(1068, 449), 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	
		# Limit scale to 1.715 x 1.715
		if scale < Vector2(1.715, 1.715):
			tween.tween_property(self, "scale", scale + grow_amount, 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)

# Shrink blob relative to kick impact
func shrink(amount):
	if not active:
		return
		
	size -= amount * impact_multiplier
	size = max(0, size) # Floor size to 0
#	
	var tween = create_tween().set_parallel(true)
	var shrink_amount = Vector2(amount * 0.058, amount * 0.058)
	tween.tween_property(self, "position", Vector2(1068, 449), 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	
	# Floor scale to 0.90 x 0.95
	if scale > Vector2(0.90, 0.95):
		tween.tween_property(self, "scale", scale - shrink_amount, 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
