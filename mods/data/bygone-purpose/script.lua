local targetY = 432
local campos = {961,432}

local function lerp(a,b,c) return a + (b-a) * c end

function onCreate()
    luaDebugMode = true

    makeLuaSprite('NOOO','bygone/AlexisTransition',0,0)
	setObjectCamera('NOOO','other')
	scaleObject('NOOO',0.95,0.95)
	screenCenter('NOOO')
	addLuaSprite('NOOO',true)
	setProperty('NOOO.alpha',0)
    addCharacterToList('alexis')

    makeAnimatedLuaSprite('alexisDead','bygone/GGirl Alexis Passing Spritesheet',1189,-188)
    addAnimationByPrefix('alexisDead','die','GGirl Passing',24,false)
    addLuaSprite('alexisDead',true)
    setProperty('alexisDead.visible',false)

    makeAnimatedLuaSprite('alexisGate','bygone/Heavens Gate',1148,-195)
    addAnimationByPrefix('alexisGate','open','Open',24,false)
    addAnimationByPrefix('alexisGate','close','Close',24,false)
    addLuaSprite('alexisGate',true)
    setProperty('alexisGate.alpha',0)

    makeAnimatedLuaSprite('fakeIcon','icons/icon-smallhypno',0,0)
    setObjectCamera('fakeIcon','hud')
    setProperty('fakeIcon.flipX',true)
    addAnimationByPrefix('fakeIcon','win','win',0,true)
    addAnimationByPrefix('fakeIcon','lose','lose',24,true)
    addLuaSprite('fakeIcon',true)
    playAnim('fakeIcon','win',false)

    makeLuaSprite('sunrise','',-screenWidth,-screenHeight)
    makeGraphic('sunrise',screenWidth*3,screenHeight*3,'ff641c')
    setBlendMode('sunrise','overlay')
    setProperty('sunrise.blend',9)
    addLuaSprite('sunrise',true)
    setProperty('sunrise.alpha',0)

    local mults = {
        [1] = {1.1,0.9,1.2,0.8},
        [2] = {1,1.2,1.3,0.9}
    }

    for i = 0,getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes',i,'mustPress') then
            local step = getPropertyFromGroup('unspawnNotes',i,'strumTime')/stepCrochet
            setPropertyFromGroup('unspawnNotes',i,'multSpeed',mults[step > 632 and 2 or 1][getPropertyFromGroup('unspawnNotes',i,'noteData')+1])
        end
    end
end

function onUpdateScore()
    if getHealth() < 0.2 then
        playAnim('fakeIcon','lose',false)
    else
        playAnim('fakeIcon','win',false)
    end
end

function onCreatePost()
    setProperty('camFollowPos.x',campos[1])
	setProperty('camFollowPos.y',campos[2])
    setHealthBarColors('000000','FFFF5B')
    setProperty('iconP1.visible',false)
    setProperty('iconP2.visible',false)

    setProperty('fakeIcon.y',getProperty('healthBar.y')-50)
end

function onMoveCamera(who)
	setProperty('camFollow.x',campos[1])
	setProperty('camFollow.y',campos[2])
end

function onCountdownStarted()
    setProperty('skipCountdown',true)
end

function onUpdatePost()
    campos[2] = lerp(campos[2],targetY,0.005)
    local diff = (targetY-campos[2])*0.005
    if diff > 0 then
        setProperty('camFollow.y',getProperty('camFollow.y')+diff)
    end

    if not hideHud then
		setProperty('fakeIcon.x',getProperty('iconP1.x'))
		scaleObject('fakeIcon',getProperty('iconP1.scale.x'),getProperty('iconP1.scale.y'))
	end
end

local cases = {
    [588] = function()
        doTweenAlpha('WAAAH','NOOO',1,stepCrochet*32/1000,'quadInOut')
        setProperty('camFollow.y',campos[2])
    end,
    [632] = function()
        ---transition
        doTweenAlpha('sadface','NOOO',0,stepCrochet*48/1000)

        setProperty('bigHypno.visible',true)
        setProperty('boyfriend.alpha',0)
        triggerEvent('Change Character','BF','alexis')
        setProperty('boyfriendGroup.x',1150)
        setProperty('boyfriendGroup.y',100)
        for i,v in ipairs({'bg1','skyline1','rope1','bridge1'}) do
            doTweenAlpha('fadeout'..i,v,0,stepCrochet*48/1000,'quadInOut')
        end
        for i,v in ipairs({'bg2','skyline2','rope2','bridge2'}) do
            doTweenAlpha('fadein'..i,v,1,stepCrochet*48/1000,'quadInOut')
        end
        setHealthBarColors('000000','2A2A58')
        setProperty('iconP1.visible',true)
        setProperty('fakeIcon.visible',false)
    end,
    [716] = function()
        doTweenAlpha('summon','boyfriend',1,stepCrochet*8/1000,'quadOut')
    end,
    [720] = function()
        targetY = 360
    end,
    [848] = function()
        doTweenAlpha('rainFade','rain',0.6,crochet*12/1000,'quadOut')
        doTweenAlpha('rainFade2','bgrain',0.9,crochet*12/1000,'quadOut')
    end,
    [1104] = function()
        doTweenAlpha('sunrise','sunrise',0.5,crochet*32/1000)
    end,
    [1236] = function()
        doTweenAlpha('gateFade','alexisGate',1,1,'quadOut')
        playAnim('alexisGate','open',true)
        setProperty('alexisDead.visible',true)
        playAnim('alexisDead','die',true)
        setProperty('boyfriendGroup.visible',false)
        runTimer('alexisGone',1.125)
    end,
}

function onStepHit()
    if cases[curStep] ~= nil then cases[curStep]() end
end 

function onBeatHit()
    if boyfriendName == 'smol-hypno' and getProperty('boyfriend.animation.curAnim.name') == 'idle' then
        playAnim('boyfriend','idle',true)
    end
end

function onTimerCompleted(tag)
    if tag == 'alexisGone' then
        setProperty('alexisDead.visible',false)
        playAnim('alexisGate','close',true)
        doTweenAlpha('gateGone','alexisGate',0,0.83,'quadOut')
    end
end