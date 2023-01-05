extends Interactable

@onready var present_body := $Present
@onready var lenta := $Lenta
var category_id : int
var item : WeakRef

@onready var sprite = $Icon

const RARITY_COLORS := [
	Color.WHITE,
	Color.DARK_BLUE,
	Color.DARK_RED,
	Color.YELLOW
]

func _ready() -> void:
	randomize()
	var present_mat := ORMMaterial3D.new()
	present_mat.metallic = 0.0
	present_mat.roughness = 1.0
	present_mat.albedo_color = Color8(randi_range(0,255),randi_range(0,255),randi_range(0,255),255)
	present_body.material_override = present_mat
	
	after_ready.call_deferred()
	
	var fly_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops()
	var fly_time = randf_range(1.5,1.75)
	fly_tween.tween_property(sprite,"position",sprite.position+Vector3.UP*0.5,fly_time)
	fly_tween.tween_property(sprite,"position",sprite.position+Vector3.DOWN*0.5,fly_time)
	

func after_ready() -> void:
	category_id = roll()
	match category_id:
		0:
			item = weakref(ItemBank.white_category[randi_range(0,ItemBank.white_category.size()-1)])
		1:
			item = weakref(ItemBank.blue_category[randi_range(0,ItemBank.blue_category.size()-1)])
		2:
			item = weakref(ItemBank.red_category[randi_range(0,ItemBank.red_category.size()-1)])
		3:
			item = weakref(ItemBank.yellow_category[randi_range(0,ItemBank.yellow_category.size()-1)])
			
	var lenta_mat := ORMMaterial3D.new()
	lenta_mat.metallic = 0.0
	lenta_mat.roughness = 1.0
	lenta_mat.albedo_color = RARITY_COLORS[category_id]
	lenta.material_override = lenta_mat
	
	sprite.frame = item.get_ref().icon_id
	sprite.modulate = RARITY_COLORS[category_id]

func roll() -> int:
	var res := randi_range(0,3)
	
	match res:
		0:
			if Globals.player.luck > randi_range(0,20):
				res +=1
		1:
			if randi_range(0,20)+Globals.player.luck <= 6 :
				res = roll()
			elif Globals.player.luck > randi_range(0,20):
				res += 1 if ItemBank.red_category.size() > 0 else 2
		2:
			if randi_range(0,20)+Globals.player.luck <= 10 or ItemBank.red_category.size() <= 0:
				res = roll()
		3:
			if randi_range(0,20)+Globals.player.luck <= 17 or ItemBank.yellow_category.size() <= 0:
				res = roll()
		4:
			res =roll()
	return res

func _use():
	queue_free()
	item.get_ref().apply()
