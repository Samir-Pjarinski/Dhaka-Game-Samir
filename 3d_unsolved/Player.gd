extends KinematicBody

## Todo-
## Add player projectiles - no gun

onready var animations = $character/AnimationTree.get("parameters/playback")
onready var progress_bar = $ProgressBar
onready var mesh = $character

var direction = Vector3.FORWARD
var velocity = Vector3.ZERO
var y_velocity = 0
var gravity = 20
var mouse = 0.09
var current_cam
var angular_acceleration = 7
var acceleration = 10

export var health = 20
export var max_health = 20
export var speed = 3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if Input.is_action_pressed("forwards") or Input.is_action_pressed("backwards") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		var camera_rotation = $camera_root/camera_h.global_transform.basis.get_euler().y
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"),
					0,
					Input.get_action_strength("forwards") - Input.get_action_strength("backwards")).rotated(Vector3.UP,camera_rotation)
		direction = direction.normalized()
		animations.travel("Walk")
		speed = 3
	else:
		speed = 0
		animations.travel("Idle")

	if !is_on_floor():
		y_velocity += gravity * delta
	else:
		y_velocity = 0
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
	
	velocity = lerp(velocity, speed * direction, delta * acceleration)
	move_and_slide(velocity + Vector3.DOWN * y_velocity, Vector3.UP)

	if health == 0:
		print("dead")

	progress_bar.max_value = max_health
	progress_bar.value = health

func _input(event):
	if event is InputEventMouseMotion:
		$'.'.rotation_degrees.y += (event.relative.x * mouse)

func minus_health(damage):
	health = health - damage
	print(health)
