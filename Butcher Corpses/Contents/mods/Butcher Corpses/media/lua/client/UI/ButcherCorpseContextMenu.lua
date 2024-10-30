ButcherCorpses = {};

ButcherCorpses.Recipe = getScriptManager():getRecipe("ButCor.ButCor Butcher Corpse")
ButcherCorpses.RecipeTools = {}
for i=0, ButcherCorpses.Recipe:getSource():size()-1 do
	local source = ButcherCorpses.Recipe:getSource():get(i);
	if source:isKeep() then
		ButcherCorpses.RecipeTools = source:getItems()
		break
	end
end

local function hasButcherTool(player)
    local inventory = getSpecificPlayer(player):getInventory()
	for i=0, ButcherCorpses.RecipeTools:size()-1 do
		local recipeTool = ButcherCorpses.RecipeTools:get(i)
        if inventory:containsTypeRecurse(recipeTool) then
            return true
        end
    end
    return false
end

local function isButcherTool(item)
	if item then
    	for i=0, ButcherCorpses.RecipeTools:size()-1 do
			local recipeTool = ButcherCorpses.RecipeTools:get(i)
    	     if recipeTool and not item:isBroken() and item:getFullType() == recipeTool then
			 	return true
			 end
    	end
	end
	return false
end

ButcherCorpses.getButcherTool = function(player)
	local playerInv = player:getInventory();
	-- first check if we have a valid tool equipped
	local handItem = player:getPrimaryHandItem()
	if handItem and isButcherTool(handItem) then
		return handItem
	end
	-- if not, check if there's a valid tool in inventory
	return playerInv:getFirstEvalRecurse(isButcherTool)
end

ButcherCorpses.onButcherCorpse = function(worldobjects, WItem, player)
	local playerObj = getSpecificPlayer(player)
	-- walk to corpse
	if WItem:getSquare() and luautils.walkAdj(playerObj, WItem:getSquare()) then
		-- equip item and start action
		local butcherItem = ButcherCorpses.getButcherTool(playerObj)
		if butcherItem then
			butcherItem = ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), butcherItem, true)
			ISTimedActionQueue.add(ButcherCorpseAction:new(playerObj, WItem,butcherItem, ButcherCorpses.Recipe:getTimeToMake()));			
		else
			print("No valid tool found! Likely broken...")
		end
	end
end

ButcherCorpses.onButcherMenu = function(player, context, worldobjects)
	if body and hasButcherTool(player) then
		context:addOption(getText("ContextMenu_ButCor_Butcher_Corpse"), worldobjects, ButcherCorpses.onButcherCorpse, body, player);
	end
end

Events.OnFillWorldObjectContextMenu.Add(ButcherCorpses.onButcherMenu);
