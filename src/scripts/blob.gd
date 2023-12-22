extends Node2D
class_name Blob

@onready var hurt_box = $HurtBoxComponent
@onready var blob_anim = $BlobPlayer

func _ready():
	pass

func _process(delta):
	print(hurt_box.is_hit())
	
	if hurt_box.is_hit():
		blob_anim.play("Hurt")
		
func grow():
	var tween = create_tween()
	
func shrink():
	pass
