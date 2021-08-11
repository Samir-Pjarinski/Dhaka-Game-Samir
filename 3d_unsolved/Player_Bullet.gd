extends Spatial

var timer = 0 

export var bullet_speed = 10
export var bullet_damage = 1

const Kill_Time = 10

func _ready():
	global_scale(Vector3(0.25,0.25,0.25))

func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(forward_direction * bullet_speed * delta)
	
	timer += delta
	
	if timer > Kill_Time:
		queue_free()


func _on_Area_body_entered(body):
	if body is KinematicBody:
		if body.is_in_group("Enemy"):
			get_tree().call_group("Enemy","minus_health", bullet_damage)
			queue_free()
			print("die")

