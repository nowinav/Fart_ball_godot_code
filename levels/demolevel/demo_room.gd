class_name level extends Node2D
@export var tilemap_layer:TileMapLayer
@export var tilemap_layer2:TileMapLayer
var roomsize:Vector2
var player_scene=preload("res://entites/players/player.tscn")
var goal_spawned:bool=true
var ocean_dim:Vector2
var sand_tile_coords:Array=[Vector2(0,0),Vector2(1,0),Vector2(2,0)]
var water_tile_coords:Array=[Vector2(3,0),Vector2(6,0)]
const TILEDATA : Dictionary={
	"floor":{"source_id":3,"atlas_coords":Vector2(3,0)},
	"ceiling":{"source_id":3,"atlas_coords":Vector2(2,0)},
	"goal":{"source_id":0,"atlas_coords":Vector2(0,12)}
}
# Called when the node enters the scene tree for the first time.
func puck_spawn_handler():
	if not Global.puck_alive:
		spawn(preload("res://entites/pickable_item/pickable_item.tscn"))
		Global.puck_alive=true
func player_spawn_handler():
	if not Global.player_aliveable :
		
		spawn(player_scene,Vector2(0,40))
		Global.player_aliveable=true
func spawn(body_scene:PackedScene,spawncoords:Vector2=Vector2.ZERO):
	print(spawncoords)
	var body=body_scene.instantiate()
	if body is Pickable:
		body.tilemap_layer=tilemap_layer
	elif body is Player:
		body.tilemap_layer=tilemap_layer
	elif body is weapon:
		body.tilemap_layer=tilemap_layer
	body.global_position=spawncoords
	self.add_child(body)
func _ready() -> void:
	player_spawn_handler()
	roomsize=Vector2(randi_range(20,50),randi_range(20,50))
	ocean_dim=roomsize+Vector2(40,40)
	room_gen(roomsize,sand_tile_coords,3,false,Vector2.ZERO,Vector2(4,4))
	ocean_gen(ocean_dim,water_tile_coords,3,Vector2.ZERO)
	
func ocean_gen(size:Vector2,atlas_coords:Array,source_id:int,pos:Vector2=Vector2.ZERO):
	
	for x in range(pos.x-size.x/2,pos.x+size.x/2):
			for y in range(pos.y-size.y/2,pos.y+size.y/2):
				if randi_range(0,100)<20:
					tilemap_layer2.set_cell(Vector2(x,y),source_id,atlas_coords[0])
				else:
					tilemap_layer2.set_cell(Vector2(x,y),source_id,atlas_coords[1])
func room_gen(size :Vector2,atlas_coords:Array,source_id:int,terrain:bool=false,
pos:Vector2=Vector2.ZERO,padding:Vector2=Vector2.ZERO):
	var border:Vector2=size-padding
	var	tile_array:Array=[]
	if terrain:
		for x in range(pos.x-size.x/2,pos.x+size.x/2):
			for y in range(pos.y-size.y/2,pos.y+size.y/2):
				var vector:Vector2=Vector2(x,y)
				if vector.x<border.x and vector.y<border.y:
					tile_array.append(Vector2(x,y))
				
		tilemap_layer.set_cells_terrain_connect(tile_array,0,0)
	else:
		for x in range(pos.x-size.x/2,pos.x+size.x/2):
			for y in range(pos.y-size.y/2,pos.y+size.y/2):
				var vector:Vector2=Vector2(x,y)
				
				var atlas=atlas_coords.pick_random()
				tilemap_layer.set_cell(vector,TILEDATA.ceiling.source_id,atlas)
				if goal_spawned and vector.y<=pos.y-size.y/2+2 and y>=pos.y-size.y/2:
					goal_spawned=false
					vector.x=0
					print("goal")
					print(tilemap_layer.map_to_local(vector))
					spawn(preload("res://objects/goal/goal.tscn"),tilemap_layer.map_to_local(vector))
					spawn(preload("res://objects/goal/goal.tscn"),tilemap_layer.map_to_local(Vector2(0,-vector.y-0.5)))
			
#dw
			
func object_tile_checker(pos:Vector2):
	var object_coords=tilemap_layer.local_to_map(pos)
	
func _process(delta: float) -> void:
	player_spawn_handler()
	puck_spawn_handler()
