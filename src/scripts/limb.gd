extends RigidBody2D
class_name Limb

@onready var back_upper = $BUpperarm
@onready var back_fore = $BForearm
@onready var back_hand = $BHand
@onready var back_foot = $BFoot
@onready var back_leg = $BLeg
@onready var foot = $Foot
@onready var leg = $Leg
@onready var torso = $Torso
@onready var upper = $Upperarm
@onready var fore = $Forearm
@onready var hand = $Hand
@onready var head = $Head

@export var desired_angle : float = 0.0;
@export var enabled : bool = true;
@export var force : float = 3000.0;
