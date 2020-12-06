--- 技能：光环
hring = {
    ACTIVE_RING = {},
    ACTIVE_TIMER = nil,
    ACTIVE_EFFECT = {},
    ACTIVE_EFFECT_TARGET = {},
}

---@private
hring.getHSlk = function(idOrName)
    if (idOrName == nil) then
        return
    end
    local id = idOrName
    if (type(idOrName) == "number") then
        id = string.id2char(idOrName)
    end
    if (hslk.i2v.ring[id]) then
        return hslk.i2v.ring[id]
    elseif (hslk.n2v.ring[id]) then
        return hslk.n2v.ring[id]
    end
    return nil
end

--- 根据光环名称获取技能ID字符串
---@param name string
---@return string
hring.n2i = function(name)
    if (hslk.n2v.ring[name]) then
        return hslk.n2v.ring[name]._id or nil
    end
    return nil
end

--- 检查技能ID是否支持光环服务
--- 成功则返回ID字符串,失败返回false
---@private
---@param id number|string
---@return boolean|string
hring.check = function(id)
    local hs = hring.getHSlk(id)
    if (hs == nil) then
        return false
    end
    return hs._id
end

---@private
---@param whichUnit userdata
---@param id number|string
hring.insert = function(whichUnit, id)
    id = hring.check(id)
    if (id == false) then
        return
    end
    if (his.deleted(whichUnit) == false) then
        table.insert(hring.ACTIVE_RING, { status = 2, unit = whichUnit, id = id, group = {} })
        local hs = hring.getHSlk(id)
        if (hs.effect) then
            if (hring.ACTIVE_EFFECT[id] == nil) then
                hring.ACTIVE_EFFECT[id] = {}
            end
            if (hring.ACTIVE_EFFECT[id][whichUnit] == nil) then
                hring.ACTIVE_EFFECT[id][whichUnit] = {
                    effect = heffect.bindUnit(hs.effect, whichUnit, hs.attach or 'origin', -1),
                    count = 1,
                }
            else
                hring.ACTIVE_EFFECT[id][whichUnit].count = hring.ACTIVE_EFFECT[id][whichUnit].count + 1
            end
        end
    end
    if (hring.ACTIVE_TIMER == nil and #hring.ACTIVE_RING > 0) then
        hring.ACTIVE_TIMER = htime.setInterval(0.3, function(curTimer)
            if (#hring.ACTIVE_RING == 0) then
                htime.delTimer(curTimer)
                curTimer = nil
                hring.ACTIVE_TIMER = nil
                hring.ACTIVE_RING = {}
                hring.ACTIVE_EFFECT = {}
                hring.ACTIVE_EFFECT_TARGET = {}
                return
            end
            for k, ring in ipairs(hring.ACTIVE_RING) do
                local u = ring.unit
                local status = ring.status
                if (his.deleted(u) == true) then
                    status = -1
                    ring.status = -1
                elseif (his.dead(u) == true) then
                    status = 1
                end
                --
                local g = {}
                local ringId = ring.id
                local hs = hring.getHSlk(ringId)
                if (status == 2 and hs ~= nil) then
                    if (hs.effectTarget and hring.ACTIVE_EFFECT_TARGET[ringId] == nil) then
                        hring.ACTIVE_EFFECT_TARGET[ringId] = {}
                    end
                    local radius = math.floor(hs.radius or 0)
                    local target = hs.target or {}
                    if (radius > 0) then
                        local selector = {
                            air = false, --空中
                            ground = false, --地面
                            structure = false, --建筑
                            ward = false, --守卫（不支持）
                            organic = false, --有机的
                            mechanical = false, --机械的
                            vuln = false, --可攻击
                            invu = false, --无敌
                            friend = false, --友军
                            enemies = false, --敌人1
                            enemy = false, --敌人2
                            allies = false, --联盟
                            player = false, --玩家单位
                            neutral = false, --中立
                            self = false, --自己
                            nonself = false, --别人
                            alive = false, --存活
                            dead = false, --死亡
                            hero = false, --英雄
                            nonhero = false, --非英雄
                            ancient = false, --古树
                            nonancient = false, --非古树
                            sapper = false, --自爆工兵
                            nonsapper = false, --非自爆工兵
                        }
                        if (#target > 0) then
                            --有自定义勾选目标
                            for _, t in ipairs(target) do
                                if (selector[t] ~= nil) then
                                    selector[t] = true
                                end
                            end
                        end
                        --- 模拟处理魔兽默认目标（* 去掉了非单位的项；和不常用项的判断，如需要请自行补回）
                        --- 目标允许 : 可以对其施放的对象类型
                        --- 同行之间为Or关系,异行之间为And关系,该行不选则取默认值 例:
                        --- 只选择无敌则表示目标允许无敌的存活的别人的单位[空中/地面/建筑]
                        --- 空中/地面/建筑(默认空中/地面/建筑)
                        if (selector.air == false and selector.ground == false and selector.structure == false) then
                            selector.air = true
                            selector.ground = true
                            selector.structure = true
                        end
                        --- 存活/死亡 (默认存活)
                        if (selector.alive == false and selector.dead == false) then
                            selector.alive = true
                        end
                        --- 无敌/可攻击 (默认可攻击)
                        if (selector.vuln == false and selector.invu == false) then
                            selector.vuln = true
                        end
                        --- 联盟/友军[不包括玩家单位]/敌人/玩家单位/中立/自己/别人 (默认别人)
                        if (selector.allies == false and selector.friend == false
                            and selector.enemies == false and selector.enemy == false
                            and selector.neutral == false and selector.player == false
                            and selector.self == false and selector.nonself == false) then
                            selector.nonself = true
                        end
                        --- 英雄/非英雄 (默认全选)
                        if (selector.hero == false and selector.nonhero == false) then
                            selector.hero = true
                            selector.nonhero = true
                        end
                        --- 古树/非古树 (默认全选)
                        if (selector.ancient == false and selector.nonancient == false) then
                            selector.ancient = true
                            selector.nonancient = true
                        end
                        --- 自爆工兵/非自爆工兵 (默认全选)
                        if (selector.sapper == false and selector.nonsapper == false) then
                            selector.sapper = true
                            selector.nonsapper = true
                        end
                        --- 机械/有机 (默认全选)
                        if (selector.mechanical == false and selector.organic == false) then
                            selector.mechanical = true
                            selector.organic = true
                        end
                        local uOwner = hunit.getOwner(u)
                        g = hgroup.createByUnit(u, radius, function(filterUnit)
                            --
                            local air = selector.air and his.air(filterUnit)
                            local ground = selector.ground and his.ground(filterUnit)
                            local structure = selector.structure and his.structure(filterUnit)
                            local statusAGS = air or ground or structure
                            --
                            local organic = selector.organic and his.mechanical(filterUnit) == false
                            local mechanical = selector.mechanical and his.mechanical(filterUnit)
                            local statusOM = organic or mechanical
                            --
                            local vuln = selector.vuln and his.invincible(filterUnit) == false
                            local invu = selector.invu and his.invincible(filterUnit)
                            local statusVI = vuln or invu
                            --
                            local alive = selector.alive and his.alive(filterUnit)
                            local dead = selector.dead and his.dead(filterUnit)
                            local statusAD = alive or dead
                            --
                            local hero = selector.hero and his.hero(filterUnit)
                            local nonhero = selector.nonhero and his.hero(filterUnit) == false
                            local statusHN = hero or nonhero
                            --
                            local ancient = selector.ancient and his.ancient(filterUnit)
                            local nonancient = selector.nonancient and his.ancient(filterUnit) == false
                            local statusAN = ancient or nonancient
                            --
                            local sapper = selector.sapper and his.ancient(filterUnit)
                            local nonsapper = selector.nonsapper and his.ancient(filterUnit) == false
                            local statusSN = sapper or nonsapper
                            --
                            local filterOwner = hunit.getOwner(filterUnit)
                            local friend = selector.friend and (his.ally(filterUnit) or uOwner == filterOwner)
                            local enemies = (selector.enemies or selector.enemy) and his.enemy(u, filterUnit)
                            local allies = selector.allies and his.ally(u, filterUnit)
                            local player = selector.player and uOwner == filterOwner
                            local neutral = selector.neutral and filterOwner == cj.Player(PLAYER_NEUTRAL_PASSIVE)
                            local self1 = selector.self and his.unit(u, filterUnit)
                            local nonself = selector.nonself and his.unit(u, filterUnit) == false
                            local statusFEAPNSN = friend or enemies or allies or player or neutral or self1 or nonself
                            return statusAGS and statusOM
                                and statusVI and statusAD
                                and statusHN and statusAN
                                and statusSN and statusFEAPNSN
                        end)
                    end
                end
                -- slk配置的RING属性
                if (type(hs.attr) == 'table') then
                    hgroup.loop(ring.group, function(enumUnit)
                        if (hgroup.includes(g, enumUnit) == false) then
                            hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, false, enumUnit, hs.attr, 1)
                            if (hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit] ~= nil) then
                                hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit].count = hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit].count - 1
                                if (hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit].count == 0) then
                                    heffect.del(hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit].effect)
                                    hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit] = nil
                                end
                            end
                        end
                    end)
                end
                if (#g > 0) then
                    local matchAction
                    if (#hmatcher.RING_MATCHER > 0) then
                        local name = hs._name or -1
                        for _, m in ipairs(hmatcher.RING_MATCHER) do
                            local s, e = string.find(name, m[1])
                            if (s ~= nil and e ~= nil) then
                                matchAction = m[2]
                            end
                        end
                    end
                    hgroup.loop(g, function(enumUnit)
                        -- slk配置的RING属性
                        if (type(hs.attr) == 'table' and false == hgroup.includes(ring.group, enumUnit)) then
                            hattribute.caleAttribute(CONST_DAMAGE_SRC.skill, true, enumUnit, hs.attr, 1)
                            if (hs.effectTarget) then
                                if (hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit] == nil) then
                                    hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit] = {
                                        count = 1,
                                        effect = heffect.bindUnit(hs.effectTarget, enumUnit, hs.attachTarget or 'origin', -1)
                                    }
                                else
                                    hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit].count = hring.ACTIVE_EFFECT_TARGET[ringId][enumUnit].count + 1
                                end
                            end
                        end
                        -- 检测是否有自定义的matcher，用于给玩家自定义额外的操作
                        if (matchAction ~= nil and type(matchAction) == 'function') then
                            matchAction({
                                triggerUnit = u,
                                enumUnit = enumUnit,
                            })
                        end
                    end)
                end
                if (status ~= -1) then
                    ring.group = g
                else
                    if (hring.ACTIVE_EFFECT[ringId][u] ~= nil) then
                        hring.ACTIVE_EFFECT[ringId][u].count = hring.ACTIVE_EFFECT[ringId][u].count - 1
                        if (hring.ACTIVE_EFFECT[ringId][u].count == 0) then
                            heffect.del(hring.ACTIVE_EFFECT[ringId][u].effect)
                            hring.ACTIVE_EFFECT[ringId][u] = nil
                        end
                    end
                    table.remove(hring.ACTIVE_RING, k)
                    k = k - 1
                end
            end
        end)
    end
end

---@private
---@param whichUnit userdata
---@param id number|string
hring.remove = function(whichUnit, id)
    id = hring.check(id)
    if (id == false) then
        return
    end
    for _, v in ipairs(hring.ACTIVE_RING) do
        if (v.status ~= -1) then
            if (v.unit == whichUnit and v.id == id) then
                v.status = -1
                break
            end
        end
    end
end