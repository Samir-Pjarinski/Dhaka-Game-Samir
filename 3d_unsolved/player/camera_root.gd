extends Spatial

onready var camera = $camera_h/camera_v/ClippedCamera

var render_distance = 100
var move = 1
var h_rotation = 0
var v_rotation = 0
var vertical_max = 75
var vertical_min = -55
var v_sensitivity = 0.1
var h_sensitivity = 0.1
var v_acceleration = 10
var h_acceleration = 10

func _ready():
#	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$camera_h/camera_v/ClippedCamera.add_exception(get_parent())

func _input(event):
	if event is InputEventMouseMotion:
		h_rotation += -event.relative.x
		v_rotation += event.relative.y

func _physics_process(delta):
	v_rotation = clamp(v_rotation,vertical_min,vertical_max)
	$camera_h.rotation_degrees.y = lerp($camera_h.rotation_degrees.y, h_rotation, delta * h_acceleration)
	$camera_h/camera_v.rotation_degrees.x = lerp($camera_h/camera_v.rotation_degrees.x, v_rotation, delta * v_acceleration)
#	elif render_distance > 20:
#		move = move * -1
	camera.set_zfar(render_distance)
	print(render_distance)
	
	if Input.is_action_just_released("Zoom_Up"):
		if render_distance > 10:
			render_distance -= 1
	if Input.is_action_just_released("Zoom_Down"):
		if render_distance < 100:
			render_distance += 1
