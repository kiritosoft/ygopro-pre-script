--スプライト・キャロット
--
--Script by Trishula9
function c101109007.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101109007,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101109007+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101109007.spcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101109007,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,101109007+100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101109007.discon)
	e2:SetCost(c101109007.discost)
	e2:SetTarget(c101109007.distg)
	e2:SetOperation(c101109007.disop)
	c:RegisterEffect(e2)
end
function c101109007.filter(c)
	return (c:IsLevel(2) or c:IsLink(2)) and c:IsFaceup()
end
function c101109007.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101109007.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c101109007.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
end
function c101109007.cfilter(c)
	return c:IsLevel(2) or c:IsRank(2) or c:IsLink(2)
end
function c101109007.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101109007.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c101109007.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
end
function c101109007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsDisabled() end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101109007.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and rc:IsDestructable()
		and (e:GetLabelObject():IsRank(2) or e:GetLabelObject():IsLink(2))
		and Duel.SelectYesNo(tp,aux.Stringid(101109007,2)) then
		Duel.BreakEffect()
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
