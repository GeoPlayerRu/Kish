extends Node3D

const ENEMIES := [
	preload("res://Scenes/Enemies/palpalich.tscn"),
	preload("res://Scenes/Enemies/terrible_fate.tscn"),
	preload("res://Scenes/Enemies/velcro.tscn"),
	preload("res://Scenes/Enemies/mudrij_dub.tscn"),
	preload("res://Scenes/Enemies/imp.tscn")]
const SPAWNER := preload("res://Scenes/enemy_spawner.tscn")

var chances := [
	[100,25,1,0,0],
	[100,25,1,0,0],
	[100,25,5,1,0],
	[100,25,5,5,25],
	[0,60,25,5,25],
	[0,60,25,10,30],
	[0,80,40,10,75],
	[0,0,40,25,75],
	[100,80,60,30,25],
	[100,80,60,30,40],
	[100,80,60,30,29],
	[0,50,50,50,4],
	[100,50,65,65,53],
	[100,50,65,65,19],
	[0,0,0,0,100],
	[20,20,20,20,20],	
	]

func _ready():
	randomize()
	WaveSystem.waves = 0
	WaveSystem.locked = false
	WaveSystem.started = false
	WaveSystem.wave_spawner = self

func spawn():
	if WaveSystem.waves == 15:
		queue_spawn_picked(load("res://Scenes/Enemies/boss_of_the_gym.tscn"))
	var count = randi_range(WaveSystem.waves/2,WaveSystem.waves) + 2
	WaveSystem.enemies = count
	for i in range(count):
		queue_spawn()
		
func pick() -> PackedScene:
	for i in range(ENEMIES.size()-1,0,-1):
		if randi_range(0,100) <= chances[WaveSystem.waves][i]:
			return ENEMIES[i]
			
	return ENEMIES[0]

func queue_spawn():
	var children = get_children()
	children[randi_range(0,children.size()-1)].queue(pick())
	
func queue_spawn_picked(picked : PackedScene):
	var children = get_children()
	children[randi_range(0,children.size()-1)].queue(picked)
