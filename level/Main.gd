extends Node3D

@export var player: RigidBody3D = null
@export var player_on_screen_notifier: VisibleOnScreenNotifier3D = null
@export var camera: Camera3D = null
var player_origin: Vector3 = Vector3()

@onready var finish_line: Area3D = $FinishLine
@onready var fade_screen = $BlackFadeLayer
@onready var timer = $GameTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_origin = player.global_position
	player_on_screen_notifier.screen_exited.connect(on_screen_exited)
	#score_tracker.game_completed.connect(on_all_antidotes_collected)
	timer.timeout.connect(func(): on_all_antidotes_collected())
	finish_line.body_entered.connect(func(other_body): on_all_antidotes_collected())
func on_screen_exited():
	if player.find_child("AnimationPlayer").is_playing():
		player.find_child("AnimationPlayer").stop()
	if player.tween and player.tween.is_running():
		player.tween.kill()
	player.freeze_mode = RigidBody3D.FREEZE_MODE_STATIC
	player.global_position = player_origin
	player.force_update_transform()
	player.linear_velocity = Vector3()
	player.angular_velocity = Vector3()
	camera.force_reset()
	

func _input(event):
	if Input.is_action_just_pressed("forward"):
		camera.global_override = true
	
func on_all_antidotes_collected():
	fade_screen.fade_to_black(true)
	camera.global_override = false

func on_game_timer_ended():
	fade_screen.fade_to_black(false) 
	#score_tracker.game_completed.disconnect(on_all_antidotes_collected)
