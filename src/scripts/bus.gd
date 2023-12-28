extends StaticBody2D
class_name Bus

@onready var anim = $BusPlayer
@onready var bus_sprite = $Bus
@onready var area = $Area2D/CollisionShape2D

@export var absorb_distance = 75

func _physics_process(delta):
	# Absorb passengers after arriving
	if not anim.is_playing():
		for passenger in GameManager.all_passengers:
#			if passenger.is_on_bus == false:
			absorb_passenger(passenger)

func absorb_passenger(passenger):
	# Check if passenger is within range to absorb
	var distance = passenger.area.global_position.distance_to(area.global_position)

	if distance < absorb_distance:
		passenger.get_on_bus()
		
		# Pass on passenger size to blob if absorbed
		if GameManager.active_blob:
			GameManager.active_blob.first_grow = false
			GameManager.active_blob.grow(passenger.size)

func bus_go():
	anim.play("BusGo")
	await get_tree().create_timer(2).timeout
	GameManager.delete_bus(self)
