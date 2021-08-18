extends KinematicBody
#Samir

onready var animations = $character/AnimationTree.get("parameters/playback")
onready var progress_bar = $ProgressBar
onready var fireball_reload = $ProgressBar2
onready var mesh = $character
onready var rof_timer = $Timer
onready var muzzle = $character/character/Muzzle
onready var C4_place = $character/character/C4
onready var label = $Label
onready var raycast = $camera_root/camera_h/camera_v/RayCast
onready var PickupRadius = $PickupRadius
onready var fireball_label = $Label2

var direction = Vector3.FORWARD
var velocity = Vector3.ZERO
var y_velocity = 0
var gravity = 20
var mouse = 0.09
var angular_acceleration = 7
var acceleration = 10
var can_shoot = true
var selected = "empty"

export(PackedScene) var Bullet
export(PackedScene) var C_4
export var muzzle_speed = 10
export var seconds_between_shots = 10
export var total_C4 = 10
export var health = 20
export var max_health = 20
export var speed = 3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	rof_timer.wait_time = seconds_between_shots 

#Rashad
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
	
	if is_on_floor() and Input.is_action_pressed("jump"):
				y_velocity = -8
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
	
	velocity = lerp(velocity, speed * direction, delta * acceleration)
	move_and_slide(velocity + Vector3.DOWN * y_velocity, Vector3.UP)

#Samir
	PickupRadius.rotation_degrees.y = mesh.rotation_degrees.y

	if Input.is_action_pressed("fireball_shoot"):
		if selected == "fireball":
			shoot(muzzle)
		elif selected == "trigger":
			get_tree().call_group("bomb", "triggered")
	if Input.is_action_just_pressed("shoot"):
		if selected == "C4":
			throw_C4(C4_place)

	if health == 0:
		pass

	progress_bar.max_value = max_health
	progress_bar.value = health

	if selected == "fireball":
		fireball_reload.show()
	else:
		fireball_reload.hide()

	fireball_reload.max_value = seconds_between_shots
	fireball_reload.value = 10 - rof_timer.time_left

	print(10 - rof_timer.time_left, seconds_between_shots)

	if rof_timer.time_left == 0 and selected == "fireball":
		fireball_label.show()
	else:
		fireball_label.hide()

	if Input.is_key_pressed(KEY_1):
		selected = "empty"
	elif Input.is_key_pressed(KEY_2):
		selected = "fireball"
	elif Input.is_key_pressed(KEY_3):
		selected = "C4"
	elif Input.is_key_pressed(KEY_4):
		selected = "trigger"

	if selected == "C4":
		label.set_text(selected + ',' + str(total_C4))
	else:
		label.set_text(selected)

	if Input.is_action_just_pressed("ui_use"):
		if selected == "C4":
			var bodies = PickupRadius.get_overlapping_bodies()
			for b in bodies:
				if b.is_in_group("bomb"):
						b.queue_free()
						total_C4 += 1

	print(health)

func _input(event):
	if event is InputEventMouseMotion:
		$'.'.rotation_degrees.y += (event.relative.x * mouse)

func minus_health(damage):
	health = health - damage
#	print(health)

func shoot(loc):
	if can_shoot:
		var bullet = Bullet.instance()
		bullet.global_transform = loc.global_transform
#		bullet.bullet_speed = muzzle_speed
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(bullet)
#		print("pew")
		can_shoot = false
		rof_timer.start()

func throw_C4(loc):
	if total_C4 > 0:
		var C4 = C_4.instance()
		C4.global_transform = loc.global_transform
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(C4)
		total_C4 -= 1

func _on_Timer_timeout():
	can_shoot = true
