extends Node3D

@export var player: CharacterBody3D = null
@export var player_on_screen_notifier: VisibleOnScreenNotifier3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_on_screen_notifier.screen_exited.connect(on_screen_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_screen_exited():
	get_tree().reload_current_scene()
