# Script ini dipakai untuk mengatur Item yang tersedia di debug panel item
class_name DebugPanelItem
extends Panel

@onready var button: Button = $Button
@onready var texture_rect: TextureRect = $TextureRect

var item : ItemData

# Fungsi ini digunakan untuk mengatur Item yang tersambung dengan Debug Panel Item ini
func OnInit(i : ItemData) -> void:
	item = i
	call_deferred("OnSetupDisplay")

# Fungsi ini digunakan untuk mengatur Display berdasarkan dengan item yang telah di masukkan
func OnSetupDisplay():
	texture_rect.texture = item.ItemTexture

# Fungsi ini berfungsi untuk mengspawn item kedalam Slot yang kosong didalam Inventory Container
func _on_button_button_down() -> void:
	var isSuccess : bool = InventorySystem.GetInventorySystemInstance.AddToSlotFromPanel(item)
	if isSuccess:
		print("Spawning Success")
	else:
		print("Spawning Failed")
