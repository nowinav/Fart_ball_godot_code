extends RigidBody2D
class_name Pickable
@export var collision: CollisionShape2D
var throwforce:Vector2=Vector2(100,-200)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.player_picked:
		collision.disabled=true
		set_physics_process(false)
	else:
		collision.disabled=false
		set_physics_process(true)
func throw(direction:Vector2)->void:
	await get_tree().create_timer(0.1).timeout
	collision.disabled=false
	
