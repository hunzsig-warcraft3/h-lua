-- 事件
CONST_EVENT = {
    attackDetect = "attackDetect",
    attackGetTarget = "attackGetTarget",
    beAttackReady = "beAttackReady",
    attack = "attack",
    beAttack = "beAttack",
    skill = "skill",
    beSkill = "beSkill",
    skillStudy = "skillStudy",
    skillReady = "skillReady",
    skillCast = "skillCast",
    skillEffect = "skillEffect",
    skillStop = "skillStop",
    skillFinish = "skillFinish",
    item = "item",
    beItem = "beItem",
    itemUsed = "itemUsed",
    itemSell = "itemSell",
    unitSell = "unitSell",
    itemDrop = "itemDrop",
    itemPawn = "itemPawn",
    itemGet = "itemGet",
    itemDestroy = "itemDestroy",
    itemSynthesis = "itemSynthesis",
    itemSeparate = "itemSeparate",
    itemOverWeight = "itemOverWeight",
    itemOverSlot = "itemOverSlot",
    damage = "damage",
    beDamage = "beDamage",
    damageResistance = "damageResistance",
    avoid = "avoid",
    beAvoid = "beAvoid",
    breakArmor = "breakArmor",
    beBreakArmor = "beBreakArmor",
    swim = "swim",
    beSwim = "beSwim",
    broken = "broken",
    beBroken = "beBroken",
    silent = "silent",
    beSilent = "beSilent",
    unarm = "unarm",
    beUnarm = "beUnarm",
    fetter = "fetter",
    beFetter = "beFetter",
    bomb = "bomb",
    beBomb = "beBomb",
    lightningChain = "lightningChain",
    beLightningChain = "beLightningChain",
    crackFly = "crackFly",
    beCrackFly = "beCrackFly",
    rebound = "rebound",
    beRebound = "beRebound",
    knocking = "knocking",
    beKnocking = "beKnocking",
    spilt = "spilt",
    beSpilt = "beSpilt",
    hemophagia = "hemophagia",
    beHemophagia = "beHemophagia",
    skillHemophagia = "skillHemophagia",
    beSkillHemophagia = "beSkillHemophagia",
    punish = "punish",
    dead = "dead",
    kill = "kill",
    reborn = "reborn",
    levelUp = "levelUp",
    enterUnitRange = "enterUnitRange",
    enterRect = "enterRect",
    leaveRect = "leaveRect",
    chat = "chat",
    esc = "esc",
    selection = "selection",
    deSelection = "deSelection",
    upgradeStart = "upgradeStart",
    upgradeCancel = "upgradeCancel",
    upgradeFinish = "upgradeFinish",
    constructStart = "constructStart",
    constructCancel = "constructCancel",
    constructFinish = "constructFinish",
    pickHero = "pickHero",
    playerLeave = "playerLeave",
    destructableDestroy = "destructableDestroy",
    courierBlink = "courierBlink",
    courierRangePickUp = "courierRangePickUp",
    courierSeparate = "courierSeparate",
    courierDeliver = "courierDeliver",
    moveStart = "moveStart",
    moving = "moving",
    moveStop = "moveStop",
    holdOn = "holdOn",
    stop = "stop",
}

