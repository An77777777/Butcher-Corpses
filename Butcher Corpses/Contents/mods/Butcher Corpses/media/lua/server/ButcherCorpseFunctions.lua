ButcherCorpsesUtil = {};

ButcherCorpsesUtil.onCreate_getFreshResult = function (items, result, player)
    result:setAge(0);
end

ButcherCorpsesUtil.OnEat_CorpseFlesh = function (food, player, percent)
    local effectOnEat = SandboxVars.ButCor.EffectOnEat or 3
    ButcherCorpsesUtil.OnEat_CorpseFlesh_Effect(effectOnEat, percent * food:getActualWeight(), player)
end
 
ButcherCorpsesUtil.OnEat_CookedCorpseFlesh = function (food, player, percent)
    local effectOnEatCooked = SandboxVars.ButCor.EffectOnEatCooked or 1
    ButcherCorpsesUtil.OnEat_CorpseFlesh_Effect(effectOnEatCooked, percent * food:getActualWeight(), player)
end

-- setting 1 = no effect | 2 = food sick | 3 = infection | 4 = both
ButcherCorpsesUtil.OnEat_CorpseFlesh_Effect = function (setting, amount, player)
    local bodyDamage = player:getBodyDamage();

    if setting == 2 or setting == 4 then
        -- add sickness level based on amount eaten. Eating one full flesh will result in +100% sickness.
		local sickness = bodyDamage:getFoodSicknessLevel() + amount * 100
		bodyDamage:setFoodSicknessLevel(sickness);
    end

    if setting == 3 or setting == 4 then
		bodyDamage:setInfected(true);
    end
 end
