-- LightCT by Alza
-- xCT by Dandruff
local T, C, L, G = unpack(select(2, ...))
local dragFrameList = G.dragFrameList

if not aCoreCDB.combattext then return end

local showreceived = aCoreCDB.showreceivedct
local showoutput = aCoreCDB.showoutputct
local fliter = aCoreCDB.ctfliter
local iconsize = aCoreCDB.cticonsize
local bigiconsize = aCoreCDB.ctbigiconsize
local showdots = aCoreCDB.ctshowdots
local showhots = aCoreCDB.ctshowhots
local fadetime = aCoreCDB.ctfadetime

local frames = {}
local healfilter = {}
local aoefilter = {}

local dmgcolor = {}
dmgcolor[1]  = {  1,  1,  0 }  -- physical
dmgcolor[2]  = {  1, .9, .5 }  -- holy
dmgcolor[4]  = {  1, .5,  0 }  -- fire
dmgcolor[8]  = { .3,  1, .3 }  -- nature
dmgcolor[16] = { .5,  1,  1 }  -- frost
dmgcolor[32] = { .5, .5,  1 }  -- shadow
dmgcolor[64] = {  1, .5,  1 }  -- arcane

local eventframe = CreateFrame"Frame"
eventframe:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

--[[  Class Specific Filter Assignment  ]]
if showoutput then
	if G.myClass == "WARLOCK" then
		aoefilter[27243] = true  -- Seed of Corruption (DoT) ��ʴ֮��
		aoefilter[27285] = true  -- Seed of Corruption (Explosion) ��ʴ֮��
		aoefilter[87385] = true  -- Seed of Corruption (Explosion Soulburned) ��ʴ֮��
		aoefilter[42223] = true  -- Rain of Fire ����֮��
		aoefilter[5857]  = true  -- Hellfire Effect ��������
		aoefilter[47897] = true  -- Shadowflame (shadow direct damage) �Ŷ���֮Ϣ
		aoefilter[47960] = true  -- Shadowflame (fire dot) �Ŷ���֮Ϣ
		aoefilter[50590] = true  -- Immolation Aura �׼��⻷
		aoefilter[30213] = true  -- Legion Strike (Felguard) ���Ŵ��
		aoefilter[89753] = true  -- Felstorm (Felguard) ħ�з籩
		aoefilter[20153] = true  -- Immolation (Infrenal) �׼�
		--[[ healing spells ]]--
		healfilter[63106] = true  -- Siphon Life ��������
		healfilter[54181] = true  -- Fel Synergy а�ܹ�Ч
		healfilter[89653] = true  -- Drain Life ��ȡ����
	elseif G.myClass == "DRUID" then
		aoefilter[42231] = true  -- Hurricane 쫷�
		aoefilter[50288] = true  -- Starfall �ǳ�׹��
		aoefilter[78777] = true  -- Wild Mushroom Ұ��Ģ��������
		aoefilter[61391] = true  -- Typhoon ̨��
		aoefilter[62078] = true  -- Swipe (Cat Form) ��ɨ
		aoefilter[779]   = true  -- Swipe (Bear Form) ��ɨ
		--[[ healing spells ]]--
		aoefilter[44203] = true  -- Tranquility ����
		--aoefilter[81269] = true  -- Efflorescence Ѹ������
	elseif G.myClass == "PALADIN" then
		aoefilter[81297] = true  -- Consecration ����
		aoefilter[53385] = true  -- Divine Storm ��ʥ�籩
		aoefilter[42463] = true  -- Seal of Truth ����ʥӡ
		aoefilter[101423] = true -- Seal of Righteousness (Thanks Shestak) ����ʥӡ
		--[[ healing spells ]]--
		aoefilter[85222] = true  -- Light of Dawn ����ʥ��
		aoefilter[82327] = true  -- Holy Radiance   (Thanks Nidra) ʥ������
	elseif G.myClass == "PRIEST" then
		aoefilter[49821] = true  -- Mind Seer ��������
		aoefilter[87532] = true  -- Shadowy Apparition ��Ӱ����
		aoefilter[15237] = true  -- Holy Nova (Damage Effect) ��ʥ����
		--[[ healing spells ]]--
		aoefilter[596]  = true  -- Prayer of Healing ���Ƶ���
		aoefilter[56161]= true  -- Glyph of Prayer of Healing ���Ƶ���
		aoefilter[64844]= true  -- Divine Hymn ��ʥ����ʫ
		aoefilter[32546]= true  -- Binding Heal ��������
		aoefilter[77489]= true  -- Echo of Light ʥ�����
		aoefilter[34861]= true  -- Circle of Healing ����֮��
		aoefilter[23455]= true  -- Holy Nova (Healing Effect) ��ʥ����
		aoefilter[88686]= true  -- Holy Word: Sanctuary ʥ��������
		--[[ healing spells ]]--
		healfilter[15290] = true  -- Vampiric Embrace ��Ѫ��ӵ��
	elseif G.myClass == "SHAMAN" then
		aoefilter[421]   = true  -- Chain Lightning ������
		aoefilter[8349]  = true  -- Fire Nova ��������
		aoefilter[77478] = true  -- Earhquake ������
		aoefilter[51490] = true  -- Thunderstorm �����籩
		aoefilter[8187]  = true  -- Magma Totem ����ͼ��
		--aoefilter[8050]  = true	-- Flame Shock (Thanks Shestak) �������
		aoefilter[25504] = true  -- Windfury (Thanks NitZo) ��ŭ����
		--[[ healing spells ]]--
		aoefilter[73921] = true  -- Healing Rain ����֮��
		aoefilter[1064]  = true  -- Chain Heal ������
		aoefilter[52042] = true  -- Healing Stream Totem ����֮Ȫͼ��
	elseif G.myClass == "MAGE" then
		aoefilter[44461] = true  -- Living Bomb Explosion ����ը��
		aoefilter[44457] = true  -- Living Bomb Dot ����ը��
		aoefilter[2120]  = true  -- Flamestrike ����籩
		aoefilter[31661] = true  -- Dragon's Breath ��Ϣ��
		aoefilter[42208] = true  -- Blizzard ����ѩ
		aoefilter[122]   = true  -- Frost Nova ��˪����
		aoefilter[1449]  = true  -- Arcane Explosion ħ����
		aoefilter[11113] = true  -- Blast Wave   (Thanks Shestak) �����
		aoefilter[83619] = true  -- Fire Power   (Thanks Shestak) ���汦��
		aoefilter[120]   = true  -- Cone of Cold (Thanks Shestak) ��׶��
	elseif G.myClass == "WARRIOR" then
		aoefilter[845]   = true  -- Cleave ˳��ն
		aoefilter[46968] = true  -- Shockwave �𵴲�
		aoefilter[6343]  = true  -- Thunder Clap ����һ��
		aoefilter[1680]  = true  -- Whirlwind ����ն
		aoefilter[50622] = true  -- Bladestorm ���з籩
		aoefilter[52174] = true  -- Heroic Leap Ӣ�·�Ծ
		--[[ healing spells ]]--
		healfilter[55694] = true  -- Enraged Regeneration ��ŭ�ظ�
	elseif G.myClass == "HUNTER" then
		aoefilter[2643]  = true  -- Multi-Shot �������
		--aoefilter[83077] = true  -- Serpent Sting (Instant Serpent Spread) (Thanks Naughtia) ���߶���
		--aoefilter[1978]  = true  -- Serpent Sting  (Thanks Naughtia) ���߶���
		aoefilter[13812] = true  -- Explosive Trap ��ը����
		--aoefilter[53301] = true  -- Explosive Shot (3 ticks merged as one) ��ը���
		--aoefilter[63468] = true  -- Piercing Shots �������
	elseif G.myClass == "DEATHKNIGHT" then
		aoefilter[55095] = true  -- Frost Fever ��˪�߲�
		aoefilter[55078] = true  -- Blood Plague Ѫ֮�߲�
		aoefilter[48721] = true  -- Blood Boil ѪҺ����
		aoefilter[49184] = true  -- Howling Blast �ݷ���
		aoefilter[52212] = true  -- Death and Decay ��������
		-- Merging MainHand/OffHand Strikes (by Bozo)(Thanks Shestak)
		aoefilter[55050] = true  --  Heart Strike (Thanks Shestak) ������
	elseif G.myClass == "ROGUE" then
		aoefilter[51723] = true  -- Fan of Knives ����
	end
