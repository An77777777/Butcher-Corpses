ButcherCorpses = {};

ButcherCorpses.Recipe = getScriptManager():getRecipe("ButCor.ButCor Butcher Corpse")

local function getRecipeTools()
    for _,source in ipairs(ButcherCorpses.Recipe:getSource()) do
		if source:isKeep() then
			return source:getItems()
		end
	end
	return {"Machete", "MeatCleaver", "HandAxe", "Axe", "WoodAxe", "[Recipe.GetItemTypes.SharpKnife]","[Recipe.GetItemTypes.Saw]"}
end

local function hasRequiredWeapon(player)
    local inventory = getSpecificPlayer(player):getInventory()
    for _, weapon in ipairs(getRecipeTools()) do
        if inventory:contains(weapon) then
            return true
        end
    end
    return false
end

local function isButcherItem(item)
    for _, weapon in ipairs(getRecipeTools()) do
        if not item:isBroken() and item:getType() == weapon then
			return true
		end
    end
	return false
end

ButcherCorpses.getButcherItem = function(player)
	local playerInv = player:getInventory();
	-- first check if we have a valid tool equipped
	local handItem = player:getPrimaryHandItem()
	if handItem and isButcherItem(handItem) then
		return handItem
	end
	-- if not, check if there's a valid tool in inventory
	return playerInv:getFirstEvalRecurse(isButcherItem)
end

local oldCreateMenu = ISWorldObjectContextMenu.createMenu
ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)
    -- call the original createMenu function
    local context = oldCreateMenu(player, worldobjects, x, y, test)

	-- add butcher option requirements met
	if hasRequiredWeapon(player) then
    	local body = IsoObjectPicker.Instance:PickCorpse(x, y)
    	if body then
			context:addOption(getText("ContextMenu_ButCor_Butcher_Corpse"), worldobjects, ButcherCorpses.onButcherCorpse, body, player);
    	end
	end
	return context
end

ButcherCorpses.onButcherCorpse = function(worldobjects, WItem, player)
	local playerObj = getSpecificPlayer(player)
	-- walk to corpse
	if WItem:getSquare() and luautils.walkAdj(playerObj, WItem:getSquare()) then
		-- equip item and start action
		local butcherItem = ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), ButcherCorpses.getButcherItem(playerObj), true);
		ISTimedActionQueue.add(ButcherCorpseAction:new(playerObj, WItem,butcherItem, ButcherCorpses.Recipe:getTimeToMake()));
	end
end

