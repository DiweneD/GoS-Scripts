if GetObjectName(myHero) ~= "Malzahar" then return end

require "Inspired"

local ver = "0.05"

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat("New version found! " .. data)
        PrintChat("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/Asserio/GoS-Scripts/master/EvolvedMalzahar.lua", SCRIPT_PATH .. "EvolvedMalzahar.lua", function() PrintChat("Downloading, F6 2 times when minions spawn") return end)
    else
        PrintChat("No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/Asserio/GoS-Scripts/master/EvolvedMalzahar.version", AutoUpdate)
-- Menu
Malzahar = Menu("Malzahar", "Malzahar")
-- Malzahar Combo Menu
Malzahar:SubMenu("Combo", "Combo")
Malzahar.Combo:Boolean("Q", "Use Q", true)
Malzahar.Combo:Boolean("W", "Use W", true)
Malzahar.Combo:Boolean("E", "Use E", true)
Malzahar.Combo:Boolean("R", "Use R", true)
Malzahar.Combo:Boolean("KO", "Only Combo if Kileable", false)
-- Harass Menu
Malzahar:SubMenu("Harass", "Harass")
Malzahar.Harass:SubMenu("HMode","Mode")
Malzahar.Harass.HMode:Boolean("QandE","Q and E",true)
Malzahar.Harass.HMode:Boolean("E", "Use E", false)
-- Drawings Menu
Malzahar:SubMenu("Drawings", "Drawings")
-- Damage Draw
Malzahar.Drawings:SubMenu("DrawDmg", "Damage Draw")
Malzahar.Drawings.DrawDmg:Boolean("Q", "Draw Q Dmg", true)
Malzahar.Drawings.DrawDmg:Boolean("W", "Draw W Dmg", true)
Malzahar.Drawings.DrawDmg:Boolean("E", "Draw E Dmg", true)
Malzahar.Drawings.DrawDmg:Boolean("R", "Draw R Dmg", true)
-- Range Draw
Malzahar.Drawings:SubMenu("RangeDraw", "Range Drawings")
Malzahar.Drawings.RangeDraw:Boolean("Q","Draw Q", true)
Malzahar.Drawings.RangeDraw:Boolean("W","Draw W", true)
Malzahar.Drawings.RangeDraw:Boolean("E","Draw E", true)
Malzahar.Drawings.RangeDraw:Boolean("R","Draw R", true)
-- Misc
Malzahar:SubMenu("Misc", "Misc")
Malzahar.Misc:Boolean("MControl", "Mana Control", false)
-- Killsteal
Malzahar:SubMenu("KS", "Killsteal")
Malzahar.KS:Boolean("Q", "Use Q", true)
Malzahar.KS:Boolean("E", "Use E", true)
-- PrintChat
local info = "Evolved Malzahar Loaded"
local upv = "Hope you like it"
local sig = "Have a good game"
local rChan = false
local qcost = GetCastMana(myHero, _Q, GetCastLevel(myHero, _Q))
local wcost = GetCastMana(myHero, _W, GetCastLevel(myHero, _W))
local ecost = GetCastMana(myHero, _E, GetCastLevel(myHero, _E))
local rcost = GetCastMana(myHero, _R, GetCastLevel(myHero, _R))
textTable = {info,upv,sig}
PrintChat(textTable[1])
PrintChat(textTable[2])
PrintChat(textTable[3])

OnTick (function()
if rChan == true then return end
	Killsteal()
	if IOW:Mode() == "Combo" then
		Combo()
	end
	if IOW:Mode() == "Harass" then
		if Malzahar.Harass.HMode.QandE:Value() then
			QE()
		else
			E()
		end
	end
end)

OnUpdateBuff (function(unit, buff)
	if not unit or not buff then
		return
	end
	if buff.Name == "AlZaharNetherGrasp" then
		print("R Casting spells and movements blocked!")
		IOW.movementEnabled = false
		IOW.attacksEnabled = false
		BlockF7OrbWalk(true)
		BlockF7Dodge(true)
      	rChan = true
    end
end)

