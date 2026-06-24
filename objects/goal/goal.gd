class_name goal
extends StaticBody2D
var type:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func goal_handler():
	if type==1:
		Global.player1goals+=1
	elif type==2:
		Global.player2goals+=1
	print(Global.player1goals,"-",Global.player2goals)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Pickable:
		body.on_death()
		print("scored")
		goal_handler()
		
		get_tree().paused=true
		await get_tree().create_timer(1).timeout
		get_tree().paused=false
		get_tree().reload_current_scene()
