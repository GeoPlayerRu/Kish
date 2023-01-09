extends CharacterBody3D

class_name Player

const JUMP_VELOCITY = 4.5
const DEAD_BODY = preload("res://Scenes/dead_body.tscn")

var max_hp := 4.0
var hp := max_hp:
	set(value):
		var value_clamped = clamp(value,0,max_hp)
		create_tween().tween_method(set_hp_vinette,hp,value_clamped,0.25)
		hp = value_clamped

var luck := 1:
	set(value):
		luck = min(value,5)
var vampirisim := 0.0

var speed := 5.0
var speed_mult := 1.0


@onready var camera : Camera3D = $Camera3D
@onready var weapon := $Camera3D/Active/Rifle
@onready var health := $Health
@onready var moroz := $Moroz
@onready var hit_sound := $HitSound

var moroz_tween : Tween

var sensivity : float = 1
var gamepad_sensivity : float = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.player = self
	
	var luckItem = ItemBank.Item.new(2)
	luckItem.action = func(): 
		luck += 1
		if luck >= 5:
			ItemBank.white_category.erase(luckItem)
	
	ItemBank.white_category.append(luckItem)
	ItemBank.white_category.append(ItemBank.Item.new(3,func(): speed += 0.75))
	
	ItemBank.blue_category.append(ItemBank.Item.new(6,func(): vampirisim += 0.25))
	
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed * speed_mult
		velocity.z = direction.z * speed * speed_mult
	else:
		velocity.x = move_toward(velocity.x, 0, speed * speed_mult)
		velocity.z = move_toward(velocity.z, 0, speed * speed_mult)
	
	weapon.accuracy = 0.1 + abs(sign(direction.x)/2) + abs(sign(direction.z)/2) + (0.0 if is_on_floor() else 1.0)
	
	move_and_slide()
	
	var gamepad_look_dir := Input.get_vector("look_left","look_right","look_up","look_down")
	rotate_y(-deg_to_rad(gamepad_look_dir.x) * gamepad_sensivity)
	camera.rotation.x = clamp(camera.rotation.x-deg_to_rad(gamepad_look_dir.y)* gamepad_sensivity,-1.5708,1.5708)

func _input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x) * sensivity)
		camera.rotation.x = clamp(camera.rotation.x-deg_to_rad(event.relative.y) * sensivity,-1.5708,1.5708)

func deal_damage(damage : float) -> void:
	hit_sound.play()
	hp-=damage
	if hp <= 0:
		var db = DEAD_BODY.instantiate()
		get_parent().add_child(db)
		db.global_transform = global_transform
		db.get_node("Camera3D").rotation = camera.rotation
		db.get_node("Camera3D").make_current()
		db.apply_central_impulse(velocity)
		queue_free()

func on_enemy_death():
	hp = hp + clamp(vampirisim,0.0,max_hp/4.0)

func set_hp_vinette(value : float):
	health.material.set_shader_parameter("Amount",value/max_hp*1.5)


func start_morozing():
	if moroz_tween:
		moroz_tween.kill()
	moroz_tween = create_tween()
	moroz_tween.tween_method(set_moroz,1.5,-1.0,10.0)
	moroz_tween.tween_method(deal_damage,10,10,0.1)

func stop_morozing():
	moroz_tween.kill()
	moroz_tween = create_tween()
	moroz_tween.tween_method(set_moroz,moroz.material.get_shader_parameter("Amount"),1.5,0.5)
	moroz.material.set_shader_parameter("Amount",2.0)

func set_moroz(value):
	moroz.material.set_shader_parameter("Amount",value)

