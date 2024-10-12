function onCreate_getFreshResult(items, result, player)
  result:setAge(0);
end

function OnEat_CorpseFlesh(food, player)
  local bodyDamage = player:getBodyDamage();
  bodyDamage:setFoodSicknessLevel(100);
  bodyDamage:setInfected(true);
 end

 
 function OnEat_CookedCorpseFlesh(food, player)
  local bodyDamage = player:getBodyDamage();
  bodyDamage:setFoodSicknessLevel(100);
 end