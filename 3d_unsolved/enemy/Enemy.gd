extends KinematicBody
#samir + rashad + meeyad

enum{
	IDLE
	ACTIVE
}

onready var nav = $"../Navigation" as Navigation
onready var player = $"../Player"
onready var raycast = $RayCast
onready var rof_timer = $Timer2
onready var eyes = $Eyes
onready var gun = $Gun
onready var colour = $MeshInstance.get_surface_material(0)
onready var goggles = $Goggles.get_surface_material(0)

var path = []
var current_node = 0
var speed = 1
var can_shoot = true
var state = IDLE
var direction = Vector3.ZERO
var velocity = Vector3.ZERO
var y_velocity = 0
var gravity = 20
var acceleration = 10
var dying = false
var damage = 1

export(PackedScene) var Bullet
export var muzzle_speed = 10
export var seconds_between_shots = 10
export var health = 2
export var max_health = 2
export var TURN_SPEED = 2 

#samir
func _ready():
	rof_timer.wait_time = seconds_between_shots 

func _process(delta):

	match state:
		ACTIVE:
			if path.size() >= 2:
				if current_node < path.size() and dying == false:
					direction = path[current_node] - global_transform.origin
					if direction.length() < 1:
						current_node += 1
					else:
						move_and_slide(direction.normalized() * speed)

			if raycast.is_colliding() and dying == false:
				var aim_at = raycast.get_collider()
				if aim_at.is_in_group("Player"):
					shoot($Muzzle)

			eyes.look_at(player.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * TURN_SPEED))

			if health <= 0:
				dying = true
				$AnimationPlayer.play("Die")

			if !is_on_floor():
				y_velocity += gravity * delta
			else:
				y_velocity = 0

			velocity = lerp(velocity, speed * direction, delta * acceleration)
			move_and_slide(velocity + Vector3.DOWN * y_velocity, Vector3.UP)

func update_path(target_point):
	path = nav.get_simple_path(global_transform.origin, target_point)

func _on_Timer_timeout():
	update_path(player.global_transform.origin)
	current_node = 0

func shoot(loc):
	if can_shoot:
		var bullet = Bullet.instance()
		bullet.global_transform = loc.global_transform
		var scene_root = get_parent().get_parent()
		scene_root.add_child(bullet)
		can_shoot = false
		rof_timer.start()

func _on_Timer2_timeout():
	can_shoot = true

func _on_Sight_Range_body_entered(body):
	if body.is_in_group("Player"):
		state = ACTIVE
		print("entered")

func _on_Sight_Range_body_exited(body):
	if body.is_in_group("Player"):
		state = IDLE
		print("exited")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Die":
		queue_free()

func moveable():
	speed = 1

func unmoveable():
	speed = 0

#rashad
func _on_hitbox_area_entered(area):
	if area.name == "player_bullet":
		health -= damage
#meeyad
		colour.albedo_color = Color(1,1,1)
		colour.flags_unshaded = true
		goggles.albedo_color = Color(1,1,1)
		goggles.flags_unshaded = true
		$hurt_timer.start()

func _on_hurt_timer_timeout():
	colour.albedo_color = Color(0, 1, 0.203922)
	colour.flags_unshaded = false
	goggles.albedo_color = Color(0,0,0)
	goggles.flags_unshaded = false
