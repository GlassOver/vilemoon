class_name GlobInvSlot extends Button

var slot_data: SlotData : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label



func _ready() -> void:
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
		return
	texture_rect.texture = slot_data.item_data.texture
	label.text = str(slot_data.quantity)
	
	
func item_pressed() -> void:
	print("used")
	if slot_data:
		if slot_data.item_data:
			var was_used = slot_data.item_data.use()
			if was_used == false:
				return
			slot_data.quantity -= 1
			label.text = str (slot_data.quantity)
