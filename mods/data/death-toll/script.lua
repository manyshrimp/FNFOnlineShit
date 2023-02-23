local zoomAdd = 0
local yAdd = 0
local doStart = true

local contractStart = 0
local contractY = 0
local conpos = 0

local holdTimer = 0
local holdLimit = 0.15
local specialAnim = true
local suffix1 = ''

local singers = {
	dawn = {'',false}
}

local function rgbToHex(rgb) -- https://www.codegrepper.com/code-examples/lua/rgb+to+hex+lua
    return string.format('%02x%02x%02x', math.floor(rgb[1]), math.floor(rgb[2]), math.floor(rgb[3]))
end

local function lerp(a,b,c)
	return a+(b-a)*c
end

local function setZoom(a)
    local y = a*500
    if mustHitSection then
        setProperty('camFollow.y',getProperty('camFollow.y')+(y - yAdd))
    end
    setProperty('defaultCamZoom',getProperty('defaultCamZoom')+a-zoomAdd)
    zoomAdd = a
    yAdd = y
end

local dawnInit = {
    ['idle'] = {'Idle',0,0,48},
    ['singLEFT'] = {'Left',12,8},
    ['singDOWN'] = {'Down',4,-28},
    ['singUP'] = {'Up',-2,26},
    ['singRIGHT'] = {'Right',2,0},
    ['singLEFTmiss'] = {'Miss Left',14,8},
    ['singDOWNmiss'] = {'Miss Down',6,-32},
    ['singUPmiss'] = {'Miss Up',0,22},
    ['singRIGHTmiss'] = {'Miss Right',6,-2},
    ['trans'] = {'Trans',4,2},
    ['idle-cover'] = {'Cover Idle',0,0,48},
    ['singLEFT-cover'] = {'Cover Left',12,6},
    ['singDOWN-cover'] = {'Cover Down',6,-30},
    ['singUP-cover'] = {'Cover Up',-2,24}, 
    ['singRIGHT-cover'] = {'Cover Right',4,0},
    ['morph'] = {'Morph Change',12,0},
    ['idle-morphed'] = {'Morph Idle',0,-4,48},
    ['singLEFT-morphed'] = {'Morph Left',12,2},
    ['singDOWN-morphed'] = {'Morph Down',6,-34},
    ['singUP-morphed'] = {'Morph Up',-2,16},
    ['singRIGHT-morphed'] = {'Morph Right',2,-8}, 
    ['singLEFTmiss-morphed'] = {'Morph Miss Left',14,4},
    ['singDOWNmiss-morphed'] = {'Morph Miss Down',16,-38},
    ['singUPmiss-morphed'] = {'Morph Miss Up',8,14},
    ['singRIGHTmiss-morphed'] = {'Morph Miss Right',4,-10}
}

local bfInit = {
    ['idle'] = {'Idle',0,0,48},
    ['singLEFT'] = {'Left',24,10},
    ['singDOWN'] = {'Down',2,-12},
    ['singUP'] = {'Up',-6,24},
    ['singRIGHT'] = {'Right',-2,6},
    ['singLEFTmiss'] = {'Miss Left',22,10},
    ['singDOWNmiss'] = {'Miss Down',8,-12},
    ['singUPmiss'] = {'Miss Up',2,24},
    ['singRIGHTmiss'] = {'Miss Right',0,8},
    ['trans'] = {'Trans',8,0},
    ['idle-cover'] = {'Cover Idle',0,0,48},
    ['singLEFT-cover'] = {'Cover Left',24,8},
    ['singDOWN-cover'] = {'Cover Down',0,-12},
    ['singUP-cover'] = {'Cover Up',-6,22}, 
    ['singRIGHT-cover'] = {'Cover Right',0,6},
}

local bfcolor = {49,176,209}

local names = {}

function onCountdownStarted()
    setProperty('skipCountdown',true)
end

