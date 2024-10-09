require "TimedActions/ISBaseTimedAction"

ButcherCorpseAction = ISBaseTimedAction:derive("ButcherCorpseAction");
ButcherCorpseAction.soundDelay = 1

function ButcherCorpseAction:isValid()
    if self.corpseBody:getStaticMovingObjectIndex() < 0 then
        return false
    end
    return true
end

function ButcherCorpseAction:waitToStart()
    self.character:faceThisObject(self.corpseBody)
    return self.character:shouldBeTurning()
end

function ButcherCorpseAction:update()
    if self.soundTime + ButcherCorpseAction.soundDelay < getTimestamp() then
        self.soundTime = getTimestamp()
        self.sound = self.character:getEmitter():playSound("SliceMeat")
        addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), 10, 10)
    end

    self.corpse:setJobDelta(self:getJobDelta());
    self.character:faceThisObject(self.corpseBody);

    self.character:setMetabolicTarget(Metabolics.LightWork);
end

function ButcherCorpseAction:start()
    self.corpse:setJobType(getText("ContextMenu_Recipe_ButCor_Butcher_Corpse"));
    self.corpse:setJobDelta(0.0);
    self:setActionAnim("Loot");
    self.character:SetVariable("LootPosition", "Low");

    self.character:reportEvent("EventLootItem");
end

function ButcherCorpseAction:stop()
    if self.sound and self.sound ~= 0 and self.character:getEmitter():isPlaying(self.sound) then
        self.character:getEmitter():stopSound(self.sound);
    end

    ISBaseTimedAction.stop(self);
    self.corpse:setJobDelta(0.0);
end

function ButcherCorpseAction:perform()
    --forceDropHeavyItems(self.character)
    self.corpse:setJobDelta(0.0);
    self.character:getInventory():setDrawDirty(true);
    
    local recipe = getScriptManager():getRecipe("ButCor.ButCor Butcher Corpse")
    local result = recipe:getResult()

    for i=1, result:getCount() do
      self.character:getInventory():AddItem(result:getFullType());
    end

    self.corpseBody:getSquare():removeCorpse(self.corpseBody, false);

    local pdata = getPlayerData(self.character:getPlayerNum());
    if pdata ~= nil then
        pdata.playerInventory:refreshBackpacks();
        pdata.lootInventory:refreshBackpacks();
    end

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function ButcherCorpseAction:new(character, corpse, butcherItem, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.corpse = corpse:getItem();
    o.corpseBody = corpse;
    o.butcherItem = butcherItem;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    o.forceProgressBar = true;
    o.soundTime = 0

    --if character:isTimedActionInstant() then
    --    o.maxTime = 1;
    --end
    return o
end
