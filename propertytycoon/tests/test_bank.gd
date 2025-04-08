extends GutTest

func test_ready():
	var bank = Banker.new()
	bank._ready()
	assert_ne(bank.properties.size(), 0, "The bank should automatically own all property tiles")
	
