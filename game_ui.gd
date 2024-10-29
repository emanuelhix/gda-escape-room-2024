extends Node2D

@onready var line_edit: LineEdit = $Control/LineEdit
@onready var name_label: Label = $Control/NameLabel

func _ready():
	line_edit.text_submitted.connect(_on_text_entered)

func _on_text_entered(text: String):
	print(text)
