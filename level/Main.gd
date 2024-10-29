extends Node3D

@export var player: RigidBody3D = null
@export var player_on_screen_notifier: VisibleOnScreenNotifier3D = null
@export var camera: Camera3D = null
var player_origin: Vector3 = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_origin = player.global_position
	player_on_screen_notifier.screen_exited.connect(on_screen_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
