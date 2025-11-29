class_name InventorySlotUI extends Button

var slot_data: SlotData : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var ItemMenu: CanvasLayer = $"../../../.."



func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect(item_focused)
	focus_exited.connect(item_unfocused)
	self.pressed.connect(self.item_pressed)
	#this will make it so you can select an item.
	#maybe I need to make it so it changes slots? 
	#bottom slot, and that bottom slot will be detected
	#by the player manager so it can display on the main
	#screen, and then we'll have a script that connected
	#item use built in to the player? 
	
	
func set_slot_data(value: SlotData) -> void:
	slot_data = value
	if slot_data == null:
#		texture_rect.texture = null
#		label.text = ""
		return
#	texture_rect.texture = slot_data.item_data.texture
#	label.text = str(slot_data.quantity)


	
func item_focused() -> void:
	if slot_data != null:
		if slot_data.item_data != null:
			ItemMenu.update_item_description(slot_data.item_data.description)
			ItemMenu.update_item_name(slot_data.item_data.name)
			ItemMenu.update_item_quality(slot_data.item_data.quality)
	pass

func item_unfocused() -> void:
	ItemMenu.update_item_description("")
	ItemMenu.update_item_name("")
	ItemMenu.update_item_quality("")

	pass
	

func item_pressed() -> void:
	print("used")
	if slot_data:
		if slot_data.item_data:
			var item = slot_data.item_data
			
			if item is EquipableItemData:
				PlayerManager.INVENTORY_DATA.equip_item(slot_data)
				return
			
			var was_used = item.use()
			if was_used == false:
				return
			slot_data.quantity -= 1
			label.text = str (slot_data.quantity)
