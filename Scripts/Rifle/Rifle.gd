extends Node3D

const SHELL := preload("res://Scenes/Rifle/shell.tscn")

@export var current_barrel : Node3D
@onready var barrels : Array=[
	$Center/Barrels/Barrel_STD,
	$Center/Barrels/Barrel_LONG,
	$Center/Barrels/Barrel_SHORT
]
@onready var animator : AnimationPlayer = $ReloadSTD

@onready var reload_timer := $ReloadTimer
@onready var cooldown : Timer = $Cooldown

@onready var center := $Center
@onready var start_center : Vector3

@onready var reload_sound := $ReloadSound

@onready var eject_position := $Center/ShellEjection


var max_ammo := 1.0
var current_ammo := max_ammo:
	set(value):
		if value < current_ammo and ch_to_not_consume != 0:
			if 100/ch_to_not_consume >= randi_range(0,100):
				return
		current_ammo = clamp(value,0,max_ammo)
		if current_ammo == 0:
			reload_sequence()

var damage := 10.0
var damage_mult := 1.0
var explosion_radius := 0.0
var ch_to_not_consume := 0.0:
	set(value):
		if value <= 0:
			return
		ch_to_not_consume = value
var accuracy := 1.0

var reloading : bool
var autofire := false
var magazine := false
var knockback := 0.3

var consume := 1

var explosion = preload("res://Scenes/explosion.tscn")

var knockback_tween : Tween

func _ready() -> void:
	#Registering items
	ItemBank.white_category.append(ItemBank.Item.new("desc_dmg1",0,func(): damage += damage * 0.05))
	ItemBank.white_category.append(ItemBank.Item.new("desc_rld1",1,func(): reload_timer.wait_time -= 0.1))
	
	ItemBank.blue_category.append(ItemBank.Item.new("desc_firerate",7,func(): cooldown.wait_time -= 0.25))
	ItemBank.blue_category.append(ItemBank.Item.new("desc_dmg2",8,func(): damage += damage * 0.1))
	ItemBank.blue_category.append(ItemBank.Item.new("desc_rld2",9,func(): reload_timer.wait_time -= reload_timer.wait_time*0.05))
	
	start_center = center.position
	
	var long_barrel = ItemBank.Item.new("desc_lb",12)
	var short_barrel = ItemBank.Item.new("desc_sb",13)
	
	long_barrel.action = func(): 
		switch_barrels(1)
		reload_timer.wait_time += reload_timer.wait_time * 0.15
		cooldown.wait_time += cooldown.wait_time *  0.25
		ItemBank.red_category.erase(short_barrel)
		ItemBank.red_category.erase(long_barrel)
		knockback += 0.4
		damage_mult += 0.25
	
	short_barrel.action = func(): 
		switch_barrels(2)
		reload_timer.wait_time -= reload_timer.wait_time * 0.25
		cooldown.wait_time -= cooldown.wait_time * 0.5
		ItemBank.red_category.erase(short_barrel)
		ItemBank.red_category.erase(long_barrel)
		knockback += 0.3
	
	
	ItemBank.red_category.append(long_barrel)
	ItemBank.red_category.append(short_barrel)
	
	#Clip upgrade
	var clip_uprgade = ItemBank.Item.new("desc_clip",14)
	var caliber_upgrade = ItemBank.Item.new("desc_cal",17)
	
	clip_uprgade.action = func(): 
		$Center/Clip.visible = true
		max_ammo += 4.0
		damage -= damage * 0.1
		ItemBank.red_category.erase(clip_uprgade)
		ItemBank.red_category.erase(caliber_upgrade)
		current_ammo = max_ammo
		var mag = ItemBank.Item.new("desc_mag",20)
		mag.action = func(): 
			if mag.used:
				max_ammo+=1
				if max_ammo >= 15:
					ItemBank.yellow_category.erase(mag)
			else:
				magazine = true
				max_ammo += 5
				damage-=3
				reload_timer.wait_time -= reload_timer.wait_time * 0.2
				$Center/Clip.visible = false
				$Center/Magazine.visible = true
				animator.play("RESET")
				animator = $ReloadMagazine
				reload_timer.one_shot = true
			current_ammo = max_ammo
		ItemBank.yellow_category.append(mag)
	
	caliber_upgrade.action = func():
		damage_mult += 0.25
		cooldown.wait_time += cooldown.wait_time * 0.15
		ItemBank.red_category.erase(clip_uprgade)
		ItemBank.red_category.erase(caliber_upgrade)
		var minishark = ItemBank.Item.new("desc_mini",23)
		minishark.action = func(): 
			if minishark.used:
				ch_to_not_consume -= 0.1
				if ch_to_not_consume <= 1.333:
					
					ItemBank.yellow_category.erase(minishark)
			else:
				ch_to_not_consume = 3
		ItemBank.yellow_category.append(minishark)
	
	ItemBank.red_category.append(clip_uprgade)
	ItemBank.red_category.append(caliber_upgrade)
	
	var af = ItemBank.Item.new("desc_af",15)
	var rounds = ItemBank.Item.new("desc_rounds",16)
	
	af.action = func():
		autofire = true
		damage -= damage * 0.2
		cooldown.wait_time /= 2.0
		$Center/AS.visible =true
		ItemBank.red_category.erase(af)
		ItemBank.red_category.erase(rounds)
		
	rounds.action = func():
		explosion_radius += 1
		consume += 1
		current_barrel.on_hit = func(pos):
			var explo = explosion.instantiate()
			get_tree().current_scene.add_child(explo)
			explo.global_position = pos
			explo.damage = damage * damage_mult / 4
			explo.radius = explosion_radius
		cooldown.wait_time += cooldown.wait_time * 0.15
		var rockets := ItemBank.Item.new("desc_rockets",22)
		rockets.action = func():
			current_barrel.projectile = load("res://Scenes/Rifle/puzoket.tscn")
			cooldown.wait_time += cooldown.wait_time * 0.15
			ItemBank.yellow_category.erase(rockets)
			consume += 1
		
		ItemBank.yellow_category.append(rockets)
		
		ItemBank.red_category.erase(af)
		ItemBank.red_category.erase(rounds)
	ItemBank.red_category.append(af)
	ItemBank.red_category.append(rounds)