end

local GetSpellTextureFormatted = function(spellID, iconSize)
	local msg = ""
	if spellID == PET_ATTACK_TEXTURE then
		msg = " \124T"..PET_ATTACK_TEXTURE..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
	else
		local icon = GetSpellTexture(spellID)
		if icon then
			msg = " \124T"..icon..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
		else
			msg = " \124T"..ct.blank..":"..iconSize..":"..iconSize..":0:0:64:64:5:59:5:59\124t"
		end
	end
	return msg
end

local function CreateCTFrame(i, movingname, justify, ...)
	local f = CreateFrame("ScrollingMessageFrame", "Combat Text"..i, UIParent)
	
	f:SetFont("Interface\\AddOns\\AltzUI\\media\\number.ttf", 12, "OUTLINE")
	f:SetShadowColor(0, 0, 0, 0)
	f:SetFadeDuration(0.2)
	f:SetTimeVisible(fadetime)
	f:SetMaxLines(20)
	f:SetSpacing(3)
	f:SetWidth(84)
	f:SetHeight(150)
	
	f.movingname = movingname
	f:SetJustifyH(justify)
	f:SetPoint(...)
	
	T.CreateDragFrame(f, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
	
	f.dragFrame:SetScript("OnUpdate", function(self, elapsed)
		self.timer = (self.timer or 0) + elapsed
		if self.timer > 1 then	
			self.number = random(1 , 10000)
			frames[1]:AddMessage("-"..self.number, 1, 0, 0)
			frames[2]:AddMessage("+"..self.number, 0, 1, 0)
			frames[3]:AddMessage(GetSpellTextureFormatted(6603, iconsize)..self.number, 1, 1, 0)
			frames[4]:AddMessage(GetSpellTextureFormatted(139, iconsize)..self.number, 0.3, 1, 0)
			self.timer = 0
		end
	end)
	
	return f
end

local tbl = {
	["DAMAGE"] = 			{frame = 1, prefix =  "-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["DAMAGE_CRIT"] = 		{frame = 1, prefix = "c-", 		arg2 = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_DAMAGE"] = 		{frame = 1, prefix =  "-", 		arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_DAMAGE_CRIT"] = {frame = 1, prefix = "c-", 		arg2 = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["HEAL"] = 				{frame = 2, prefix =  "+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["HEAL_CRIT"] = 		{frame = 2, prefix = "c+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["PERIODIC_HEAL"] = 	{frame = 2, prefix =  "+", 		arg3 = true, 	r = 0.1, 	g = 1, 		b = 0.1},
	["MISS"] = 				{frame = 1, prefix = "Miss", 					r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_MISS"] = 		{frame = 1, prefix = "Miss", 					r = 0.79, 	g = 0.3, 	b = 0.85},
	["SPELL_REFLECT"] = 	{frame = 1, prefix = "Reflect", 				r = 1, 		g = 1, 		b = 1},
	["DODGE"] = 			{frame = 1, prefix = "Dodge", 					r = 1, 		g = 0.1, 	b = 0.1},
	["PARRY"] = 			{frame = 1, prefix = "Parry", 					r = 1, 		g = 0.1, 	b = 0.1},
	["BLOCK"] = 			{frame = 1, prefix = "Block", 	spec = true,	r = 1, 		g = 0.1, 	b = 0.1},
	["RESIST"] = 			{frame = 1, prefix = "Resist", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_RESIST"] = 		{frame = 1, prefix = "Resist", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
	["ABSORB"] = 			{frame = 1, prefix = "Absorb", 	spec = true, 	r = 1, 		g = 0.1, 	b = 0.1},
	["SPELL_ABSORBED"] = 	{frame = 1, prefix = "Absorb", 	spec = true, 	r = 0.79, 	g = 0.3, 	b = 0.85},
}

if showreceived then
	frames[1] = CreateCTFrame(1, L["damageCT"], "LEFT", "RIGHT", UIParent, "CENTER", -185, 0)
	frames[2] = CreateCTFrame(2, L["healingCT"], "RIGHT", "LEFT", UIParent, "CENTER", -365, 0)
	eventframe:RegisterEvent"COMBAT_TEXT_UPDATE"
end

if showoutput then
	frames[3] = CreateCTFrame(3, L["outdamageCT"], "RIGHT", "LEFT", UIParent, "CENTER", 185, 80)
	frames[4] = CreateCTFrame(4, L["outhealingCT"], "LEFT", "RIGHT", UIParent, "CENTER", 365, 80)	
	eventframe:RegisterEvent"COMBAT_LOG_EVENT_UNFILTERED"
end

local template = "-%s (%s)"
function eventframe:COMBAT_TEXT_UPDATE(spelltype, arg2, arg3)
	local info = tbl[spelltype]
	if info then
		local msg = info.prefix
		if info.spec  then
			if arg3 then
				msg = template:format(arg2, arg3)
			end
		else
			if info.arg2 then msg = msg..arg2 end
			if info.arg3 then msg = msg..arg3 end
		end
		frames[info.frame]:AddMessage(msg, info.r, info.g, info.b)
	end
end

function eventframe:COMBAT_LOG_EVENT_UNFILTERED(...)
	local icon, spellId, amount, critical, spellSchool
    local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2 = select(1, ...)
	if sourceGUID == UnitGUID("player") or sourceFlags == gflags then
		if eventType == 'SPELL_HEAL' or (eventType == 'SPELL_PERIODIC_HEAL' and showhots) then
			spellId = select(12, ...)
			amount = select(15, ...)
			critical = select(18, ...)
			if fliter and (healfilter[spellId] or aoefilter[spellId]) then return end
			icon = GetSpellTextureFormatted(spellId, critical and bigiconsize or iconsize)
			frames[4]:AddMessage(amount..""..icon, 0, 1, 0)
		elseif destGUID ~= UnitGUID("player") then
			if eventType=="SWING_DAMAGE" then
				amount = select(12, ...)
				critical = select(18, ...)
				icon = GetSpellTextureFormatted(6603, critical and bigiconsize or iconsize)
			elseif eventType == "RANGE_DAMAGE" then
				spellId = select(12, ...)
				amount = select(15, ...)
				critical = select(21, ...)
				icon = GetSpellTextureFormatted(spellId, critical and bigiconsize or iconsize)
			elseif eventType == "SPELL_DAMAGE" or (showdots and eventType == "SPELL_PERIODIC_DAMAGE") then
				spellId = select(12, ...)
				spellSchool = select(14, ...)
				amount = select(15, ...)
				critical = select(21, ...)
				icon = GetSpellTextureFormatted(spellId, critical and bigiconsize or iconsize)
			elseif eventType == "SWING_MISSED" then
				amount = select(12, ...) -- misstype
				icon = GetSpellTextureFormatted(6603, iconsize)
			elseif eventType == "SPELL_MISSED" or eventType == "RANGE_MISSED" then
				spellId = select(12, ...)
				amount = select(15, ...) -- misstype
				icon = GetSpellTextureFormatted(spellId, iconsize)
			end
			
			if amount and icon then
				if fliter and spellId and aoefilter[spellId] then return end
				if critical then
					if dmgcolor[spellSchool] then
						frames[3]:AddMessage("+"..amount..""..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
					else
						frames[3]:AddMessage("+"..amount..""..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
					end
				else
					if dmgcolor[spellSchool] then
						frames[3]:AddMessage(amount..""..icon, dmgcolor[spellSchool][1], dmgcolor[spellSchool][2], dmgcolor[spellSchool][3])
					else
						frames[3]:AddMessage(amount..""..icon, dmgcolor[1][1], dmgcolor[1][2], dmgcolor[1][3])
					end
				end
			end
		end
	end
end

if not IsAddOnLoaded("Blizzard_CombatText") then LoadAddOn("Blizzard_CombatText") end
if IsAddOnLoaded("Blizzard_CombatText") then
	CombatText:SetScript("OnUpdate", nil)
	CombatText:SetScript("OnEvent", nil)
	CombatText:UnregisterAllEvents()
end

SetCVar("CombatLogPeriodicSpells", 0)
SetCVar("PetMeleeDamage", 0)
SetCVar("CombatDamage", 0)
SetCVar("CombatHealing", 0)