extends Node

func _ready():
	passtest_buyproperty()
	failtest_buyproperty()

func passtest_buyproperty():
	var property = PropertyTile.new()
	var player = Player.new()
	var bank = Banker.new()
	
	property.propertycost = 500
	player.has_completed_loop = true
	
	player.buy_property(property, bank)
	
	assert(player.balance == 1000, "Not correct deduction")
	assert(bank.balance == 50500, "Not correct addition")
	assert(property.propertyowner == player, "Player should own the property")
	assert(property in player.properties, "Doesn't own this property")
	assert(property not in bank.properties)
	
func failtest_buyproperty():
	var property = PropertyTile.new()
	var player = Player.new()
	var bank = Banker.new()
	
	property.propertycost = 2000
	player.has_completed_loop = false
	bank.properties.append(property)
	
	player.buy_property(property, bank)
	
	assert(player.balance == 1500, "Player shouldn't have spent money")
	assert(bank.balance == 50000, "Bank shouldn't have gained money")
	assert(property not in player.properties, "Player shouldn't own this property")
	assert(property in bank.properties, "Bank should own this property")

func test_sellproperty():
	var property = PropertyTile.new()
	var player = Player.new()
	var bank = Banker.new()
	
	property.propertycost = 2000
	player.properties.append(property)
	property.propertyowner = player
	
	player.sell_property(property, bank)
	
	assert(property in bank.properties, "Bank should own this property")
	assert(property not in player.properties, "Player should not still own this property")
	assert(player.balance == 2500, "Player should've gained money")
	assert(bank.balance == 49000, "Bank should've spent money")
	assert(property.propertyowner == bank, "Property owner should be bank")
	
	
	
