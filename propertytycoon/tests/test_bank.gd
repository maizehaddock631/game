extends GutTest

func test_pay():
	var player = Player.new()
	var bank = Banker.new()
	bank.pay(200, player)
	assert_eq(player.balance, 1700)
	assert_eq(bank.balance, 49800)
	
func test_sellproperty():
	var player = Player.new()
	var bank = Banker.new()
	var property = Property.new()
	property.propertycost = 200
	bank.properties.append(property)
	bank.sell_property(player, property)
	assert_eq(bank.properties.size(), 0)
	assert_eq(bank.balance, 50200)
	assert_eq(player.properties.size(), 1)
	assert_eq(player.balance, 1300)
