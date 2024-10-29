extends Node3D

var origin: Vector3 = Vector3()
@export var linear_velocity: Vector3
@export var time: float = 5
@onready var body: RigidBody3D = $RigidBody3D
@onready var original_velocity = body.linear_velocity
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(time)
	timer.timeout.connect(reset)
	body.linear_velocity = linear_velocity
	original_velocity = body.linear_velocity
	origin = self.global_position
	body.body_entered.connect(on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_body_entered(other_body):
	if other_body.name == "Player":
		get_parent().on_screen_exited()
		reset()

func reset():
	body.global_position = origin
	body.linear_velocity = original_velocity
	body.angular_velocity = Vector3()
	
