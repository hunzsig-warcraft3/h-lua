-- 加载YDWE库
cj = require "jass.common"
cg = require "jass.globals"

-- 加载blizzard
require "foundation.blizzard_c"
require "foundation.blizzard_b"

-- 加载const
require "const.enchant"
require "const.attribute"
require "const.attributeXtras"
require "const.breakArmorType"
require "const.cache"
require "const.damageSource"
require "const.damageType"
require "const.hero"
require "const.hotKey"
require "const.item"
require "const.monitor"
require "const.unit"
require "const.playerColor"
require "const.event"
require "const.slk"
require "const.abilityTarget"

-- 加载foundation
require "foundation.json"
require "foundation.md5"
require "foundation.cache"
require "foundation.cmd"
require "foundation.math"
require "foundation.string"
require "foundation.table"
require "foundation.color"
require "foundation.cmd"
require "foundation.echo"
require "foundation.Mapping"
require "foundation.slk"

-- 加载Dzapi库
-- 需要编辑器支持网易平台的DZAPI
-- 如果在lua中无法找到Dzapi，方法有两种：
-- 1. YDWE——配置——魔兽插件——[勾上]LUA引擎——[勾上]Dzapi（不行就做第2步）；打开触发窗口（F4），创建一个不运行的触发（无事件），在条件及动作补充你需要的Dzapi
-- 2. 使用h-war-sdk
require "lib.dzapi"
-- 加载JAPI库
require "lib.japi"

-- 加载h-lua库
require "lib.id"
require "lib.time"
require "lib.monitor"
require "lib.is"
require "lib.sound"
require "lib.texture"
require "lib.effect"
require "lib.lightning"
require "lib.weather"
require "lib.env"
require "lib.camera"
require "lib.event"
require "lib.eventDefaultActions"
require "lib.textTag"
require "lib.rect"
require "lib.player"
require "lib.award"
require "lib.unit"
require "lib.enemy"
require "lib.group"
require "lib.hero"
require "lib.courier"
require "lib.skill.index"
require "lib.skill.basic"
require "lib.skill.damage"
require "lib.skill.complex"
require "lib.skill.ring"
require "lib.buff"
require "lib.enchant"
require "lib.attribute.setter"
require "lib.attribute.index"
require "lib.attribute.xtras"
require "lib.item"
require "lib.itemPool"
require "lib.dialog"
require "lib.leaderBoard"
require "lib.multiBoard"
require "lib.quest"
require "lib.matcher"
require "lib.shop"

require "lib.initialization"
