---@class hhero 英雄相关
hhero = {
    player_allow_qty = {}, -- 玩家最大单位数量,默认1
    player_heroes = {}, -- 玩家当前英雄
    build_token = hslk_global.unit_hero_tavern_token,
    --- 英雄出生地
    bornX = 0,
    bornY = 0,
    --- 英雄选择池
    selectorPool = {},
    --- 英雄选择清理池
    selectorClearPool = {},
}

---@private
hhero.init = function()
    for i = 1, bj_MAX_PLAYER_SLOTS, 1 do
        local p = cj.Player(i - 1)
        hhero.player_allow_qty[p] = 1
        hhero.player_heroes[p] = {}
    end
end

--- 设置英雄之前的等级
---@protected
---@param u userdata
---@param lv number
hhero.setPrevLevel = function(u, lv)
    if (hRuntime.hero[u] == nil) then
        hRuntime.hero[u] = {}
    end
    hRuntime.hero[u].prevLevel = lv
end
--- 获取英雄之前的等级
---@protected
---@param u userdata
---@return number
hhero.getPrevLevel = function(u)
    if (hRuntime.hero[u] == nil) then
        hRuntime.hero[u] = {}
    end
    return hRuntime.hero[u].prevLevel or 0
end

--- 获取英雄当前等级
---@param u userdata
---@return number
hhero.getCurLevel = function(u)
    return cj.GetHeroLevel(u) or 1
end
--- 设置英雄当前的等级
---@paramu userdata
---@param newLevel number
---@param showEffect boolean
hhero.setCurLevel = function(u, newLevel, showEffect)
    if (type(showEffect) ~= "boolean") then
        showEffect = false
    end
    local oldLevel = cj.GetHeroLevel(u)
    if (newLevel > oldLevel) then
        cj.SetHeroLevel(u, newLevel, showEffect)
    elseif (newLevel < oldLevel) then
        cj.UnitStripHeroLevel(u, oldLevel - newLevel)
    else
        return
    end
    hhero.setPrevLevel(u, newLevel)
end

--- 获取英雄的类型（STR AGI INT）需要注册
---@param u userdata
---@return string STR|AGI|INT
hhero.getHeroType = function(u)
    return hslk_global.unitsKV[cj.GetUnitTypeId(u)].Primary
end

--- 获取英雄的类型文本
---@param u userdata
---@return string 力量|敏捷|智力
hhero.getHeroTypeLabel = function(u)
    return CONST_HERO_PRIMARY[hhero.getHeroType(u)]
end

--- 设置玩家最大英雄数量,支持1 - 7
--- 超过7会有很多魔兽原生问题，例如英雄不会复活，左侧图标无法查看等
---@param whichPlayer userdata
---@param max number
hhero.setPlayerAllowQty = function(whichPlayer, max)
    max = math.floor(max)
    if (max < 1) then
        max = 1
    end
    if (max > 7) then
        max = 7
    end
    heros.player_allow_qty[whichPlayer] = max
end
--- 获取玩家最大英雄数量
---@param whichPlayer userdata
---@return number
hhero.getPlayerAllowQty = function(whichPlayer)
    return hhero.player_allow_qty[whichPlayer] or 0
end

-- 设定选择英雄的出生地
hhero.setBornXY = function(x, y)
    hhero.bornX = x
    hhero.bornY = y
end

--- 设置一个单位是否拥有英雄判定
--- 当设置[一般单位]为[英雄]时，框架自动屏幕，[力量|敏捷|智力]等不属于一般单位的属性，以避免引起崩溃报错
--- 设定后 his.hero 方法会认为单位为英雄，同时属性系统也会认定它为英雄
---@param u userdata
---@param flag boolean
hhero.setIsHero = function(u, flag)
    flag = flag or false
    his.set(u, "isHero", flag)
    if (flag == true and his.get(u, "isHeroInit") == false) then
        his.set(u, "isHeroInit", true)
        hhero.setPrevLevel(u, 1)
        hevent.pool(u, hevent_default_actions.hero.levelUp, function(tgr)
            cj.TriggerRegisterUnitEvent(tgr, u, EVENT_UNIT_HERO_LEVEL)
        end)
    end
