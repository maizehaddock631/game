class_name AI extends Player

##This function is to calculate the chance of the AI buying the property. 
##The more properties the AI owns, the more likely it will buy the property it lands on.
##@Return base chance + the bonus chance
func get_ai_property_build_chance() -> float:
	var base_chance = 0.5 #At first will be 50% chance
	var property_count = self.properties.size()
	var bonus = min(property_count * 0.05, 0.4) #The chance will increase by 5% each property it owns, it will cap at 90%
	return base_chance + bonus