OnRemoveBuff (function(unit, buff)
	if not unit or not buff then
		return
	end
	if buff.Name == "AlZaharNetherGrasp" then
		print("R Casting spells and movements unblocked!")
		IOW.movementEnabled = true
		IOW.attacksEnabled = true
		BlockF7OrbWalk(false)
		BlockF7Dodge(false)
      	rChan = false
    end
end)

function Combo()
	local unit = GetCurrentTarget()
	local dmg = 0
	if CanUseSpell(myHero, _Q) == READY then
	 dmg = dmg + CalcDamage(myHero, unit, 0, (55*GetCastLevel(myHero,_Q)+25+0.8*GetBonusAP(myHero)))
	end
	if CanUseSpell(myHero, _W) == READY then
	 dmg = dmg + CalcDamage(myHero, unit, 0, (3+1*GetCastLevel(myHero, _W)+0.1*GetBonusAP(myHero)*GetMaxHP(unit)/100))
	end
	if CanUseSpell(myHero, _E) == READY then
	 dmg = dmg + CalcDamage(myHero, unit, 0, (60*GetCastLevel(myHero,_E)+20+.8*GetBonusAP(myHero)))
	end
	if CanUseSpell(myHero, _R) == READY then
	 dmg = dmg + CalcDamage(myHero, unit, 0, (150*GetCastLevel(myHero, _R)+100+1.3*GetBonusAP(myHero)))
	end
	if Malzahar.Misc.MControl:Value() and GetCurrentMana(myHero) >= qcost + wcost + ecost + rcost or Malzahar.Misc.MControl:Value() == false then
		if Malzahar.Combo.KO:Value() and dmg > GetCurrentHP(unit) or Malzahar.Combo.KO:Value() == false then
			if Malzahar.Combo.E:Value() then
				if CanUseSpell(myHero, _E) == READY and ValidTarget(unit, GetCastRange(myHero,_E)) then
						CastTargetSpell(unit, _E)
				end
			end
			if CanUseSpell(myHero, _Q) == READY and Malzahar.Combo.Q:Value() then
-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)-- GetPredictionForPlayer(startPosition, targetUnit, targetUnitMoveSpeed, spellTravelSpeed, spellDelay, spellRange, spellWidth, collision, addHitBox)
				local QPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),math.huge,1000,GetCastRange(myHero, _Q),85,false,true)
				if ValidTarget(unit, GetCastRange(myHero,_Q)) and QPred.HitChance == 1 then
					CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
				end
			end
			if CanUseSpell(myHero, _W) == READY and Malzahar.Combo.W:Value() then
				local WPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),math.huge,1000,GetCastRange(myHero, _W),250,false,true)
				if ValidTarget(unit, GetCastRange(myHero,_W)) and WPred.HitChance == 1 then
					CastSkillShot(_W,WPred.PredPos.x,WPred.PredPos.y,WPred.PredPos.z)
				end
			end
			if Malzahar.Combo.R:Value() then
				if GetCastRange(myHero, _R) and CanUseSpell(myHero, _Q) ~= READY and CanUseSpell(myHero, _W) ~= READY and CanUseSpell(myHero, _E) ~= READY and CanUseSpell(myHero, _R) ~= ONCOOLDOWN and ValidTarget(unit, GetCastRange(myHero,_R)) then
					CastTargetSpell(unit, _R)
				end
			end

		elseif Malzahar.Combo.KO:Value() ~= false then
			if Malzahar.Combo.E:Value() then
				if CanUseSpell(myHero, _E) == READY and ValidTarget(unit, GetCastRange(myHero,_E)) then
					CastTargetSpell(unit, _E)
				end
			end
			if CanUseSpell(myHero, _Q) == READY and Malzahar.Combo.Q:Value() then
				local QPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),math.huge,1000,GetCastRange(myHero, _Q),85,false,true)
				if ValidTarget(unit, GetCastRange(myHero,_Q)) and QPred.HitChance == 1 then
					CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
				end
			end
		end
	end
	if Ignite then
		if CanUseSpell(myHero, Ignite) and 50 + (20  * GetLevel(myHero)) > GetCurrentHP(unit) then
			CastTargetSpell(unit, Ignite)
		end
	end
end