end

--- 开始构建英雄选择
---@param options table
hhero.buildSelector = function(options)
    --[[
        options = {
            heroes = {"H001","H002"}, -- 可以选择的单位ID
            during = 60, -- 选择持续时间，最少30秒，默认60秒，超过这段时间未选择的玩家会被剔除出游戏
            type = string, "tavern" | "click"
            buildX = 0, -- 构建点X
            buildY = 0, -- 构建点Y
            buildDistance = 256, -- 构建距离，例如两个酒馆间，两个单位间
            buildRowQty = 4, -- 每行构建的最大数目，例如一行最多4个酒馆
            allowTavernQty = 10, -- 酒馆模式下，一个酒馆最多拥有几种单位
        }
    ]]
    if (#options.heroes <= 0) then
        return
    end
    if (#hhero.selectorClearPool > 0) then
        echo("已经有1个选择事件在执行，请不要同时构建2个")
        return
    end
    local during = options.during or 60
    local type = options.type or "tavern"
    local buildX = options.buildX or 0
    local buildY = options.buildY or 0
    local buildDistance = options.buildDistance or 256
    local buildRowQty = options.buildRowQty or 4
    if (during < 30) then
        during = 30
    end
    local totalRow = 1
    local currentRowQty = 0
    local x = buildX
    local y = buildY
    if (type == "click") then
        for _, heroId in ipairs(options.heroes) do
            if (currentRowQty >= buildRowQty) then
                currentRowQty = 0
                totalRow = totalRow + 1
                x = buildX
                y = y - buildDistance
            else
                x = buildX + currentRowQty * buildDistance
            end
            local u = hunit.create(
                {
                    whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
                    unitId = heroId,
                    x = x,
                    y = y,
                    isInvulnerable = true,
                    isPause = true
                }
            )
            hRuntime.hero[u] = {
                selector = { x, y },
            }
            table.insert(hhero.selectorClearPool, u)
            table.insert(hhero.selectorPool, u)
            currentRowQty = currentRowQty + 1
        end
        for i = 1, hplayer.qty_max, 1 do
            hevent.onSelection(hplayer.players[i], 2, function(evtData)
                local p = evtData.triggerPlayer
                local u = evtData.triggerUnit
                if (table.includes(u, hhero.selectorClearPool) == false) then
                    return
                end
                if (cj.GetOwningPlayer(u) ~= cj.Player(PLAYER_NEUTRAL_PASSIVE)) then
                    return
                end
                if (#hhero.player_heroes[p] >= hhero.player_allow_qty[p]) then
                    echo("|cffffff80你已经选够了|r", p)
                    return
                end
                print_r(hhero.selectorPool)
                print(u)
                table.delete(u, hhero.selectorPool)
                table.delete(u, hhero.selectorClearPool)
                hunit.setInvulnerable(u, false)
                cj.SetUnitOwner(u, p, true)
                cj.SetUnitPosition(u, hhero.bornX, hhero.bornY)
                cj.PauseUnit(u, false)
                hhero.setIsHero(u, true)
                table.insert(hhero.player_heroes[p], u)
                -- 触发英雄被选择事件(全局)
                hevent.triggerEvent(
                    "global",
                    CONST_EVENT.pickHero,
                    {
                        triggerPlayer = tp,
                        triggerUnit = u
                    }
                )
                if (#hhero.player_heroes[p] >= hhero.player_allow_qty[p]) then
                    echo("您选择了 " .. "|cffffff80" .. cj.GetUnitName(u) .. "|r,已挑选完毕", p)
                else
                    echo("您选择了 |cffffff80" .. cj.GetUnitName(u) .. "|r,还要选 " ..
                        math.floor(hhero.player_allow_qty[p] - #hhero.player_heroes[p]) .. " 个", p
                    )
                end
            end)
        end
    elseif (type == "tavern") then
        local allowTavernQty = options.allowTavernQty or 10
        local currentTavernQty = 0
        local tavern
        for _, heroId in ipairs(options.heroes) do
            if (tavern == nil or currentTavernQty >= allowTavernQty) then
                currentTavernQty = 0
                if (currentRowQty >= buildRowQty) then
                    currentRowQty = 0
                    totalRow = totalRow + 1
                    x = buildX
                    y = y - buildDistance
                else
                    x = buildX + currentRowQty * buildDistance
                end
                tavern = hunit.create(
                    {
                        whichPlayer = cj.Player(PLAYER_NEUTRAL_PASSIVE),
                        unitId = hslk_global.unit_hero_tavern,
                        x = x,
                        y = y,
                    }
                )
                table.insert(hhero.selectorClearPool, tavern)
                cj.SetUnitTypeSlots(tavern, allowTavernQty)
                hevent.onUnitSell(tavern, function(evtData)
                    local p = cj.GetOwningPlayer(evtData.buyingUnit)
                    local soldUnit = evtData.soldUnit
                    local soldUid = cj.GetUnitTypeId(soldUnit)
                    if (#hhero.player_heroes[p] >= hhero.player_allow_qty[p]) then
                        echo("|cffffff80你已经选够~|r", p)
                        hunit.del(soldUnit, 0)
                        cj.AddUnitToStock(tavern, soldUid, 1, 1)
                        return
                    end
                    cj.RemoveUnitFromStock(tavern, soldUid)
                    hhero.setIsHero(soldUnit, true)
                    cj.SetUnitPosition(soldUnit, hhero.bornX, hhero.bornY)
                    table.insert(hhero.player_heroes[p], soldUnit)
                    table.delete(string.id2char(soldUid), hhero.selectorPool)
                    local tips = "您选择了 |cffffff80" .. cj.GetUnitName(soldUnit) .. "|r"
                    if (#hhero.player_heroes[p] >= hhero.player_allow_qty[p]) then
                        echo(tips .. ",已挑选完毕", p)
                    else
                        echo(tips .. "还差 " .. (hhero.player_allow_qty[p] - #hhero.player_heroes[p]) .. " 个", p)
                    end
                    hRuntime.hero[soldUnit] = {
                        selector = evtData.triggerUnit,
                    }
                end)
                currentRowQty = currentRowQty + 1
            end
            currentTavernQty = currentTavernQty + 1
            cj.AddUnitToStock(tavern, string.char2id(heroId), 1, 1)
            hRuntime.hero[heroId] = tavern
            table.insert(hhero.selectorPool, heroId)
        end
    end
    -- 视野token
    for i = 1, hplayer.qty_max, 1 do
        local p = cj.Player(i - 1)
        local u = hunit.create(
            {
                whichPlayer = p,
                unitId = hhero.build_token,
                x = buildX + buildRowQty * buildDistance * 0.5,
                y = buildY - math.floor(#options.heroes / buildRowQty) * buildDistance * 0.5,
                isInvulnerable = true,
                isPause = true
            }
        )
        table.insert(hhero.selectorClearPool, u)
    end
    -- 还剩10秒给个选英雄提示
    htime.setTimeout(
        during - 10.0,
        function(t)
            local x2 = buildX + buildRowQty * buildDistance * 0.5
            local y2 = buildY - math.floor(#options.heroes / buildRowQty) * buildDistance * 0.5
            htime.delTimer(t)
            hhero.selectorPool = {}
            echo("还剩 10 秒，还未选择的玩家尽快啦～")
            cj.PingMinimapEx(x2, y2, 8, 255, 0, 0, true)
        end
    )
    -- 逾期不选赶出游戏
    -- 对于可以选择多个的玩家，有选即可，不要求全选
    htime.setTimeout(during - 0.5, function(t)
        htime.delTimer(t)
        for _, u in ipairs(hhero.selectorClearPool) do
            hunit.del(u)
        end
        hhero.selectorClearPool = {}
        for i = 1, hplayer.qty_max, 1 do
            if (#hhero.player_heroes[hplayer.players[i]] <= 0) then
                hplayer.defeat(hplayer.players[i], "未选英雄")
            end
        end
    end, "英雄选择")
end
