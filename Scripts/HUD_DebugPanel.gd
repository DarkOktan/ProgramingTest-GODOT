# class ini digunakan untuk mengatur HUD Debug Panel
# Seperti membuat Object item yang bisa di clik untuk menambahkan Item baru di slot
# , Mengatur Item Object yang muncul sesuai dengan Item yang telah di set di dalam ItemContainer

extends Panel

# Reference dari Grid Container yang akan dijadikan Parent
@onready var container : GridContainer = $ScrollContainer/GridContainer

# Reference dari Object Item Scene
var DebugPanelItemScene : PackedScene = preload("res://Scene/UserInterface/HUD_DebugPanelItem.tscn")

# Untuk Mengsetup Debug Panel Agar menghilang ketika awal memulai gamenya
func _ready() -> void:
	visible = false

# Fungsi yang dijalankan ketika Open Debug Panel button diclick
# Fungsi ini berfungsi untuk mematikan tombol Open Debug Panel, Mengatifkan Debug Panel
# , akan mereset object yang sudah ada sebelumnya dan menampilkan yang baru
func OnMouseButtonDown_OpenPanel() -> void:
	print("Opening Debug Panel")
	
	$"../Button".visible = false
	visible = true
	ResetDisplay()
	OnDisplayAll()

# Fungsi yang dijalankan ketika Close Debug Panel button diclick
# Fungsi ini berfungsi untuk menghidupkan kembali Open Debug Panel Button dan mematikan Debug Panel
func OnMouseButtonDown_ClosePanel() -> void:
	print("Closing Debug Panel")
	
	$"../Button".visible = true
	visible = false

# Fungsi ini digunakan untuk mereset Item yang ada didalam Container dengan cara menghapusnya
func ResetDisplay() -> void:
	for i in range(container.get_child_count() - 1, -1, -1):
		var child = container.get_child(i)
		child.queue_free()

# fungsi ini digunakan untuk memunculkan Item yang ada didalam ItemContainer kedalam Debug Panel
func OnDisplayAll() -> void:
	var inventorySytem : InventorySystem = InventorySystem.GetInventorySystemInstance
	for i in range(inventorySytem.inventory_data.ItemOnContainer.size()):
		var panelItem = DebugPanelItemScene.instantiate() as DebugPanelItem
		
		container.add_child(panelItem)
		panelItem.OnInit(inventorySytem.inventory_data.ItemOnContainer[i])
