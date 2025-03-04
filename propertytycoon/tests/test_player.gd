extends GutTest

var player
var property
var bank

func _before_each():
	print("Setting up before all tests")
	player = Player.new()
	property = Property.new()
	bank = Banker.new()
	
func test_buypropertypass():
	
	property.propertycost = 500
	player.has_completed_loop = true
	property.propertyname = "The Old Creek"
	
	player.buy_property(property, bank)
	
	assert(player.balance == 1000, "Not correct deduction")
	assert(bank.balance == 50500, "Not correct addition")
	assert(property.propertyowner == player, "Player should own the property")
	assert(property in player.properties, "Doesn't own this property")
	assert(property not in bank.properties)
	
func test_buypropertyfail():
	
	property.propertycost = 2000
	property.propertyname = "The Old Creek"
	player.has_completed_loop = false
	bank.properties.append(property)
	
	player.buy_property(property, bank)
	
	assert(player.balance == 1500, "Player shouldn't have spent money")
	assert(bank.balance == 50000, "Bank shouldn't have gained money")
	assert(property not in player.properties, "Player shouldn't own this property")
	assert(property in bank.properties, "Bank should own this property")

func test_sellproperty():
	
	property.propertycost = 2000
	property.propertyname = "The Old Creek"
	player.properties.append(property)
	property.propertyowner = player
	
	player.sell_property(property, bank)
	
	assert(property in bank.properties, "Bank should own this property")
	assert(property not in player.properties, "Player should not still own this property")
	assert(player.balance == 2500, "Player should've gained money")
	assert(bank.balance == 49000, "Bank should've spent money")
	assert(property.propertyowner == bank, "Property owner should be bank")
	
func test_getoutofjailfreepass():
	player.injail = true
	player.get_out_of_jail_free = 2
	
	player.use_getoutofjailfree()
	
	assert(player.get_out_of_jail_free == 1, "Player should have one less jail free cards")
	assert(player.injail == false, "Player should no longer be in jail")

func test_getoutofjailfreefail():
	player.injail = true
	player.get_out_of_jail_free = 0
	
	player.use_getoutofjailfree()
	
	assert(player.get_out_of_jail_free == 0, "Number of jail free cards should be the same")
	assert(player.injail == true, "Player should still be in jail")

func test_declarebankruptcy():
	player.declare_bankruptcy()
	
	assert(player.is_bankrupt == true, "Player should be bankrupt")
	assert(player.balance == 0, "Player should have no money")
	assert(bank == 51000, "Bank should have players money")
	
