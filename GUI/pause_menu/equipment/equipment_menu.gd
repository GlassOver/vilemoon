extends CanvasLayer



@onready var stats: Node = $Control/Stats
@onready var hp_label: Label = $Control/Stats/HpCont/Label2
@onready var sp_label: Label = $Control/Stats/HpCont2/Label2
@onready var str_label: Label = $Control/Stats/StatsCont/HBoxContainer3/Label2
@onready var def_label: Label = $Control/Stats/StatsCont/HBoxContainer4/Label2
@onready var spd_label: Label = $Control/Stats/StatsCont/HBoxContainer5/Label2
@onready var spi_label: Label = $Control/Stats/StatsCont/HBoxContainer6/Label2
@onready var wil_label: Label = $Control/Stats/StatsCont/HBoxContainer7/Label2

@onready var hp_changed: Label = $Control/Stats/HpCont/HP_changed
@onready var sp_changed: Label = $Control/Stats/HpCont2/SP_changed
@onready var str_changed: Label = $Control/Stats/StatsCont/HBoxContainer3/Str_changed
@onready var def_changed: Label = $Control/Stats/StatsCont/HBoxContainer4/Def_changed
@onready var spd_changed: Label = $Control/Stats/StatsCont/HBoxContainer5/Spd_changed
@onready var spp_changed: Label = $Control/Stats/StatsCont/HBoxContainer6/Spp_changed
@onready var wil_changed: Label = $Control/Stats/StatsCont/HBoxContainer7/Wil_changed




func _ready() -> void:
	update_stats()
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	get_tree().paused = true
#	button_stats.grab_focus()
	set_process(true)



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_close_item_menu()


func _close_item_menu() -> void:
	set_process(false)
	get_tree().paused = false
	call_deferred("queue_free")
	
	

func update_stats() -> void:
	print("update")
	var _p : Player = PlayerManager.player
	
	str_label.text = str(_p.str)
	def_label.text = str(_p.def)
	spd_label.text = str(_p.spd)
	hp_label.text = str(_p.max_value)
	sp_label.text = str(_p.sp)
	spi_label.text = str(_p.spi)
	wil_label.text = str(_p.wil)
	
