extends Node



class Item:
	var action : Callable
	var icon_id : int
	var used : bool = false
	
	func apply():
		action.call()
		used = true
	
	func _init(_icon_id : int, _action : Callable = func(): pass) -> void:
		action = _action
		icon_id = _icon_id

var white_category : Array[Item] = []
var blue_category : Array[Item] = []
var red_category : Array[Item] = []
var yellow_category : Array[Item] = []
