function onCreate_getFreshResult(items, result, player)
  result:setAge(0);
end

function OnEat_CorpseFlesh(food, player)
  local bodyDamage = player:getBodyDamage();
  bodyDamage:setInfected(true);
 end