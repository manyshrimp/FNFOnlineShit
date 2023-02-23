
local bopspeed = 1
local thinkin = false
local vel = {0,0}

local shit = {
    'newBar',
    'healthBar',
    'newBG',
    'iconP1',
    'iconP2',
    'dad',
    'boyfriend',
    'gamefriend',
    'timeBarBG',
    'timeBar',
    'timeTxt'
}

function onCreate()
	--[[setProperty("camHUD.visible", false)
	setProperty("scoreTxt.alpha", 0.5)
	setProperty("healthBar.alpha", 0.8)--]]

	luaDebugMode = true
	
	setProperty("legacyCutscene.visible", false)

	makeAnimatedLuaSprite('legacyCutscene', 'isotope/they_took_everything_from_me', 420+150, -40); --420 nice
	setScrollFactor('legacyCutscene', 0, 0);
	scaleObject("legacyCutscene", 1.25, 1.25 , true)
	setProperty("legacyCutscene.alpha", 0)
	setObjectCamera('legacyCutscene', 'camHUD')
	addAnimationByPrefix("legacyCutscene", "speech", "GlitchySpeak", 24, false)
	addLuaSprite('legacyCutscene', true);
	setBlendMode('legacyCutscene','overlay')
	
	addCharacterToList('glitchy-red-mad','dad')
	precacheImage('icons/icon-glitchy-red-mad')
end

function onEvent(name,value1,value2)
    if name == 'Camera Bop Speed' then
        bopspeed = tonumber(value2) or 0
    end
end

function onCountdownStarted()
    setProperty('skipCountdown',true)
end

stepstuff = {
	[128] = function()
		setProperty('defaultCamZoom', 0.85)
	end,
	[1056] = function()
		setProperty('defaultCamZoom',1)
		setProperty('camFollow.x',-600)
		setProperty('camFollow.y',200)
		setProperty('isCameraOnForcedPos',true)
	end,
	[1084] = function()
		setProperty('defaultCamZoom',0.9)
		setProperty('camFollow.x',-200)
		setProperty('camFollow.y',0)
	end,
	[1104] = function()
		setProperty('isCameraOnForcedPos',false)
	end,
	[1872] = function()
		--they took my nuts 
		for _,i in pairs(shit) do
            setProperty(i..'.visible',false)
        end
        setProperty("legacyCutscene.visible", true)
        playAnim("legacyCutscene", "speech", true)

		makeAnimatedLuaSprite('memories','isotope/memories',0,0)
		addAnimationByPrefix('memories','idle','memories idle',0,true)
		setObjectCamera('memories','hud')
		setObjectOrder('memories',0)
		scaleObject('memories',5,5)
		addLuaSprite('memories',false)
		setProperty('memories.antialiasing',false)
		setProperty('memories.alpha',1)
		playAnim('memories','idle',true)
		setBlendMode('memories','multiply')

		makeLuaSprite('cover','',0,0)
		setObjectCamera('cover','hud')
		setObjectOrder('cover',getObjectOrder('memories')+1)
		makeGraphic('cover',screenWidth,screenHeight,'000000')
		addLuaSprite('cover',false)
	
		doTweenX("slideToTheLeft", "legacyCutscene", 420, 9.5, "quadOut")
        doTweenAlpha("hey", "legacyCutscene", 1, 9, "quadOut")
		doTweenAlpha("ahshit", "cover", 0.5, 7, "quadOut")
		doTweenX('movemem','memories',-32,crochet*8/1000)
	end,
	[1888] = function()
		for i = 4,7 do
            noteTweenAlpha("NOTEgoBYE"..i , i, 0, 4, "quadInOut")
        end
	end,
	[1904] = function()
		setProperty('memories.x',0)
		doTweenY('movemem','memories',32,crochet*8/1000)
		playAnim('memories','idle',true,false,1)
	end,
	[1936] = function()
		setProperty('memories.x',-32)
		setProperty('memories.y',0)
		doTweenX('movemem','memories',0,crochet*8/1000)
		playAnim('memories','idle',true,false,2)
	end,
	[1968] = function()
		setProperty('memories.x',0)
		setProperty('memories.y',-32)
		doTweenY('movemem','memories',0,crochet*8/1000)
		playAnim('memories','idle',true,false,3)
	end,
	[1984] = function()
		setProperty('memories.visible',false)
	end,
	[2000] = function()
		removeLuaSprite('legacyCutscene',true)
		removeLuaSprite('memories',true)
		removeLuaSprite('cover',true)
		setProperty("camGame.visible", false)
	end,
	[2008] = function()
        setProperty("camGame.visible", true)
        for _,i in pairs(shit) do
            setProperty(i..'.visible',true)
        end
        for i = 4,7 do
            noteTweenAlpha("NOTEgoHI"..i , i, 0.8, (crochet/1000), "quadInOut")
        end
	end,
	[2520] = function()
		setProperty('camGame.visible',false)
		setProperty('camHUD.alpha',0.5)
		doTweenAlpha('hudgobye','camHUD',0,1,'quadOut')
	end,
}

function onStepHit()
	if stepstuff[curStep] then
		stepstuff[curStep]()
	end
end

function onBeatHit()
    if curBeat % 2== 0 and getProperty('dad.animation.curAnim.name') == 'idle' then
        playAnim('dad','idle',true)
    end
end
