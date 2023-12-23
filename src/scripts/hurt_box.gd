extends Area2D
class_name HurtBox

@onready var shape = $CollisionBody2D

var colliding_bodies = []

func _ready():
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	self.colliding_bodies.append(body)

func _on_body_exited(body):
	self.colliding_bodies.erase(body)

func is_hit() -> bool:
	print(colliding_bodies, self.colliding_bodies, self.get_parent())
#	print(self.get_parent())
#	print(colliding_bodies)
#	print(GameManager.kick in colliding_bodies)
	return GameManager.kick in colliding_bodies
