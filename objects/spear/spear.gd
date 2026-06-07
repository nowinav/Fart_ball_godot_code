class_name  spear extends weapon
var dir:Vector2
var throwable:bool
func  _ready() -> void:
	
	friction_coeff=0.9
func throw(dir):
		velocity+=dir*10
		throwable=false
func _physics_process(delta: float) -> void:
	if throwable:
		throw(dir)
	
	move_and_slide()
