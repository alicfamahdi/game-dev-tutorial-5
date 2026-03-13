extends Area2D

@export var hit_duration := 2.0

var _player_in_range := false
var _is_defeated := false

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_animated_sprite.play("default")

func _process(_delta: float) -> void:
	if _is_defeated:
		return

	if _player_in_range and Input.is_action_just_pressed("ui_select"):
		_start_defeat_sequence()

func _start_defeat_sequence() -> void:
	_is_defeated = true
	_animated_sprite.play("hit")
	$HitSFX.play()
	await get_tree().create_timer(hit_duration).timeout
	if $HitSFX.playing:
			$HitSFX.stop()
	_animated_sprite.play("dead")

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		_player_in_range = true

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D:
		_player_in_range = false
