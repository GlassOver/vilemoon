class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/pause_menu/inventory/scripts/inventory slot.tscn")
var focus_index : int = 0

@export var data : InventoryData

@onready var inventory_slot_curiass: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot_Curiass"
@onready var inventory_slot_left_gaunt: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot2_LeftGaunt"
@onready var inventory_slot_right_gaunt: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot3_RightGaunt"
@onready var inventory_slot_under_armor: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot4_UnderArmor"
@onready var inventory_slot_leggings: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot5_Leggings"
@onready var inventory_slot_boots: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot6_Boots"
@onready var inventory_slot_charm_1: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot7_Charm1"
@onready var inventory_slot_charm_2: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot8_Charm2"
@onready var inventory_slot_charm_3: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot9_Charm3"
@onready var inventory_slot_ring_1: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot10_Ring1"
@onready var inventory_slot_ring_2: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot11_Ring2"
@onready var inventory_slot_ring_3: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot12_Ring3"
@onready var inventory_slot_weapon: InventorySlotUI = $"../../PanelContainer3/GridContainer/InventorySlot13_Weapon"





func _ready() -> void:
	clear_inventory()
	update_inventory()
	data.changed.connect(on_inventory_changed)
	pass
	
	
func clear_inventory() -> void:
	for c in get_children():
		c.queue_free()


func update_inventory(i : int = 0) -> void:
	
	var inventory_slots: Array[SlotData] = data.inventory_slots()
	
	for s in inventory_slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
		new_slot.focus_entered.connect(item_focused)
		
	var e_slots : Array[SlotData] = data.equipment_slots()
	inventory_slot_curiass.set_slot_data(e_slots[13])
	inventory_slot_weapon.set_slot_data(e_slots[25])
		
	await get_tree().process_frame


	
	
func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return
	pass
	
	
func on_inventory_changed() -> void:
	var i = focus_index
	clear_inventory()
	update_inventory(i)
