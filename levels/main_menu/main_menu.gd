extends Control
@export var time_scroll:HSlider
@export var match_time_label: Label
@export var mouse_click_sound:AudioStreamPlayer2D
@export var Bgmusic:AudioStreamPlayer2D
@export var slider:AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_scroll.value=1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	mouse_click_sound.playing=true
	await get_tree().create_timer(0.25).timeout
	Global.goal_reset()
	Global.match_time_left=Global.game_time
	Global.start=true
	Global.tutorial=false
	get_tree().change_scene_to_file("res://levels/football/footballground.tscn")


func _on_button_2_pressed() -> void:
	
	mouse_click_sound.playing=true
	await get_tree().create_timer(0.25).timeout
	Global.tutorial=true
	get_tree().change_scene_to_file("res://levels/football/footballground.tscn")


func _on_button_3_pressed() -> void:
	
	mouse_click_sound.playing=true
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	
	
	Global.game_time=time_scroll.value*60
	match_time_label.text="Match Time:"+str(time_scroll.value)+"mins"
	print(Global.game_time)
	Global.match_time_left=Global.game_time
