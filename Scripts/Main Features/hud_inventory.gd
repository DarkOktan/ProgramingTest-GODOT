# Class ini digunakan untuk menampilkan semua data inventory yang dimiliki pemain
# pemisahan class ini dilakukan agar jika ingin membuat HUD Inventory yang lebih variatif
# bisa dilakukan dengan mengextend class ini

class_name HUDInventory
extends Control

# Reference Node yang akan dijadikan Parent
@onready var slotContainer : GridContainer = $HUD_Inventory_BG/HUD_Inventory/Slot_Container

# Reference dari HUD Inventory Slot yang akan dispawn
var slotScene : PackedScene = preload("res://Scene/UserInterface/hud_inventory_slot.tscn")
# Reference dari Inventory System yang ada di Main Scene
var inventorySytem : InventorySystem

# Signal untuk mengupdate HUD Inventory (seperti Slot)
signal UpdateInventoryHUD(slotData : InventorySlot)

# Untuk menyambungkan UpdateInventory Signal dengan UpdateInventoryHUD
# serta memunculkan Inventory Slot HUD
func OnInit() -> void:
	# Spawning Slot Based on Inventory System data
	inventorySytem = InventorySystem.GetInventorySystemInstance
	inventorySytem.UpdateInventory.connect(OnUpdateInventory)
	call_deferred("ShowingHUD")
	pass

# Memunculkan Slot HUD berdasakrna Slot Inventory yang telah dibuat
func ShowingHUD() -> void:
	print("Spawning Slot : " + str(inventorySytem.InventorySlotInstance.size()))
	for i in range(inventorySytem.InventorySlotInstance.size()):
		var slotScene = slotScene.instantiate() as HUDInventorySlot
		slotContainer.add_child(slotScene)
		slotScene.OnInit(self, inventorySytem.InventorySlotInstance[i])


func OnUpdateInventory() -> void:
	print("Update HUD Inventory")
	UpdateInventoryHUD.emit()
