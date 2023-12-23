extends Area2D
class_name HurtBox

var kick : Kick

func _ready():
	self.connect("body_entered", _on_kick_hit)
	self.connect("body_exited", _on_kick_exit)

func _on_kick_hit(body: Kick):
	kick = body

func _on_kick_exit(body: Kick):
	kick = null

func is_hit() -> bool:
	return GameManager.kick == kick
