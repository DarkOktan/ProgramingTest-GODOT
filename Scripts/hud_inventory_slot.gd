# Class ini berfungsi sebagai Display bagi Setiap Inventory Slot
# Fungsi seperti memunculkan gambar item, jumlah item serta fungsi untuk Drag And drop
# atau klik kanan pada item untuk memunculkannya

class_name HUDInventorySlot
extends Control

# Reference dari Texture rect yang akan digunakan untuk menampilkan gambar item
@onready var itemOnSlotTexture: TextureRect = $BG/ItemPicture
# Reference dari Label yang akan digunakna untuk menampilkan jumlah item yang ada
@onready var quantityText: Label = $BG/QuantityPanel/QuantityText

# Reference dari Inventory Slot yang dimunculkan di HUD ini
var SlotAttached : InventorySlot

# Fungsi ini untuk mengecheck apakah ada input mouse klik kanan pada HUD Slot ini
# jika ada maka akan mengspawn Object
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
			OnRightClickAction()

# Fungsi ini dilakukan untuk membuat item didalam slot menjadi world object
# yang bisa didrag and drop kembali kedalam slot
func OnRightClickAction() -> void:
	InventorySystem.GetInventorySystemInstance.OnDroppingItem(SlotAttached.itemdataOnSlot)
	InventorySystem.GetInventorySystemInstance.RemoveFromInventory(1, SlotAttached)

# Untuk setup awal HUD Slot
# Seperti Connect Signal Update Inventory HUD ke Fungsi UpdateSlot serta mengset referensi
# Dari slot yang akan dimunculkan di HUD ini
func OnInit(HUDInventoryInstance: HUDInventory, SlotSet : InventorySlot) -> void:
	print("On Init")
	HUDInventoryInstance.UpdateInventoryHUD.connect(UpdateSlot)
	SlotAttached = SlotSet
	UpdateSlot()
	pass

# Fungsi ini digunakan untuk mengupdate tampilan dari HUD Slot ini
# Seperti tampilan berdasarkan dari inventory Slot yang dimasukkan
func UpdateSlot():
	print("Update Slot")
	if SlotAttached == null || SlotAttached.itemdataOnSlot == null:
		itemOnSlotTexture.visible = false
		quantityText.text = "0"
		return
		
	itemOnSlotTexture.visible = true
	itemOnSlotTexture.texture = SlotAttached.itemdataOnSlot.ItemTexture
	quantityText.text = str(SlotAttached.itemQuantity)

# Untuk Setup mouse filter agar bisa terdeteksi oleh mouse input
func _ready() -> void:
	mouse_filter = MOUSE_FILTER_PASS

# fungsi ini memiliki kegunaan untuk mengsetup ketika awal ingin mengdrag Slot
# seperti mengset preview item yang didrag, serta menghapus Item dari Slot
# Return ItemData
func _get_drag_data(at_position : Vector2) -> ItemData:
	if SlotAttached == null || SlotAttached.IsEmpty():
		return

	var dataDragged = SlotAttached.itemdataOnSlot
	
	print("Get Dragged Data")
	var preview : Control = itemOnSlotTexture.duplicate()
	
	set_drag_preview(preview)
	
	InventorySystem.GetInventorySystemInstance.RemoveFromInventory(1, SlotAttached)
	
	return dataDragged

# Untuk mengset slot HUD_InventorySlot bisa di drop oleh item
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

# Fungsi ini memiliki kegunaan untuk mengset Inventory Slot yang kosong dengan Slot yang sedang didrag (Bukan untuk World Object)
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if (SlotAttached.IsEmpty()):
		print("Drop On Empty Slot")
		InventorySystem.GetInventorySystemInstance.AddToInventory(1, data, SlotAttached)

# Fungsi ini memiliki kegunaan untuk mengatur (menambah) Slot yang di drop oleh World Object Item
func NodeObjectDrop(itemInsertedObject : WorldItemObjects) -> void:
	# Check apakah Item Data On Slot Null atau Tidak
	
	if InventorySystem.GetInventorySystemInstance.CheckIfDifferentItem(SlotAttached, 
	itemInsertedObject.item) && !SlotAttached.IsEmpty():
		return
	
	# Menghapus Object nya dan Menambah object ke inventory
	itemInsertedObject.queue_free()
	
	InventorySystem.GetInventorySystemInstance.AddToInventory(1, itemInsertedObject.item, SlotAttached)

# Fungsi ini untuk mengecheck Slot kosong atau tidak
# jika tidak makan akan memunculkan tooltip
func _on_mouse_entered() -> void:
	if (SlotAttached == null || SlotAttached.IsEmpty()):
		tooltip_text = ""
		return
	
	ShowingTooltip()

# memunculkan tooltip dari Descripsi item yang ter-attach
func ShowingTooltip() -> void:
	tooltip_text = SlotAttached.itemdataOnSlot.ItemDescription
