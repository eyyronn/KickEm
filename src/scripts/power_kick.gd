extends Area2D

@onready var ag_skill = $"CollisionShape2D/Anti-Gravity-Skill"
@onready var skill_animation = $SkillAnimation2
@onready var cooldown = $Cooldown
@onready var activated = $Activated

var power_kick_activate = false
var mouse_in_skill = false
var power_kick_active = false


# Called when the node enters the scene tree for the first time.
func _ready():
	cooldown.start()

func _on_cooldown_timeout():
	power_kick_activate = true

func power_kick():
	var power_kick = 0
	if power_kick_active == true:
		power_kick = 5
	else:
		power_kick = 0
	return power_kick
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_in_skill == true:
		if power_kick_activate == true:
			if Input.is_action_pressed("Click"):
				power_kick_active = true
				skill_animation.play("activated")
				activated.start()

func _on_mouse_entered():
	mouse_in_skill = true

func _on_mouse_exited():
	mouse_in_skill = false

func _on_activated_timeout():
	power_kick_active = false
	skill_animation.play("Cooldown")
	cooldown.start()
