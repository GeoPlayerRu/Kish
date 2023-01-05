extends CharacterBody3D

class_name Player

const JUMP_VELOCITY = 4.5
const DEAD_BODY = preload("res://Scenes/dead_body.tscn")

var max_hp := 4.0
var hp := max_hp:
	set(value):
		hp = clamp(value,0,max_hp)

var luck := 1:
	set(value):
		luck = min(value,15)
var vampirisim := 0.0
var hp_regen := 0.05

var speed := 5.0



@onready var camera : Camera3D = $Camera3D
@onready var weapon := $Camera3D/Active/Rifle
@onready var health := $Health

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.player = self
	
	ItemBank.white_category.append(ItemBank.Item.new(2,func(): luck += 1))
	ItemBank.white_category.append(ItemBank.Item.new(3,func(): speed += 0.5))
	
	ItemBank.blue_category.append(ItemBank.Item.new(5,func(): hp_regen += 0.1))
	ItemBank.blue_category.append(ItemBank.Item.new(7,func(): luck += 2))
	ItemBank.blue_category.append(ItemBank.Item.new(8,func(): vampirisim += 0.25))
	
	

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
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	weapon.accuracy = 0.1 + abs(sign(direction.x)/2) + abs(sign(direction.z)/2) + (0.0 if is_on_floor() else 1.0)
	
	move_and_slide()

func _input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x))
		camera.rotation.x = clamp(camera.rotation.x-deg_to_rad(event.relative.y),-1.5708,1.5708)

func deal_damage(damage : float) -> void:
	hp-=damage
	health.material.set_shader_parameter("Amount",hp/max_hp*2.0)
	if hp <= 0:
		var db = DEAD_BODY.instantiate()
		get_parent().add_child(db)
		db.global_transform = global_transform
		db.get_node("Camera3D").rotation = camera.rotation
		db.get_node("Camera3D").make_current()
		db.apply_central_impulse(velocity)
		queue_free()

func on_enemy_death():
	hp += vampirisim




func _on_regen_timer_timeout() -> void:
	hp += hp_regen
