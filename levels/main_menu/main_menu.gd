extends Control
@export var time_scroll:HSlider
@export var match_time_label: Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	await get_tree().create_timer(1).timeout
	Global.start=true
	get_tree().change_scene_to_file("res://levels/football/footballground.tscn")


func _on_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	get_tree().quit()


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	
	
	Global.game_time=time_scroll.value*10
	match_time_label.text="Match Time:"+str(time_scroll.value)+"mins"
	print(Global.game_time)
