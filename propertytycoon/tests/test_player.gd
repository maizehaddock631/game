extends GutTest

func test_pay():
	var player : Player = Player.new("Milly")
	var property : PropertyTile = PropertyTile.new()
	var bank : Banker = Banker.new()
	var player2 : Player = Player.new("Nelly")
	
	player.pay(200, bank)
	assert_eq(player.balance, 1300, "Player should've lost money")
	assert_eq(bank.balance, 50200, "Bank should've made money")
	player.pay(200, player2)
	assert_eq(player.balance, 1100, "Player should've lost money again" )
	assert_eq(player2.balance, 1700, "Player2 should've gained money")
	assert_eq(bank.balance, 50200, "Bank funds should've satyed the same")

func test_buypropertypass():
	var player : Player = Player.new("Nelly")
	var property : PropertyTile = PropertyTile.new()
	var bank : Banker = Banker.new()
	property.propertycost = 500
	player.has_completed_loop = true
	property.propertyname = "The Old Creek"
	
	player.buy_property(property, bank)
	
	assert_eq(player.balance, 1000, "Not correct deduction")
	assert_eq(bank.balance, 50500, "Not correct addition")
	assert_eq(property.propertyowner, player, "Player should own the property")
	assert(property in player.properties, "Doesn't own this property")
	assert(property not in bank.properties, "Bank should no longer own this property")
	
func test_buypropertyfail():
	var player : Player = Player.new("Jhardelle")
	var property : PropertyTile = PropertyTile.new()
	var bank : Banker = Banker.new()
	property.propertycost = 2000
	property.propertyname = "The Old Creek"
	player.has_completed_loop = false
	bank.properties.append(property)
	
	player.buy_property(property, bank)
	
	assert_eq(player.balance, 1500, "Player shouldn't have spent money")
	assert_eq(bank.balance, 50000, "Bank shouldn't have gained money")
	assert(property not in player.properties, "Player shouldn't own this property")
	assert(property in bank.properties, "Bank should own this property")

func test_sellproperty():
	var player : Player = Player.new("Milly")
	var property : PropertyTile = PropertyTile.new()
	var bank : Banker = Banker.new()
	property.propertycost = 2000
	property.propertyname = "The Old Creek"
	player.properties.append(property)
	property.propertyowner = player
	
	player.sell_property(property, bank)
	
	assert(property in bank.properties, "Bank should own this property")
	assert(property not in player.properties, "Player should not still own this property")
	assert_eq(player.balance, 2500, "Player should've gained money")
	assert_eq(bank.balance, 49000, "Bank should've spent money")
	assert_eq(property.propertyowner, bank, "Property owner should be bank")
	
func test_getoutofjailfreepass():
	var player : Player = Player.new("Bashirah")
	player.injail = true
	player.get_out_of_jail_free = 2
	
	player.use_getoutofjailfree()
	
	assert_eq(player.get_out_of_jail_free, 1, "Player should have one less jail free cards")
	assert_eq(player.injail, false, "Player should no longer be in jail")

func test_getoutofjailfreefail():
	var player : Player = Player.new("Bashirah")
	player.injail = true
	player.get_out_of_jail_free = 0
	
	player.use_getoutofjailfree()
	
	assert_eq(player.get_out_of_jail_free, 0, "Number of jail free cards should be the same")
	assert_eq(player.injail, true, "Player should still be in jail")

func test_declarebankruptcy():
	var player : Player = Player.new("Gabi")
	var bank : Banker = Banker.new()
	player.declare_bankruptcy(bank)
	
	assert_eq(player.is_bankrupt, true, "Player should be bankrupt")
	assert_eq(player.balance, 0, "Player should have no money")
	assert_eq(bank.balance, 51500, "Bank should have players money")

func test_jailfine():
	var player = Player.new("Jhardelle")
	var bank = Banker.new()
	player.injail = true
	
	player.pay_jail_fine(bank)
	
	assert_eq(player.balance, 1450)
	assert_eq(bank.balance, 50050)
	assert_eq(player.injail, false)
	assert_eq(player.jail_turns, 0)
