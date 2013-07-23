local T, C, L, G = unpack(select(2, ...))
local oUF = AltzUF or oUF

local spellcache = setmetatable({}, {__index=function(t,v) local a = {GetSpellInfo(v)} if GetSpellInfo(v) then t[v] = a end return a end})
local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

G.auras = {
    -- Ascending aura timer
    -- Add spells to this list to have the aura time count up from 0
    -- NOTE: This does not show the aura, it needs to be in one of the other list too.
    ascending = {
        --[GetSpellInfo(92956)] = true, -- Wrack
    },

    -- Any Zone
    debuffs = {
		--[GetSpellInfo(2812)] = 16, -- TEST Ǵ��
        --[GetSpellInfo(6788)] = 16, -- Weakened Soul TEST
    },

    buffs = { -- these display on the second icon
		--[GetSpellInfo(139)] = 15, -- Renew TEST
		[GetSpellInfo(117309)] = 15, -- ����֮ˮ
	--��ʦ
		[GetSpellInfo(33206)] = 15, -- ʹ��ѹ��
        [GetSpellInfo(47788)] = 15, -- �ػ�֮��
	--С��
        [GetSpellInfo(102342)] = 15, -- ��ľ��Ƥ
		[GetSpellInfo(22812)] = 15, -- ��Ƥ��
		[GetSpellInfo(61336)] = 15, -- ���汾��
		[GetSpellInfo(105737)] = 15, -- ������֮��
		[GetSpellInfo(22842)] = 14, -- �񱩻ظ�
	--��ʿ
		[GetSpellInfo(1022)] = 15, -- ����֮��
		[GetSpellInfo(31850)] = 15, -- ���ȷ�����
        [GetSpellInfo(498)] = 15, -- ʥ����
		[GetSpellInfo(642)] = 15, -- ʥ����
		[GetSpellInfo(86659)] = 15, -- Զ����������
	--��ɮ
		[GetSpellInfo(116849)] = 15, -- ���븿��
		[GetSpellInfo(115203)] = 15, -- ׳����
        --[GetSpellInfo(115308)] = 14, -- Ʈ���		
	--DK
        [GetSpellInfo(50397)] = 15, -- ����֮��
		[GetSpellInfo(48707)] = 15, -- ��ħ������
		[GetSpellInfo(48792)] = 15, -- ����֮��
		[GetSpellInfo(49222)] = 14, -- �׹�֮��
		[GetSpellInfo(49028)] = 14, -- ��������
		[GetSpellInfo(55233)] = 15, -- ��������
	--սʿ
        [GetSpellInfo(112048)] = 14, -- ��������
		[GetSpellInfo(12975)] = 15, -- �Ƹ�����
		[GetSpellInfo(871)] = 15, -- ��ǽ
	--ħ��ɽ���Ž���BUFF
		[GetSpellInfo(120717)] = 14, -- ����֮��
    },
}