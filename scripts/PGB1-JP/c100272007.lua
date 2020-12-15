--予見者ゾルガ
--Zolga the Prophet
--Scripted by Kohana Sonogami & mercury233
function c100272007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100272007,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100272007)
	e1:SetCondition(c100272007.spcon)
	e1:SetTarget(c100272007.sptg)
	e1:SetOperation(c100272007.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100272007,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1,100272007+100)
	e2:SetCondition(c100272007.dmcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100272007.dmtg)
	e2:SetOperation(c100272007.dmop)
	c:RegisterEffect(e2)
	--effect reg
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c100272007.regcon)
	e3:SetOperation(c100272007.regop)
	c:RegisterEffect(e3)
end
function c100272007.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_FAIRY)
		and not c:IsCode(100272007)
end
function c100272007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100272007.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100272007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100272007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		for p=tp,1-tp,1-tp-tp do
			local g=Duel.GetFieldGroup(p,LOCATION_DECK,0)
			local ct={}
			for i=5,1,-1 do
				if #g>=i then
					table.insert(ct,i)
				end
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100272007,(p==tp and 2 or 3)))
			local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
			local sg=Duel.GetDecktopGroup(p,ac)
			Duel.ConfirmCards(tp,sg)
		end
	end
end
function c100272007.dmcon(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
	return at:GetFlagEffectLabel(100272007)==c:GetFieldID()
end
function c100272007.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local at=Duel.GetAttacker()
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,at,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c100272007.dmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,2000,REASON_EFFECT)
		end
	end
end
function c100272007.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return r==REASON_SUMMON and rc:IsFaceup()
end
function c100272007.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if r==REASON_SUMMON and rc:IsFaceup() and c:IsLocation(LOCATION_GRAVE) then
		rc:RegisterFlagEffect(100272007,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,c:GetFieldID(),aux.Stringid(100272007,4))
	end
end
