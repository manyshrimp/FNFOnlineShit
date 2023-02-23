local bloom = 0

local function lerp(a, b, c) return a + (b-a) * c end

function onCreate()
	setProperty("dad.visible", false)
	luaDebugMode = true
	setProperty('skipCountdown', true)

	addCharacterToList("gold-head", "dad")

	makeAnimatedLuaSprite('nomore', 'characters/gold/cutscene/GOLD_TALK', -33, -108)
	scaleObject("nomore", 1.3, 1.3, true)
	addAnimationByPrefix("nomore", "idle", 'No More', 24, false) --change to false when done debugging
	setScrollFactor('nomore', 0.95, 0.95)
	--setProperty("nomore.alpha", 0.5)
	setProperty("nomore.origin.x", getProperty("dad.origin.x"))
end

local cases = {
	[1568] = function() --preloading
		makeAnimatedLuaSprite('headrip', 'characters/gold/cutscene/GOLD_HEAD_RIPPING_OFF', -150, -250)
		scaleObject("headrip", 1.3, 1.3, true)
		addAnimationByPrefix("headrip", "idle", 'Head rips_OneLayer instance ', 24, false)
		setScrollFactor('headrip', 0.95, 0.95)
		setProperty("headrip.origin.x", getProperty("dad.origin.x"))
	end,
	[1600] = function() -- no more :(((
		runTimer("noBeaches", 0.5, 1)
		doTweenAlpha('graveChange1','grave',0,stepCrochet * 16 / 1000)
	end,
	[1665] = function()
		removeLuaSprite("headrip", true)
		triggerEvent("Change Character", "Dad", "gold-head")
		runHaxeCode('game.setOnLuas("Rportrait","UI/pauseMenuStuff/Portraits/monochrome/right-nomore");')
		runHaxeCode('game.setOnLuas("Lportrait","UI/pauseMenuStuff/Portraits/monochrome/left-nomore");')
		doTweenZoom('headzoom', 'camGame', 0.625, stepCrochet * 48 / 1000, 'cubeInOut')
		setProperty("defaultCamZoom", 0.625)
	end
}

function jumble(str)
	local letters = {}
	for letter in str:gmatch'.[\128-\191]*' do
		table.insert(letters, {letter = letter, rnd = math.random()})
	end
	table.sort(letters, function(a, b) return a.rnd < b.rnd end)
	for i, v in ipairs(letters) do letters[i] = v.letter end
	return table.concat(letters)
end

function onStepHit()
	if cases[curStep] then cases[curStep]() end

	--[[if curStep > 1664 then
		setProperty('timeTxt.text',jumble('Monochrome'))
	end--]]
end
local Started = false

function onStartCountdown()
	if not Started then
		Started = true
		math.randomseed(os.time())	
		playSound("ImDead"..math.random(1,7),1,'ImDead')
		return Function_Stop
	end
end

function onSoundFinished(tag)
	if tag == 'ImDead' then
		startCountdown()
		playAnim("dad", "fadeIn", false)
		setProperty("dad.visible", true)
		setProperty('dad.alpha',0)
		doTweenAlpha('imNotDead','dad',1,stepCrochet*4/1000,'quadInOut')
		doTweenAlpha('bgfade','grave',0.7,stepCrochet*32/1000,'quadInOut')
		runTimer('goldIdle',1/3)
	end
end

local timers = {
	["noBeaches"] = function()
		addLuaSprite("nomore", true)
		playAnim("nomore", "idle", false)
		runTimer("headRIP", stepCrochet * 28 / 1000, 1)
	end,
	["headRIP"] = function()
		setProperty('grave2.visible',true)
		setProperty("dad.visible", false)
       	removeLuaSprite("nomore", true)
		addLuaSprite("headrip", true)
		playAnim("headrip", "idle", false)
		setTextString('botplaySubtext', "owie")
		screenCenter("botplaySubtext", "x")
		removeLuaSprite('grave',true)
		doTweenAlpha('graveChange2','grave2',1,stepCrochet * 16 / 1000)
	end,
	["goldIdle"] = function()
		playAnim("dad", "idle", true)
	end,
}

function onTimerCompleted(tag, loops, loopsLeft)
    if timers[tag] then timers[tag]() end
end

--[[
function onBeatHit()
	bloom = 5
end

function onUpdate()
	bloom = lerp(bloom,0,0.2)
	setShaderFloat('bloom','amount',bloom)
	debugPrint(getShaderFloat('bloom','amount'))
end

~~~~~~epic fail happened
--]]

--[[

local movedebug = true
if not movedebug then return end
local Incr = 1
local whattomove = "nomore"

function onUpdate()
	if keyboardJustPressed('A') then
        setProperty(whattomove..".x", getProperty(whattomove..".x") - Incr)
    elseif keyboardJustPressed('D') then
    	setProperty(whattomove..".x", getProperty(whattomove..".x") + Incr)
    elseif keyboardJustPressed('W') then
    	setProperty(whattomove..".y", getProperty(whattomove..".y") - Incr)
    elseif keyboardJustPressed('S') then
    	setProperty(whattomove..".y", getProperty(whattomove..".y") + Incr)
    elseif keyJustPressed('space') then
     	debugPrint(getProperty(whattomove..".x")..", ".. getProperty(whattomove..".y"))
		setProperty(whattomove..'.visible',not getProperty(whattomove..'.visible'))
    end
    --triggerEvent("Camera Follow Pos", getProperty(whattomove..".x"), getProperty(whattomove..".y"))
    --setProperty("boyfriend.x", getProperty("dad.x"))
    --setProperty("boyfriend.visible", false)
end--]]