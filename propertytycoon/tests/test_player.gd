extends GutTest

func test_pay():
	var player = Player.new()
	var property = Property.new()
	var bank : Banker = Banker.new()
	var player2 : Player = Player.new()
	
	player.pay(200, bank)
	assert_eq(player.balance, 1300, "Player should've lost money")
	assert_eq(bank.balance, 50200, "Bank should've made money")
	player.pay(200, player2)
	assert_eq(player.balance, 1100, "Player should've lost money again" )
	assert_eq(player2.balance, 1700, "Player2 should've gained money")
	assert_eq(bank.balance, 50200, "Bank funds should've satyed the same")

func test_buypropertypass():
	var player : Player = Player.new()
	var property = Property.new()
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
	var player : Player = Player.new()
	var property = Property.new()
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
	var player : Player = Player.new()
	var property = Property.new()
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
	var player : Player = Player.new()
	player.injail = true
	player.get_out_of_jail_free = 2
	
	player.use_getoutofjailfree()
	
	assert_eq(player.get_out_of_jail_free, 1, "Player should have one less jail free cards")
	assert_eq(player.injail, false, "Player should no longer be in jail")

func test_getoutofjailfreefail():
	var player : Player = Player.new()
	player.injail = true
	player.get_out_of_jail_free = 0
	
	player.use_getoutofjailfree()
	
	assert_eq(player.get_out_of_jail_free, 0, "Number of jail free cards should be the same")
	assert_eq(player.injail, true, "Player should still be in jail")

func test_declarebankruptcy():
	var player : Player = Player.new()
	var bank : Banker = Banker.new()
	player.declare_bankruptcy(bank)
	
	assert_eq(player.is_bankrupt, true, "Player should be bankrupt")
	assert_eq(player.balance, 0, "Player should have no money")
	assert_eq(bank.balance, 51500, "Bank should have players money")

func test_jailfine():
	var player = Player.new()
	var bank = Banker.new()
	player.injail = true
	
	player.pay_jail_fine(bank)
	
	assert_eq(player.balance, 1450)
	assert_eq(bank.balance, 50050)
	assert_eq(player.injail, false)
	assert_eq(player.jail_turns, 0)
	
func test_stayinjail():
	var player = Player.new()
	player.jail_turns = 2
	player.injail = true
	player.stay_in_jail()
	assert_eq(player.jail_turns, 1, "Player should have one less round in jail")
	##implement test to make sure position is correct

func test_tradeassets():
	var player = Player.new()
	var player2 = Player.new()
	player.playerName = "Nelly"
	player2.playerName = "Gabi"
	var property1 = Property.new()
	var property2 = Property.new()
	property2.propertyname = "property2"
	var property3 = Property.new()
	property3.propertyname = "property3"
	
	player.properties = [property1]
	player2.properties = [property2, property3]
	
	player.trade_assets(player2)
	
	assert_eq(player.properties.size(), 2, "The amount of properties player one has should be the same as what player 2 had")
	assert_eq(player2.properties.size(), 1, "The amount of properties player two has should be the same as what player 1 had")
	assert(player.properties.has(property2))
	assert(player.properties.has(property3))

##implement test move method

func test_mortgageproperty():
	var bank = Banker.new()
	var player = Player.new()
	var property = Property.new()
	var property2 = Property.new()
	var property3 = Property.new()
	player.properties = [property, property2]
	player.playerName = "Gabi"
	property.propertycost = 400
	property.propertyname = "The Old Creek"
	property.propertyowner = player
	bank.properties = [property3]
	
	player.mortgage_property(property, bank)
	
	assert(player.properties == [property2], "The player should now own one less property")
	assert_eq(player.balance, 1700, "Player should've gained some money")
	assert_eq(property.propertyowner, bank, "the bank should now own the property")
	assert_eq(bank.balance,49800, "the bank should've lost some money")
	assert(bank.properties == [property3, property])

func test_unmortgageproperty():
	var bank = Banker.new()
	var player = Player.new()
	var property = Property.new()
	var property2 = Property.new()
	var property3 = Property.new()
	player.properties = [property]
	player.playerName = "Bashirah"
	property2.propertycost = 400
	property2.propertyname = "The Old Creek"
	property2.propertyowner = bank
	bank.properties = [property3, property2]
	
	player.unmortgage_property(property2, bank)
	
	assert(player.properties == [property, property2], "The player should now own two properties")
	assert_eq(player.balance, 1280, "Player should've lost some money")
	assert_eq(property2.propertyowner, player, "player should now own the property")
	assert_eq(bank.balance,50220, "the bank should've gained some money")
	assert(bank.properties == [property3], "bank should now own one property")

	
