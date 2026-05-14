extends Node2D

@onready var start_button = $StartButton
@onready var quit_button = $QuitButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	start_button.grab_focus()

func _on_start_pressed():
	GameState.reset_run()
	get_tree().change_scene_to_file("res://intro_scene.tscn")

func _on_quit_pressed():
	get_tree().quit()
