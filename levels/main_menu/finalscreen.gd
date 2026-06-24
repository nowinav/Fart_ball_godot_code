extends Node2D

@export var label:Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.player1goals>Global.player2goals:
		label.text="you Won"
	elif Global.player1goals<Global.player2goals:
		label.text="you Lost"
	else:
		label.text="Draw"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://levels/main_menu/main_menu.tscn")
