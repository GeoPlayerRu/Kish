extends Node



class Item:
	var action : Callable
	var icon_id : int
	var used : bool = false
	var key : String
	
	func apply():
		action.call()
		used = true
		Globals.item_description.queue(key)
	
	func _init(_key : String, _icon_id : int, _action : Callable = func(): pass) -> void:
		action = _action
		icon_id = _icon_id
		key = _key
		

func restart():
	white_category.clear()
	blue_category.clear()
	red_category.clear()
	yellow_category.clear()

var white_category : Array[Item] = []
var blue_category : Array[Item] = []
var red_category : Array[Item] = []
var yellow_category : Array[Item] = []
