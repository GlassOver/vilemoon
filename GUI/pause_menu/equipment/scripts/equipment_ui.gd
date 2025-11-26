class_name EquipmentUI extends Control

const EQUIPMENT_SLOT = preload("res://GUI/pause_menu/equipment/equipment_slot.tscn")

@export var data : EquipInventoryData

func _ready() -> void:
	update_inventory()
	clear_inventory()
	pass
	
	

func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()
		

func update_inventory() -> void:
	for s in data.EquipSlots:
		var new_slot = EQUIPMENT_SLOT.instantiate()
		add_child(new_slot)
		
	get_child(0).grab_focus()


		
