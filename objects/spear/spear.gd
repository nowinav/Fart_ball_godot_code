class_name  spear extends weapon
var player : CharacterBody2D
var returable:bool


func _physics_process(delta: float) -> void:
	if throwable:
		throw(dir)
	friction_handler()
	move_and_slide()
func fire(dir,force=600):
	
		velocity+=dir*force
		throwable=false
		collision_shape.disabled=false
		#if returable:
			#look_at(player.global_position)
			#await  get_tree().create_timer(3).timeout
			#print("coming")
			#velocity+=self.global_position.direction_to(player.global_position)*force
			#returable=false
