@tool
class_name room_gen extends Node
@export var room_dim: Vector2i=Vector2i(40,40)
@export var division_steps : int=5
@export var tilemap_layer: TileMapLayer
# Called when the node enters the scene tree for the first time.
const TILEDATA : Dictionary={
	"floor":{"source_id":0,"atlas_coords":Vector2(1,7)},
	"ceiling":{"source_id":0,"atlas_coords":Vector2(1,9)}
}
func _ready() -> void:
	rect_gen(room_dim,TILEDATA.ceiling.atlas_coords,TILEDATA.ceiling.source_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	room_gen(room_dim,TILEDATA.floor.atlas_coords,TILEDATA.floor.source_id)
func room_gen(dimension:Vector2i,atlas_coords:Vector2i,source_id:int=0):
	pass
func rect_gen(dimension:Vector2i,atlas_coords:Vector2i,source_id:int=0):
	for x in range(dimension.x):
		for y in range(dimension.y):
			tilemap_layer.set_cell(Vector2(x,y),source_id,atlas_coords)
