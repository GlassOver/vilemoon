class_name EquipableItemData extends ItemData

enum Type { WEAPON, ARMOR, CURIASS, 
RIGHTGAUNTLET, LEFTGAUNTLET, UNDERARMOR, LEGGINGS, BOOTS, CHARMS, RING }
@export var type : Type = Type.WEAPON
@export var modifiers : Array[ EquipableItemModifier ]