function onCreate()
	luaDebugMode = true
	precacheImage('icons/icon-bf')
    addCharacterToList('beelzescary')

	--[[makeAnimatedLuaSprite('dawnRef','characters/toll/DawnReal2',defaultBoyfriendX,defaultBoyfriendY,'tex')
    scaleObject('dawnRef',1.2,1.2)
    addAnimationByPrefix('dawnRef','idle','Idle',0,true)
    addOffset('dawnRef','idle',0,0)
    playAnim('dawnRef','idle')
    addLuaSprite('dawnRef',true)
    setProperty('dawnRef.alpha',0.5)
    ~~~~~~~~~~~This is just debug stuff
    --]]

    makeAnimatedLuaSprite('dawn','characters/toll/DawnReal',defaultBoyfriendX,defaultBoyfriendY,'tex')
    scaleObject('dawn',1.2,1.2)

    for i,v in pairs(dawnInit) do
        addAnimationByPrefix('dawn',i, v[1], v[4] or 24,false)
        addOffset('dawn',i,v[2],v[3])
        --table.insert(names,i)
    end

    playAnim('dawn','idle',true)
    addLuaSprite('dawn',true)

    makeAnimatedLuaSprite('fakebf','characters/toll/DawnBF',defaultBoyfriendX,defaultBoyfriendY+80,'tex')
    scaleObject('fakebf',1.2,1.2)

    for i,v in pairs(bfInit) do
        addAnimationByPrefix('fakebf',i, v[1], v[4] or 24,false)
        addOffset('fakebf',i,v[2],v[3])
        --table.insert(names,i)
    end

    playAnim('fakebf','idle',true)
	setProperty('fakebf.alpha',0)

    makeAnimatedLuaSprite('contract','hell/ContractBF',defaultOpponentX - 232, defaultOpponentY + 113)
    addAnimationByPrefix('contract','idle', 'ContractIdle', 24, false)
	addAnimationByPrefix('contract','1', 'Contract_BF_01', 24, false)
	addAnimationByPrefix('contract','2', 'Contract_BF_02', 24, false)
	addAnimationByPrefix('contract','3', 'Contract_BF_03', 24, false)
	addAnimationByPrefix('contract','4', 'Contract_BF_04', 24, false)
	addAnimationByPrefix('contract','5', 'Contract_BF_05', 24, false)
	addAnimationByPrefix('contract','6', 'Contract_BF_06', 24, false)
	addAnimationByPrefix('contract','7', 'Contract_BF_07', 24, false)
	addAnimationByPrefix('contract','8', 'Contract_BF_08', 24, false)
	addAnimationByPrefix('contract','9', 'Contract_BF_09', 24, false)
    playAnim('contract','idle')
    addLuaSprite('contract',true)
    setProperty('contract.visible',false)
    contractY = getProperty('contract.y')

    makeLuaSprite('flash','',-screenWidth,-screenHeight)
    makeGraphic('flash',screenWidth*3,screenHeight*3,'ffffff')
    setScrollFactor('flash',0,0)
    scaleObject('flash',2,2)
    addLuaSprite('flash',true)
    setProperty('flash.alpha',0)
end

local baseAnim = {'singLEFT','singDOWN','singUP','singRIGHT'}

function onBeatHit()
	for ch,props in pairs(singers) do
		if getProperty(ch..'.animation.curAnim.finished') and holdTimer > holdLimit then
			playAnim(ch,'idle'..props[1],true,false,(props[1] == '-cover' and 2 or 0))
		end
	end
end

function goodNoteHit(id,data,type,sustain)
	holdTimer = 0
	for ch,props in pairs(singers) do
		if not props[2] or (props[2] and getProperty(ch..'.animation.curAnim.finished')) then
			if props[2] then props[2] = false end
			playAnim(ch,baseAnim[data+1]..props[1],true)
		end
	end
end

