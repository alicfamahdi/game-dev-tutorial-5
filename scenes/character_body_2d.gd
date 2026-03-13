extends CharacterBody2D

@export var SPEED := 200
@export var JUMP_SPEED := -400
@export var GRAVITY := 1200
@export var max_movement = 2
var jump_count = 0

func _physics_process(delta):
	velocity.y += delta * GRAVITY

	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed('ui_up') and jump_count < max_movement:
		jump_count += 1
		velocity.y = JUMP_SPEED
		$AnimatedSprite2D.play("jump")
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		if Input.is_action_pressed("ui_down"):
			velocity.x = direction * (0.5 * SPEED)
			$AnimatedSprite2D.flip_h = direction < 0
			$AnimatedSprite2D.play("crouch")
		else:
			velocity.x = direction * (1 * SPEED)
			$AnimatedSprite2D.flip_h = direction < 0
			$AnimatedSprite2D.play("walk")
	else:
		velocity.x = 0
		if is_on_floor():
			$AnimatedSprite2D.play("stand")
			
	if Input.is_action_pressed("ui_select"):
		$AnimatedSprite2D.play("punch")

	# "move_and_slide" already takes delta time into account.
	move_and_slide()
