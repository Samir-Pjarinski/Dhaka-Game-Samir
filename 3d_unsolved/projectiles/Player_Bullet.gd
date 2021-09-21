extends Spatial
#samir

var timer = 0 

export var bullet_speed = 3

const Kill_Time = 10

func _ready():
	$AnimationPlayer.play("grow")

func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * bullet_speed * delta)
	
	timer += delta
	
	if timer > Kill_Time:
		queue_free()

#rashad + samir
func _on_Area_body_entered(body):
	if body is KinematicBody:
		if body.is_in_group("Enemy"):
			queue_free()

#samir
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "grow":
		bullet_speed = 15
