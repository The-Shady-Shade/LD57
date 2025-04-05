extends CharacterBody2D

@export var animation: AnimatedSprite2D
@export var computers_label: Label
@export var boost_sfx: AudioStreamPlayer

#region Movement Variables
var spd = 100.0
var acc: float = 0.1
var dec: float = 0.25
var jump_power = -300.0
#endregion

#region Abilities
var can_dash: bool = false
var dash_count: int = 0
var dash_time_max: float = 0.25
var dash_time: float = 0.0
var dash_cd_max: float = 0.25 + dash_time_max
var dash_cd: float = 0.0

var can_ball: bool = false

var can_glide: bool = false
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
	
	if computers_label != null:
		computers_label.text = str(5 - global.computers_fixed) + " computers left"
		if global.computers_fixed >= 5:
			computers_label.queue_free()

func _physics_process(delta: float) -> void:
	var dir: float = Input.get_axis("left", "right")
	if dash_time > 0.0:
		velocity.x = animation.scale.x * spd * 3
	elif dir:
		if dir > 0.0:
			animation.scale.x = 1
		else:
			animation.scale.x = -1
		velocity.x = dir * spd
	else:
		velocity.x = move_toward(velocity.x, 0, spd)
	
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
				glide_force = 0.1
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
	get_tree().reload_current_scene()
