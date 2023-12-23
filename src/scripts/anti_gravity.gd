extends Area2D

@onready var ag_skill = $"CollisionShape2D/Anti-Gravity-Skill"
@onready var skill_animation = $SkillAnimation
@onready var cooldown = $Cooldown
@onready var activated = $Activated

var anti_gravity_activate = false
var mouse_in_skill = false
var anti_gravity_active = false

func _ready():
	cooldown.start()
	
func _on_cooldown_timeout():
	anti_gravity_activate = true

func anti_gravity():
	var anti_gravity = 2.5
	if anti_gravity_active == true:
		anti_gravity = 0
	else:
		anti_gravity = 2.5
	return anti_gravity

func _on_mouse_entered():
	mouse_in_skill = true

func _on_mouse_exited():
	mouse_in_skill = false

func _process(delta):
	if mouse_in_skill == true:
		if anti_gravity_activate == true:
			if Input.is_action_pressed("Click"):
				anti_gravity_active = true
				skill_animation.play("activated")
				activated.start()

func _on_activated_timeout():
	anti_gravity_active = false
	skill_animation.play("Cooldown")
	cooldown.start()
