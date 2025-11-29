class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/pause_menu/inventory/scripts/inventory slot.tscn")
var focus_index : int = 0

@export var data : InventoryData

#region /// On ready slots
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
#endregion



func _ready() -> void:
	clear_inventory()
	update_inventory()
	data.changed.connect(on_inventory_changed)
	data.equipment_changed.connect(on_inventory_changed)
	pass
	
	
func clear_inventory() -> void:
	for c in get_children():
		c.set_slot_data(null)


func update_inventory(_i : int = 0) -> void:
	clear_inventory()
	
	var inventory_slots: Array[SlotData] = data.inventory_slots()
	
	for i in inventory_slots.size():
		var slot : InventorySlotUI = get_child(i)
		slot.set_slot_data(inventory_slots[i])
		
	var e_slots : Array[SlotData] = data.equipment_slots()
	inventory_slot_curiass.set_slot_data(e_slots[0])
	inventory_slot_weapon.set_slot_data(e_slots[6])
	inventory_slot_left_gaunt.set_slot_data(e_slots[2]) 
	inventory_slot_right_gaunt.set_slot_data(e_slots[3])
	inventory_slot_under_armor.set_slot_data(e_slots[1])
	inventory_slot_leggings.set_slot_data(e_slots[4])
	inventory_slot_boots.set_slot_data(e_slots[5])
	inventory_slot_charm_1.set_slot_data(e_slots[7])
	inventory_slot_charm_2.set_slot_data(e_slots[8])
	inventory_slot_charm_3.set_slot_data(e_slots[9])
	inventory_slot_ring_1.set_slot_data(e_slots[10])
	inventory_slot_ring_2.set_slot_data(e_slots[11]) 
	inventory_slot_ring_3.set_slot_data(e_slots[12]) 
	
	
func item_focused() -> void:
	for i in get_child_count():
		if get_child(i).has_focus():
			focus_index = i
			return
	pass
	
func on_inventory_changed() -> void:
	update_inventory(false)