function QE()
if Malzahar.Harass.HMode.QandE:Value() then
	local unit = GetCurrentTarget()
	if Ready(_E) and ValidTarget(unit, GetCastRange(myHero, _E)) and not rChan then
		CastTargetSpell(unit, _E)
	end
	if Ready(_Q) and ValidTarget(unit, GetCastRange(myHero, _Q)) and not rChan then
		local QPred = GetPredictionForPlayer(myHeroPos(),unit,GetMoveSpeed(unit),math.huge,1000,GetCastRange(myHero, _Q),85,false,true)
		if QPred.HitChance == 1 then
			CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
		end
	end
end
end

function E()
if Malzahar.Harass.HMode.E:Value() then
	local unit = GetCurrentTarget()
	if Ready(_E) and ValidTarget(unit, GetCastRange(myHero, _E)) and not rChan then
		CastTargetSpell(unit, _E)
	end
end
end

function Killsteal()
    for i,enemy in pairs(GetEnemyHeroes()) do
		local QPred = GetPredictionForPlayer(myHeroPos(),enemy,GetMoveSpeed(enemy),math.huge,1000,GetCastRange(myHero, _Q),85,false,true)
		local ExtraDmg = 0
		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
			ExtraDmg = ExtraDmg + 0.1*GetBonusAP(myHero) + 100
		end
		if Ready(_Q) and not rChan and ValidTarget(enemy,GetCastRange(myHero,_Q)) and Malzahar.KS.Q:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 55*GetCastLevel(myHero,_Q)+25+0.8*GetBonusAP(myHero) + ExtraDmg) then
			if QPred.HitChance == 1 then
				CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
			end
		end
		if Ready(_E) and not rChan and ValidTarget(enemy,GetCastRange(myHero,_E)) and Malzahar.KS.E:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 60*GetCastLevel(myHero,_E)+20+.8*GetBonusAP(myHero) + ExtraDmg) then
			CastTargetSpell(enemy, _E)
		end
	end
end

OnDraw(function()
	local unit = GetCurrentTarget()
	if Ready(_Q) and Malzahar.Drawings.RangeDraw.Q:Value() then
		DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_Q),3,100,0xFFFF7F7F)
	end
	if CanUseSpell(myHero, _W) == READY and Malzahar.Drawings.RangeDraw.W:Value() then
		DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_W),3,100,0xFF00FF00)
	end
	if Ready(_E) and Malzahar.Drawings.RangeDraw.E:Value() then
		DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_E),3,100,0xFFFFFFFF)
	end
	if Ready(_R) and Malzahar.Drawings.RangeDraw.R:Value() then
		DrawCircle(myHeroPos().x,myHeroPos().y,myHeroPos().z,GetCastRange(myHero,_R),3,100,0xFFCC0000)
	end
	if ValidTarget(unit, 1400) then
		local Qdmg = CalcDamage(myHero, unit, 0,  (55*GetCastLevel(myHero,_Q)+25+0.8*GetBonusAP(myHero)))
		if Ready(_Q) and Malzahar.Drawings.DrawDmg.Q:Value() then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),Qdmg,0,0xff00ff00)
		end
		local Wdmg =  CalcDamage(myHero, unit, 0,  ((GetCastLevel(myHero,_W)+3+.01*GetBonusAP(myHero))*GetMaxHP(unit)/100))
		if Ready(_W) and Malzahar.Drawings.DrawDmg.W:Value() then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),Wdmg,0,0xff00ff00)
		end
		local Edmg =  CalcDamage(myHero, unit, 0,  (60*GetCastLevel(myHero,_E)+20+.8*GetBonusAP(myHero)))
		if Ready(_E) and Malzahar.Drawings.DrawDmg.E:Value() then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),Edmg,0,0xff00ff00)
		end
		local Rdmg = CalcDamage(myHero, unit, 0,  (150*GetCastLevel(myHero,_R) + 1.3*GetBonusAP(myHero)))
		if Ready(_R) and Malzahar.Drawings.DrawDmg.R:Value() then
			DrawDmgOverHpBar(unit,GetCurrentHP(unit),Rdmg,0,0xFFCCCCCC)
		end
	end
end)
