extends CharacterBody2D

@export var SPEED := 200
@export var JUMP_SPEED := -400
@export var GRAVITY := 1200
@export var max_movement = 2
@export var walk_sfx_interval := 0.35
var jump_count = 0
var walk_sfx_cooldown := 0.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_sfx: AudioStreamPlayer2D = $WalkSFX
@onready var punch_sfx: AudioStreamPlayer2D = $PunchSFX

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	var is_walking := false

	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed('ui_up') and jump_count < max_movement:
		jump_count += 1
		velocity.y = JUMP_SPEED
		animated_sprite.play("jump")
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		if Input.is_action_pressed("ui_down"):
			velocity.x = direction * (0.5 * SPEED)
			animated_sprite.flip_h = direction < 0
			animated_sprite.play("crouch")
		else:
			velocity.x = direction * (1 * SPEED)
			animated_sprite.flip_h = direction < 0
			animated_sprite.play("walk")
			is_walking = is_on_floor()
	else:
		velocity.x = 0
		if is_on_floor():
			animated_sprite.play("stand")

	if is_walking and !punch_sfx.playing:
		walk_sfx.play()
	else:
		walk_sfx.stop()
			
	if Input.is_action_pressed("ui_select"):
		animated_sprite.play("punch")
		if punch_sfx.playing:
			punch_sfx.stop()
		punch_sfx.play()

	# "move_and_slide" already takes delta time into account.
	move_and_slide()