CONST_EVENT_LABELS = {
    [CONST_EVENT.attack] = '攻击命中',
    [CONST_EVENT.beAttack] = '被攻击命中',
    [CONST_EVENT.skill] = '技能击中',
    [CONST_EVENT.beSkill] = '被技能击中',
    [CONST_EVENT.item] = '物品击中',
    [CONST_EVENT.beItem] = '被物品击中',
    [CONST_EVENT.damage] = '造成伤害',
    [CONST_EVENT.beDamage] = '受到伤害',
    [CONST_EVENT.attackDetect] = '注意到攻击目标',
    [CONST_EVENT.attackGetTarget] = '获取攻击目标',
    [CONST_EVENT.beAttackReady] = '即将被攻击',
    [CONST_EVENT.skillStudy] = '学到技能',
    [CONST_EVENT.skillReady] = '准备施放技能',
    [CONST_EVENT.skillCast] = '开始施放技能',
    [CONST_EVENT.skillEffect] = '技能生效',
    [CONST_EVENT.skillStop] = '停止施放技能',
    [CONST_EVENT.skillFinish] = '技能结束',
    [CONST_EVENT.itemUsed] = '使用物品',
    [CONST_EVENT.itemSell] = '售卖物品',
    [CONST_EVENT.unitSell] = '售卖单位',
    [CONST_EVENT.itemDrop] = '丢弃物品',
    [CONST_EVENT.itemPawn] = '抵押物品',
    [CONST_EVENT.itemGet] = '获得物品',
    [CONST_EVENT.itemSynthesis] = '合成物品',
    [CONST_EVENT.itemSeparate] = '拆分物品',
    [CONST_EVENT.itemOverWeight] = '物品超重',
    [CONST_EVENT.itemOverSlot] = '物品满格',
    [CONST_EVENT.damageResistance] = '完全减伤',
    [CONST_EVENT.avoid] = '回避',
    [CONST_EVENT.beAvoid] = '被闪躲',
    [CONST_EVENT.breakArmor] = '破防',
    [CONST_EVENT.beBreakArmor] = '被破防',
    [CONST_EVENT.swim] = '眩晕',
    [CONST_EVENT.beSwim] = '被眩晕',
    [CONST_EVENT.broken] = '打断',
    [CONST_EVENT.beBroken] = '被打断',
    [CONST_EVENT.silent] = '沉默',
    [CONST_EVENT.beSilent] = '被沉默',
    [CONST_EVENT.unarm] = '缴械',
    [CONST_EVENT.beUnarm] = '被缴械',
    [CONST_EVENT.fetter] = '缚足',
    [CONST_EVENT.beFetter] = '被缚足',
    [CONST_EVENT.bomb] = '爆破',
    [CONST_EVENT.beBomb] = '被爆破',
    [CONST_EVENT.lightningChain] = '电链击中',
    [CONST_EVENT.beLightningChain] = '被电链击中',
    [CONST_EVENT.crackFly] = '击飞',
    [CONST_EVENT.beCrackFly] = '被击飞',
    [CONST_EVENT.rebound] = '反弹伤害',
    [CONST_EVENT.beRebound] = '被反伤',
    [CONST_EVENT.knocking] = '暴击',
    [CONST_EVENT.beKnocking] = '被暴击',
    [CONST_EVENT.spilt] = '造成分裂',
    [CONST_EVENT.beSpilt] = '被分裂伤害',
    [CONST_EVENT.hemophagia] = '攻击吸血',
    [CONST_EVENT.beHemophagia] = '被攻击吸血',
    [CONST_EVENT.skillHemophagia] = '技能吸血',
    [CONST_EVENT.beSkillHemophagia] = '被技能吸血',
    [CONST_EVENT.punish] = '僵直',
    [CONST_EVENT.dead] = '死亡',
    [CONST_EVENT.kill] = '杀敌',
    [CONST_EVENT.reborn] = '重生',
    [CONST_EVENT.levelUp] = '升级',
    [CONST_EVENT.moveStart] = '移动开始',
    [CONST_EVENT.moving] = '移动',
    [CONST_EVENT.moveStop] = '停止移动',
    [CONST_EVENT.holdOn] = '伫立',
    [CONST_EVENT.stop] = '停止',
}