function noteMiss(id,data,type,sustain)
	for ch,props in pairs(singers) do
		if not props[2] then
			playAnim(ch,baseAnim[data+1]..'miss'..props[1],true)
		end
	end
end

function bellHit(id)
	for ch,props in pairs(singers) do
		if props[1] ~= '-morphed' then
			if (holdTimer > holdLimit or getProperty(ch..'.animation.curAnim.finished')) and props[1] ~= '-cover' then
				playAnim(ch,'trans',false)
				props[2] = true
			end
			props[1] = '-cover'
			runTimer('dawnCover',1)
		end
	end
end

function onMoveCamera(char)
    if char == 'dad' then
        setProperty('defaultCamZoom',0.65+0.12+zoomAdd)
    else
        setProperty('camFollow.y',getProperty('camFollow.y')+yAdd)
        setProperty('defaultCamZoom',0.65+zoomAdd)
    end
end

local prog = 0

function onUpdatePost(elapsed)
	if dadName == 'beelze' then
		setProperty('iconP2.animation.curAnim.curFrame',0)
	end
    if contractStart > 0 and conpos < 11 then
        setProperty('contract.y',contractY+math.sin((getSongPosition()-contractStart)/crochet/8*math.pi)*16)
		prog = lerp(prog,math.min((conpos*conpos)/100,1),0.1)
		local prog2 = prog+math.sin((getSongPosition()/crochet/4)*math.pi) *(prog*0.25)
		setProperty('dawn.alpha',1-prog2)
		setProperty('fakebf.alpha',prog2)

		setProperty('fakeIcon.alpha',prog2)
		setProperty('iconP1.alpha',1-prog2)
		setProperty('fakeIcon.x',getProperty('iconP1.x'))
		scaleObject('fakeIcon',getProperty('iconP1.scale.x'),getProperty('iconP1.scale.y'))

		local cap = math.min(prog2,1)
		setHealthBarColors('7e5d91',rgbToHex({lerp(255,49,cap),lerp(255,176,cap),lerp(255,209,cap)}))

		if getHealth() < 0.2 then
			setProperty('fakeIcon.animation.curAnim.curFrame',1)
		else
			setProperty('fakeIcon.animation.curAnim.curFrame',0)
		end
    end
    if holdTimer <= holdLimit then
        holdTimer = holdTimer + elapsed
    end
end

local cases = {
    [240] = function()
        setZoom(0.08)
        runTimer('flash1',(stepCrochet/1000)*8)
        debugPrint('1')
        if flashingLights then
            setProperty('flash.alpha',0.6)
            doTweenAlpha('flashHide','flash',0,0.5,'linear')
        end
    end,
    [1254] = function()
        debugPrint('walk')
        setProperty('dad.skipDance',true)
        triggerEvent('Play Animation','walk','dad')
        runTimer('walk',1.07)
    end,
    [1264] = function()
        setZoom(0.35)
    end,
    [1280] = function()
        setZoom(0.45)
    end,
    [1292] = function()
        doTweenZoom('camZoom','camGame',0.77,(stepCrochet*4/1000),'circIn')
    end,
    [1296] = function()
        setZoom(0)
        setProperty('dad.skipDance',false)
        triggerEvent('Change Character','dad','beelzescary')
        setProperty('dad.x',defaultOpponentX-100)
        setProperty('dad.y',defaultOpponentY-20)
        setProperty('contract.visible',true)
        contractStart = getSongPosition()

		makeAnimatedLuaSprite('fakeIcon','',0,getProperty('iconP1.y'))
		loadGraphic('fakeIcon','icons/icon-bf',150,150)
		setObjectCamera('fakeIcon','hud')
		setProperty('fakeIcon.flipX',true)
		addAnimation('fakeIcon','idle',{0,1},0,true)
		playAnim('fakeIcon','idle')
		addLuaSprite('fakeIcon',true)

		singers.fakebf = {'',false}
		addLuaSprite('fakebf',true)
    end,
	[1552] = function()
		singers.dawn[1] = '-morphed'
		singers.dawn[2] = true
		playAnim('dawn','morph',true)
	end,
	[1808] = function()
		--dawn is fucking dead yall
		singers.dawn = nil
		conpos = 11
		setProperty('fakebf.alpha',1)
		setProperty('iconP1.alpha',1)
		removeLuaSprite('dawn',true)
		removeLuaSprite('fakeIcon',true)
		setHealthBarColors('7e5d91','31b0d1')

		runHaxeCode([[
			game.iconP1.changeIcon("bf");
		]])

	end,
    [2256] = function()
        setZoom(0.05)
    end,
    [2272] = function()
        setZoom(0.1)
    end,
    [2288] = function()
        setZoom(0.15)
    end,
    [2304] = function()
        setZoom(0.25)
    end,
    [2336] = function()
        setZoom(0)
    end
}

