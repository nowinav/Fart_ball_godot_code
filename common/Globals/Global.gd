extends Node
var player_speed=100
var player_max_speed=150
var player1goals:int
var player2goals:int
var player_health=3
var player_state :player_states
var drunk_level:int
var puck_pos:Vector2
var fart_level:int=3
var tutorial:bool
var player_max_high_level:int=5
var player_picked:bool
var football_ai_alive:bool
var football_ai_speed:int=100
var start:bool
var match_time_left:float=60
var game_time:float=60
var tile_selected_pos:Vector2
var player_pos:Vector2
var player_aliveable:bool
var puck_alive:bool
var marker_pos:Vector2
var goal1_coords:Vector2
var goal2_coords:Vector2
var team1_goals:int
var team2_goals:int
var ballmarker_2:Vector2
var ballmarker_3:Vector2
enum player_states{RUN,IDLE,ATTACK}
func reset():
	drunk_level=3
	player_speed=100
	player_health=3
	player_aliveable=false
	player_max_high_level=5
	player_max_speed=100
	puck_alive=false
	football_ai_alive=false
	team1_goals=0
	team2_goals=0
	football_ai_speed=100
	#player1goals=0
	#player2goals=0
func goal_reset():
	player1goals=0
	player2goals=0
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	
	pass # Replace with function body.
func _process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
