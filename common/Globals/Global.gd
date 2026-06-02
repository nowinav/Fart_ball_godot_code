extends Node
var player_speed=100
var player_max_speed=200
var player_health=10
var player_state :player_states
var player_high_level:int
var player_max_high_level:int=5
var player_picked:bool
var tile_selected_pos:Vector2
var player_pos:Vector2
var player_aliveable:bool
enum player_states{RUN,IDLE,ATTACK}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
