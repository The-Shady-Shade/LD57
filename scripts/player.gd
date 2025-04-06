extends CharacterBody2D

@export var collision_shape: CollisionShape2D
@export var animation: AnimatedSprite2D
@export var dead_particles: GPUParticles2D
@export var boost_sfx: AudioStreamPlayer
@export var dead_sfx: AudioStreamPlayer
@onready var initial_position: Vector2 = global_position

#region Movement Variables
@export_category("Movement Stats")
@export var spd = 100.0
@export var acc: float = 0.1
@export var dec: float = 10
@export var jump_power = -300.0
var can_move: bool = true
#endregion

#region Ability Variables
@export_category("Dash Stats")
var can_dash: bool = false
var dash_count: int = 0
@export var dash_spd: float = 300.0
@export var dash_time_max: float = 0.25
var dash_time: float = 0.0
@export var dash_cd_max: float = 0.5
var dash_cd: float = 0.0

@export_category("Glide Stats")
var can_glide: bool = false
@export var glide_force_max: float = 0.1
var glide_force: float = 1.0
#endregion

#region Basic Processes
func _ready() -> void:
	global.player = self

func _process(delta: float) -> void:
	dash_time = max(0.0, dash_time - delta)
	dash_cd = max(0.0, dash_cd - delta)
	if Input.is_action_just_pressed("dash") && can_dash && dash_time <= 0.0 && dash_cd <= 0.0 && dash_count <= 0:
		dash_count += 1
		dash_time = dash_time_max
		dash_cd = dash_cd_max
		boost_sfx.play()

func _physics_process(delta: float) -> void:
	if !can_move:
		return
	var dir: float = Input.get_axis("left", "right")
	if dash_time > 0.0:
		velocity.x = animation.scale.x * dash_spd
	elif dir:
		if dir > 0.0:
			animation.scale.x = 1
		else:
			animation.scale.x = -1
		velocity.x = lerp(velocity.x, dir * spd, acc)
	else:
		velocity.x = move_toward(velocity.x, 0, dec)
	
	if is_on_floor():
		dash_count = 0
		if Input.is_action_just_pressed("jump"):
			glide_force = 1.0
			velocity.y = jump_power
			boost_sfx.play()
		
		if dir:
			animation.play("walk")
		else:
			animation.play("idle")
	else:
		velocity += get_gravity() * glide_force * delta
		if velocity.y > 0.0:
			if Input.is_action_just_pressed("jump") && can_glide:
				boost_sfx.play()
			
			if Input.is_action_pressed("jump") && can_glide:
				animation.play("glide")
				glide_force = glide_force_max
			else:
				animation.play("fall")
				glide_force = 1.0
		else:
			animation.play("jump")
	if dash_time > 0.0:
		velocity.y = 0.0
		animation.play("dash")
	
	move_and_slide()
#endregion

func get_damage() -> void:
	global.computers_fixed = 0
	dead_particles.emitting = true
	dead_sfx.play()
	animation.visible = false
	can_move = false
	await get_tree().create_timer(1).timeout
	global_position = initial_position
	animation.visible = true
	can_move = true
	get_tree().reload_current_scene()