CONST_EVENT_TARGET_LABELS = {
    [CONST_EVENT.attack] = { triggerUnit = '己', targetUnit = '敌', attacker = '己' },
    [CONST_EVENT.beAttack] = { triggerUnit = '己', targetUnit = '己', attacker = '敌' },
    [CONST_EVENT.skill] = { triggerUnit = '己', targetUnit = '敌', caster = '己' },
    [CONST_EVENT.beSkill] = { triggerUnit = '己', targetUnit = '己', caster = '敌' },
    [CONST_EVENT.item] = { triggerUnit = '己', targetUnit = '敌', user = '己' },
    [CONST_EVENT.beItem] = { triggerUnit = '己', targetUnit = '己', user = '敌' },
    [CONST_EVENT.damage] = { triggerUnit = '己', targetUnit = '敌', sourceUnit = '己' },
    [CONST_EVENT.beDamage] = { triggerUnit = '己', targetUnit = '己', sourceUnit = '敌' },
    [CONST_EVENT.attackDetect] = { triggerUnit = '己', targetUnit = '敌' },
    [CONST_EVENT.attackGetTarget] = { triggerUnit = '己', targetUnit = '敌' },
    [CONST_EVENT.beAttackReady] = { triggerUnit = '己', attacker = '敌' },
    [CONST_EVENT.skillStudy] = { triggerUnit = '己' },
    [CONST_EVENT.skillReady] = { triggerUnit = '己', targetUnit = '敌' },
    [CONST_EVENT.skillCast] = { triggerUnit = '己', targetUnit = '敌' },
    [CONST_EVENT.skillEffect] = { triggerUnit = '己', targetUnit = '敌' },
    [CONST_EVENT.skillStop] = { triggerUnit = '己' },
    [CONST_EVENT.skillFinish] = { triggerUnit = '己' },
    [CONST_EVENT.itemUsed] = { triggerUnit = '己', targetUnit = '标' },
    [CONST_EVENT.itemSell] = { triggerUnit = '己' },
    [CONST_EVENT.unitSell] = { triggerUnit = '己', soldUnit = '禁', buyingUnit = '标' },
    [CONST_EVENT.itemDrop] = { triggerUnit = '己', targetUnit = '标' },
    [CONST_EVENT.itemPawn] = { triggerUnit = '己', buyingUnit = '标' },
    [CONST_EVENT.itemGet] = { triggerUnit = '己' },
    [CONST_EVENT.itemSynthesis] = { triggerUnit = '己' },
    [CONST_EVENT.itemOverWeight] = { triggerUnit = '己' },
    [CONST_EVENT.itemOverSlot] = { triggerUnit = '己' },
    [CONST_EVENT.damageResistance] = { triggerUnit = '己', sourceUnit = '敌' },
    [CONST_EVENT.avoid] = { triggerUnit = '己', attacker = '敌' },
    [CONST_EVENT.beAvoid] = { triggerUnit = '己', targetUnit = '敌', attacker = '己' },
    [CONST_EVENT.breakArmor] = { triggerUnit = '己', targetUnit = '敌' },
    [CONST_EVENT.beBreakArmor] = { triggerUnit = '己', sourceUnit = '敌' },
    [CONST_EVENT.swim] = '眩晕',
    [CONST_EVENT.beSwim] = '被眩晕',
    [CONST_EVENT.broken] = '打断',
    [CONST_EVENT.beBroken] = '被打断',
    [CONST_EVENT.silent] = '沉默',
    [CONST_EVENT.beSilent] = '被沉默',
    [CONST_EVENT.unarm] = '缴械',
    [CONST_EVENT.beUnarm] = '被缴械',
    [CONST_EVENT.fetter] = '缚足',
    [CONST_EVENT.beFetter] = '被缚足',
    [CONST_EVENT.bomb] = '爆破',
    [CONST_EVENT.beBomb] = '被爆破',
    [CONST_EVENT.lightningChain] = '电链击中',
    [CONST_EVENT.beLightningChain] = '被电链击中',
    [CONST_EVENT.crackFly] = '击飞',
    [CONST_EVENT.beCrackFly] = '被击飞',
    [CONST_EVENT.rebound] = '反弹伤害',
    [CONST_EVENT.beRebound] = '被反伤',
    [CONST_EVENT.knocking] = '暴击',
    [CONST_EVENT.beKnocking] = '被暴击',
    [CONST_EVENT.spilt] = '造成分裂',
    [CONST_EVENT.beSpilt] = '被分裂伤害',
    [CONST_EVENT.hemophagia] = '攻击吸血',
    [CONST_EVENT.beHemophagia] = '被攻击吸血',
    [CONST_EVENT.skillHemophagia] = '技能吸血',
    [CONST_EVENT.beSkillHemophagia] = '被技能吸血',
    [CONST_EVENT.punish] = '僵直',
    [CONST_EVENT.dead] = '死亡',
    [CONST_EVENT.kill] = '杀敌',
    [CONST_EVENT.reborn] = '重生',
    [CONST_EVENT.levelUp] = '升级',
    [CONST_EVENT.moveStart] = '移动开始',
    [CONST_EVENT.moving] = '移动',
    [CONST_EVENT.moveStop] = '停止移动',
    [CONST_EVENT.holdOn] = '伫立',
    [CONST_EVENT.stop] = '停止',
}