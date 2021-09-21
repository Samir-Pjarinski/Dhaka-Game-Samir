extends KinematicBody
#samir

onready var blast_radius = $BlastRaduis

var direction = Vector3.FORWARD
var velocity = Vector3.ZERO
var y_velocity = 0
var gravity = 20
var angular_acceleration = 7
var acceleration = 10
var speed = 3
var damage = 10
var triggered = false
var pickup = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	y_velocity += gravity * delta
#	velocity = lerp(velocity, speed * direction, delta * acceleration)
	move_and_slide(velocity + Vector3.DOWN * y_velocity, Vector3.UP)

	if triggered == true:
		var bodies = blast_radius.get_overlapping_bodies()
		for b in bodies:
			if b.is_in_group("Damageable"):
				var space = get_world().direct_space_state
				var collision = space.intersect_ray(global_transform.origin, b.global_transform.origin)
				if collision.collider.is_in_group("Damageable"):
					b.health -= damage
		queue_free()
		print("explode")

	if pickup == true:
		queue_free()

#	print(triggered)

func triggered():
	 triggered = true
	 print("call")

func deleted():
	pickup = true
