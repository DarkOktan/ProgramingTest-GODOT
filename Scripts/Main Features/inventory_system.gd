# Class ini digunakan untuk menyimpan dan mengatur data dari Slot yang dimiliki oleh pemain
# Selain itu class ini juga menyimpan Container Item yang ada didalam project ini

class_name InventorySystem
extends Node2D

# Singletons Manual ini dilakukan tanpa AUTOLOAD (Global)
# Agar terpisah (modular) dari project utamanya
# sehingga jika tidak dibutuhkan di scene tertentu tidak perlu menambahkannya
#region Manual Singleton Instance
static var _InventorySystemInstance : InventorySystem = null
static var GetInventorySystemInstance : InventorySystem :
	get:
		if (_InventorySystemInstance == null):
			printerr("NO INVENTORY SYSTEM")
			return null
		return _InventorySystemInstance
#endregion

# Item Data Container
# Jika ingin menambahkan perlu membuat Resources ItemData
# Dan memasukkanya kedalam Container
@export var inventory_data : ItemDataContainer

# Jumlah Slot yang tersedia atau dimiliki oleh player
@export var inventory_slot_count : int

# Class HUD yang digunakan untuk menampilkan inventory
@export var currentHUDInventory : HUDInventory

# Container Runtime untuk setiap slot yang ada didalam game
var InventorySlotInstance : Array[InventorySlot]

# Event yang digunakan untuk memberi tahu bahwa terdapat pengaturan
# yang dilakukan kepada Inventory Slot
signal UpdateInventory

# Berfungsi untuk menset Singletons dari Class ini
func _init() -> void:
	_InventorySystemInstance = self

# Berfungsi untuk Membuat Slot default dan memunculkannya kedalam HUD
func _ready() -> void:
	SettingUpInventory()
	
	currentHUDInventory.OnInit()

# Fungsi ini digunakan untuk mengatur default slot saat runtime
func SettingUpInventory():
	for i in inventory_slot_count:
		var slot = InventorySlot.new(i + 1)
		InventorySlotInstance.append(slot)

# Fungsi ini digunakan untuk mengcheck parameter slot
# yang dimasukkan sama dengan yang ada di slot atau tidak
# Return True jika tidak sama
# Return False jika sama
func CheckIfDifferentItem(slot : InventorySlot, data : ItemData) -> bool:
	if slot.itemdataOnSlot != data:
		return true
	return false

# Fungsi ini digunakan untuk menambahkan item kedalam slot yang telah dipilih dengan jumlah tertentu
# Lalu memanggil Signal UpdateInventory untuk memberi tahu ke class lain bahwa
# Inventory Telah di update
# Fungsi ini dipanggil saat mendrop dari Word Object
# Return True jika Menambahkan ke slot dengan item yang sama
# return False Jika Menambahkan ke slot dengan item yang kosong
func AddToInventory(quantity : int, data : ItemData, slot : InventorySlot) -> bool:
	if slot.itemdataOnSlot == null:
		slot.itemdataOnSlot = data
		slot.itemQuantity = quantity;
		
		UpdateInventory.emit()
		return false
	
	slot.itemQuantity += quantity
		
	UpdateInventory.emit()
	return true

# Fungsi ini diguankan untuk menambahkan item kedalam slot yang kosong (urut dari atas)
# Atau jika slot memiliki tipe item yang sama
# Lalu memanggil Signal UpdateInventory untuk memberi tahu ke class lain bahwa
# Inventory Telah di update
# Fungsi ini dipanggil ketika mengclick tombol di Debug Panel
# Return True jika berhasil menambahkan
# Return False Jika tidak berhasil
func AddToSlotFromPanel(data : ItemData) -> bool:
	for i in range(InventorySlotInstance.size()):
		if InventorySlotInstance[i].itemdataOnSlot == null || !CheckIfDifferentItem(InventorySlotInstance[i], data):
			InventorySlotInstance[i].itemdataOnSlot = data
			InventorySlotInstance[i].itemQuantity += 1
			UpdateInventory.emit()
			return true
	
	return false

# Fungsi ini untuk mengurangi item yang ada didalam Slot dengan jumlah tertentu
# Return false jika habis
# Return True jika masih ada
func RemoveFromInventory(quantity : int, slot : InventorySlot) -> bool:
	slot.itemQuantity -= quantity
	
	if slot.itemQuantity <= 0:
		slot.itemdataOnSlot = null
		UpdateInventory.emit()
		return false
	
	UpdateInventory.emit()
	return true

# Fungsi ini digunakan untuk membuat World Object Scene ke posisi
# drop di world point
# posisi ini sesuai dengan posisi mouse ketika melepaskannya
func OnDroppingItem(data: Variant) -> void:
	print("Dropping Slot Item")
	var WorldSceneObject : PackedScene = preload("res://Scene/World Object/2DWorldItemObject.tscn")
	
	# Spawning 2D World Object based on data
	var spawnedWorldScene = WorldSceneObject.instantiate() as WorldItemObjects
	spawnedWorldScene.call_deferred("OnInit", data)
	
	var mousePos = get_viewport().get_camera_2d().get_global_mouse_position()
	spawnedWorldScene.global_position = mousePos
	
	get_tree().current_scene.add_child(spawnedWorldScene)