function onStepHit()
    if cases[curStep] ~= nil then cases[curStep]() end
end

function onEvent(name,v1,v2)
    if name == 'Contract Advance' then
        conpos = conpos + 1
        if conpos == 10 then
            doTweenColor('contractColor','contract','f51119',0.5,'circOut')
            doTweenX('oops1','contract.scale',0.3,1.3,'backIn')
            doTweenY('oops2','contract.scale',0.3,1.3,'backIn')
            doTweenAlpha('oops3','contract',0,1.3,'backIn')
        else
            playAnim('contract',tostring(conpos),true)
        end
    end
end

local morecases = {
    ['walk'] = function()
        triggerEvent('Play Animation','laugh','dad')
    end,
    ['flash1'] = function()
        debugPrint('2')
        runTimer('flash2',(stepCrochet/1000)*8)
        setZoom(0.16)
        if flashingLights then
            setProperty('flash.alpha',0.7)
            doTweenAlpha('flashHide','flash',0,0.7,'linear')
        end
    end,
    ['flash2'] = function()
        debugPrint('3')
        setZoom(0)
        if flashingLights then
            setProperty('flash.alpha',1)
            doTweenAlpha('flashHide','flash',0,1.5,'linear')
        end
    end,
    ['dawnCover'] = function()
		for ch,props in pairs(singers) do
			if props[1] == '-cover' then
				props[1] = ''
			end
		end
    end,
}

function onTimerCompleted(tag)
    if morecases[tag] ~= nil then morecases[tag]() end
end


--[[function onCreatePost()
    setProperty('isCameraOnForcedPos',true)
    setProperty('camFollow.x',850)
    setProperty('camFollow.y',1150)
end

local daObject = 'fakebf'
local Incr = 2
local curpick = 1
local thisx = 0
local thisy = 0

function onUpdate(elapsed)
    setProperty(daObject..'.offset.x',thisx)
    setProperty(daObject..'.offset.y',thisy)
	if keyboardJustPressed('A') then
        thisx = thisx - Incr
    elseif keyboardJustPressed('D') then
    	thisx = thisx + Incr
    elseif keyboardJustPressed('W') then
    	thisy = thisy - Incr
    elseif keyboardJustPressed('S') then
    	thisy = thisy + Incr
    elseif keyJustPressed('space') then
     	debugPrint(thisx..", ".. thisy,' curAnim: '.. (names[curpick] or 'unknown'))
        addOffset(daObject,names[curpick],thix,thisy)
        playAnim(daObject,names[curpick],true)
    elseif keyboardJustPressed('Q') or keyboardJustPressed('E') then
        if keyboardJustPressed('Q') then
            curpick = curpick - 1
        else
            curpick = curpick + 1
        end
        debugPrint(names[curpick])
        playAnim(daObject,names[curpick])
        thisx = getProperty(daObject..'.offset.x')
        thisy = getProperty(daObject..'.offset.y')
    end
end
--]]