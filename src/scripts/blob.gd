extends Node2D
class_name Blob

@onready var blob_anim = $Blob/BlobPlayer
#var hit_distance = 100
#var kick_hit_box = GameManager.kick.hit_box
var first_grow = true
var size = 10
var grow_amount : Vector2

func _ready():
	pass
#	blob.connect("body_entered", _on_kick_hit)
#	blob.connect("body_exited", _on_kick_exit)

func _process(delta):	
#	print_debug(first_grow)
#	print(GameManager.active_blob)
	if GameManager.kick.success_hit():
		if GameManager.kick.success_hit().name == "Blob":
			blob_anim.play("Hurt")
			shrink(GameManager.kick.impact * 2)
		
func _physics_process(delta):
	pass
	
func grow(amount):
	size += amount
	
	if not first_grow:
		var tween = create_tween().set_parallel(true)
		var grow_amount = Vector2(amount * 0.01, amount * 0.01)
		
		print_debug(grow_amount)
		tween.tween_property(self, "position", position - Vector2(3, 0), 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "scale", scale + grow_amount, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	
func shrink(amount):
	
	size -= amount
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(3, 0), 0.5).from_current().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", scale - Vector2(amount * 0.01, amount * 0.01), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
	
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
	
		

