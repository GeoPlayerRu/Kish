extends Node3D

@export var current_barrel : Node3D
@onready var barrels : Array=[
	$Center/Barrels/Barrel_STD,
	$Center/Barrels/Barrel_LONG,
	$Center/Barrels/Barrel_SHORT
]
@onready var animator := $ReloadSTD

@onready var reload_timer := $ReloadTimer
@onready var autoshoot_timer := $AutoshootTimer

@onready var center := $Center
@onready var start_center : Vector3

@onready var reload_sound := $ReloadSound


var max_ammo := 1.0
var current_ammo := max_ammo:
	set(value):
		if value < current_ammo and ch_to_not_consume != 0:
			if 100/ch_to_not_consume >= randi_range(0,100):
				return
		current_ammo = clamp(value,0,max_ammo)
		if current_ammo == 0:
			animator.play("BeginReload")
			can_shoot = false
			reload_sequence()

var damage := 10
var damage_mult := 1.0
var ammo_regen := 0.0
var explosion_radius := 0.0
var double_pen_ch := -1.0
var ch_to_not_consume := 0.0:
	set(value):
		if value <= 0:
			return
		ch_to_not_consume = value
var accuracy := 1.0

var can_shoot : bool = true
var autofire := false
var magazine := false
var knockback := 0.3

var explosion = preload("res://Scenes/explosion.tscn")

var knockback_tween : Tween

func _ready() -> void:
	#Registering items
	ItemBank.white_category.append(ItemBank.Item.new(0,func(): damage += 1))
	ItemBank.white_category.append(ItemBank.Item.new(1,func(): reload_timer.wait_time -= 0.1))
	
	ItemBank.blue_category.append(ItemBank.Item.new(6,func(): ammo_regen += 0.1))
	
	start_center = center.position
	
	var long_barrel = ItemBank.Item.new(10)
	var short_barrel = ItemBank.Item.new(11)
	
	long_barrel.action = func(): 
		switch_barrels(1)
		reload_timer.wait_time += 0.5
		ItemBank.red_category.erase(short_barrel)
		ItemBank.red_category.erase(long_barrel)
		knockback += 0.4
	
	short_barrel.action = func(): 
		switch_barrels(2)
		reload_timer.wait_time -= 0.5
		ItemBank.red_category.erase(short_barrel)
		ItemBank.red_category.erase(long_barrel)
		knockback += 0.3
	
	
	ItemBank.red_category.append(long_barrel)
	ItemBank.red_category.append(short_barrel)
	
	#Clip upgrade
	var clip_uprgade = ItemBank.Item.new(12)
	var caliber_upgrade = ItemBank.Item.new(0)
	
	clip_uprgade.action = func(): 
		$Center/Clip.visible = true
		max_ammo += 4.0
		damage -= 1
		ItemBank.red_category.erase(clip_uprgade)
		ItemBank.red_category.erase(caliber_upgrade)
		current_ammo = max_ammo
		var mag = ItemBank.Item.new(15)
		mag.action = func(): 
			if mag.used:
				max_ammo+=1
			else:
				magazine = true
				max_ammo += 5
				damage-=3
				reload_timer.wait_time -= 0.2
				$Center/Clip.visible = false
				$Center/Magazine.visible = true
				animator = $ReloadMagazine
				reload_timer.one_shot = true
			current_ammo = max_ammo
		ItemBank.yellow_category.append(mag)
	
	caliber_upgrade.action = func():
		damage_mult = 1.25
		ItemBank.red_category.erase(clip_uprgade)
		ItemBank.red_category.erase(caliber_upgrade)
		var minishark = ItemBank.Item.new(18)
		minishark.action = func(): 
			if minishark.used:
				ch_to_not_consume -= 0.1
			else:
				ch_to_not_consume = 3
		ItemBank.yellow_category.append(minishark)
	
	ItemBank.red_category.append(clip_uprgade)
	ItemBank.red_category.append(caliber_upgrade)
	
	var af = ItemBank.Item.new(13)
	var rounds = ItemBank.Item.new(14)
	
	af.action = func():
		autofire = true
		damage -=2
		$Center/AS.visible =true
		ItemBank.red_category.erase(af)
		ItemBank.red_category.erase(rounds)
		
	rounds.action = func():
		explosion_radius += 1
		current_barrel.on_hit = func(pos):
			var explo = explosion.instantiate()
			get_tree().current_scene.add_child(explo)
			explo.global_position = pos
			explo.damage = damage * damage_mult / 4
			explo.radius = explosion_radius
		reload_timer.wait_time += 1.0
		
		
		ItemBank.red_category.erase(af)
		ItemBank.red_category.erase(rounds)
	
	ItemBank.red_category.append(af)
	ItemBank.red_category.append(rounds)
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if autofire:
				if event.pressed:
					print("autofire")
					fire()
					autoshoot_timer.start()
				else:
					autoshoot_timer.stop()
			else:
				if event.pressed:
					fire()
			


func switch_barrels(barrel_index : int):
	var popped = barrels.pop_at(barrel_index)
	current_barrel.set_data(popped)
	for bar in barrels:
		bar.queue_free()
	popped.visible = true

func fire():
	if can_shoot == false:
		return
	current_barrel.accuracy = accuracy
	current_barrel.shoot(damage*damage_mult)
	current_ammo-=1
	center.position.z -= knockback
	if knockback_tween:
		knockback_tween.kill()
	knockback_tween = create_tween()
	knockback_tween.tween_property(center,"position",start_center,0.2)
		
	

func reload_sequence():
	reload_timer.start()
	if magazine:
		await reload_timer.timeout
		current_ammo = max_ammo
		reload_sound.play()
	else:
		while current_ammo < max_ammo:
			await reload_timer.timeout
			current_ammo += 1
			reload_sound.play()
		reload_timer.stop()
	animator.play("EndReload")
	await animator.animation_finished
	can_shoot = true




func refill() -> void:
	if ammo_regen > 0:
		current_ammo += ammo_regen
