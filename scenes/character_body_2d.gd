extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var jump_speed = -300
@export var max_movement = 2
var jump_count = 0
var dash_count = 0

var walk_texture = preload("res://assets/kenney_platformercharacters/PNG/Female/Poses/female_walk1.png")
var jump_texture = preload("res://assets/kenney_platformercharacters/PNG/Female/Poses/female_jump.png")
var duck_texture = preload("res://assets/kenney_platformercharacters/PNG/Female/Poses/female_duck.png")
var idle_texture = preload("res://assets/kenney_platformercharacters/PNG/Female/Poses/female_idle.png")

func _physics_process(delta):
	velocity.y += delta * gravity

	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed('ui_up') and jump_count < max_movement:
		jump_count += 1
		velocity.y = jump_speed
		$Sprite2D.texture = jump_texture
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		if Input.is_action_pressed("ui_down"):
			velocity.x = direction * (0.5 * walk_speed)
			$Sprite2D.flip_h = direction < 0
			$Sprite2D.texture = duck_texture
		else:
			velocity.x = direction * (1 * walk_speed)
			$Sprite2D.flip_h = direction < 0
			$Sprite2D.texture = walk_texture
	else:
		velocity.x = 0
		if is_on_floor():
			$Sprite2D.texture = idle_texture

	# "move_and_slide" already takes delta time into account.
	move_and_slide()
