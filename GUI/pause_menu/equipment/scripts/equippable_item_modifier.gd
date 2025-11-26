class_name EquipableItemModifier extends Resource

enum Type { HEALTH, SPIRIT, ATTACK, DEFENSE, SPEED, 
SPIRITPOTENCY, WILLPOWER, FIRERES, LIFERES, SUNRES, DEATHRES, ICERES, 
NIGHTRES, TIERCAP, FIREPOT, LIFEPOT, SUNPOT, DEATHPOT, ICEPOT, 
NIGHTPOT  }
#Special types of armor that limits growth to a specific stat.  
#Special types of effects, like doubling spells, lingering attacks/extra attacks
#Armor that increases or decreases your equipment slots.
@export var type : Type = Type.HEALTH
@export var value : int = 1
