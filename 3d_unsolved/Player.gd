extends KinematicBody

onready var animations = $character/AnimationTree.get("parameters/playback")
onready var T_P = $T_P
onready var F_P = $F_P
onready var F_T_P = $F_T_P
onready var progress_bar = $ProgressBar

var direction=Vector3()
var velocity = Vector3()
var gravity = 9.8
var mouse = 0.09
var current_cam

export var health = 20
export var max_health = 20
export var speed = 250

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	direction=Vector3(0,0,0)
	
	if Input.is_key_pressed(KEY_A):
		direction.x+=1
		animations.travel("Walk")
	elif Input.is_key_pressed(KEY_D):
		direction.x-=1
		animations.travel("Walk")
	elif Input.is_key_pressed(KEY_S):
		direction.z-=1
		animations.travel("Walk")
	elif Input.is_key_pressed(KEY_W):
		direction.z+=1
		animations.travel("Walk")
	else: 
		animations.travel("Idle")

	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	direction=direction.normalized()
	direction=direction*speed*delta
	
	direction=direction.normalized()
	direction=direction*speed*delta
	direction = direction.rotated(Vector3(0,1,0), rotation.y)

	velocity.y+=gravity*delta
	velocity.x=direction.x
	velocity.z=direction.z

	if velocity.y>0:
		gravity=-20
	else:
		gravity=-30

	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = 7
	velocity = move_and_slide(velocity,Vector3(0,1,0))

	if health == 0:
		print("dead")

	progress_bar.max_value = max_health
	progress_bar.value = health

	if Input.is_action_just_pressed("ui_switch"):
		if T_P.current == true:
			current_cam = F_P

		elif F_P.current == true:
			current_cam = F_T_P

		elif F_T_P.current == true:
			current_cam = T_P

	if current_cam == F_P:
		F_P.current = true
		T_P.current = false
		F_T_P.current = false

	elif current_cam == T_P:
		T_P.current = true
		F_P.current = false
		F_T_P.current = false

	elif current_cam == F_T_P:
		F_T_P.current = true
		T_P.current = false
		F_P.current = false

func _input(event):
	if event is InputEventMouseMotion:
		$'.'.rotation_degrees.y += (event.relative.x * mouse)

func minus_health(damage):
	health = health - damage
	print(health)