func _input(event: InputEvent) -> void:
	if event.is_action("fire"):
		if autofire:
			if event.is_pressed():
				cooldown.one_shot = false
				await get_tree().process_frame
				fire()
				if !cooldown.timeout.is_connected(fire):
					cooldown.timeout.connect(fire.bind(true))
			else:
				if cooldown.timeout.is_connected(fire):
					cooldown.timeout.disconnect(fire)
				cooldown.one_shot = true
				
		else:
			if event.is_pressed():
				fire()
	if event.is_action("reload") and event.is_pressed() and !reloading and current_ammo < max_ammo:
		reload_sequence()


func switch_barrels(barrel_index : int):
	var popped = barrels.pop_at(barrel_index)
	current_barrel.set_data(popped)
	for bar in barrels:
		bar.queue_free()
	popped.visible = true

func fire(skip := false):
	if reloading == true or (cooldown.time_left > 0 and not skip):
		return
	current_barrel.accuracy = accuracy
	current_barrel.shoot(damage*damage_mult)
	current_ammo-=consume
	center.position.z -= knockback
	
	var shell = SHELL.instantiate()
	get_tree().current_scene.add_child(shell)
	shell.global_transform = eject_position.global_transform
	
	cooldown.start()
	
	
	if knockback_tween:
		knockback_tween.kill()
	knockback_tween = create_tween()
	knockback_tween.tween_property(center,"position",start_center,0.2)
		
	
	

func reload_sequence():
	animator.play("BeginReload")
	reloading = true
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
	reloading = false

