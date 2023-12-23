extends StaticBody2D
class_name Bus

#@onready var area = $Area2D
@onready var anim = $BusPlayer
@onready var bus_sprite = $Bus
@onready var area = $Area2D/CollisionShape2D

@export var absorb_distance = 75

var is_open : bool
var prev_body = null

func _ready():
#	area.connect("body_entered", _on_area_2d_body_entered)
	pass

func _process(delta):
	pass
	
func _physics_process(delta):
	if not anim.is_playing():
		for passenger in GameManager.all_passengers:
			if passenger.is_on_bus == false:
				absorb_passenger(passenger)

#func spawn_bus():
#	anim.play("BusCome")

#func _on_area_2d_body_entered(body):
#	if body is Limb:
#		body = body.get_parent()
#
#		if body != prev_body:
#			Messenger.on_bus.emit(body)
#
#	prev_body = body
		
func absorb_passenger(passenger):
	var distance = passenger.area.global_position.distance_to(area.global_position)

	if distance < absorb_distance:
		passenger.get_on_bus()
		
		if GameManager.active_blob:
			GameManager.active_blob.first_grow = false
			GameManager.active_blob.grow(passenger.current_size)
			
#	var limbs_distance = []
##
#	for limb_position in passenger.get_true_position():
##		var true_passenger_position = passenger.get_true_position(limb.name) 
#		limbs_distance.append(position.distance_to(area.global_position))
#
#	for distance in limbs_distance:	
#		if distance < absorb_distance:
#			passenger.get_on_bus()
	
