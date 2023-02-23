local bgsprites = {
    'bg',
    'bgport',
    'lacama',
    'laalmueda'
}

local visions = false
local shake = false
local strangled = false

local pulsel = 0.25
local pulseb = 0
local ouch = 0

local function makeColor(tag,color,a)
    makeLuaSprite(tag,'',-screenWidth,-screenHeight)
    makeGraphic(tag,screenWidth*3,screenHeight*3,color)
    screenCenter(tag)
    setScrollFactor(tag,0,0)
    setBlendMode(tag,'overlay')
	setProperty(tag..'.blend',9)
    setProperty(tag..'.alpha',a)
    addLuaSprite(tag,true)
end

function onCountdownStarted()
    setProperty('skipCountdown',true)
end

function onCreate()
    luaDebugMode = true

    addCharacterToList('steven-bed')
    addCharacterToList('mike-fp')
    addCharacterToList('steven-front')
    
    makeColor('blu','111970',0.6)
    makeColor('evilblu','ff0000',0)

    for _,i in pairs(bgsprites) do
        setProperty(i..'.visible',false)
    end

    --strangled scene
    makeAnimatedLuaSprite('steven','characters/strangled/steven_phase_2',720,1320)
    addAnimationByPrefix('steven','idle','SR IDLE',24,false)
    addAnimationByPrefix('steven','left','SR LEFT',24,false)
    addAnimationByPrefix('steven','down','SR DOWN',24,false)
    addAnimationByPrefix('steven','up','SR UP',24,false)
    addAnimationByPrefix('steven','right','SR RIGHT',24,false)
    addOffset('steven','idle')
    addOffset('steven','left',82,-21)
    addOffset('steven','down',13,-108)
    addOffset('steven','up',11,40)
    addOffset('steven','right',-28,-30)

    makeLuaSprite('redoverlay','mikes-room/redoverlay',0,0)
    setObjectCamera('redoverlay','other')
    setProperty('redoverlay.alpha',0.04)
    addLuaSprite('redoverlay',true)

    precacheImage('icons/icon-steven-evil')
end

function onCreatePost()

    local camPos = {377.25,363}

    setProperty('camFollow.x',camPos[1])
    setProperty('camFollow.y',camPos[2])
    setProperty('camFollowPos.x',camPos[1])
    setProperty('camFollowPos.y',camPos[2])
end

local shit = {
    'camGame',
    'newBar',
    'healthBar',
    'newBG',
    'iconP1',
    'iconP2'
}

local stepcase = {
    [128] = function()
        --unhide stage
        for _,i in pairs(bgsprites) do
            setProperty(i..'.visible',true)
        end
        triggerEvent('Change Character','dad','steven-bed')
        setScrollFactor('dad',0.8,0.8)

        local camPos = {490.5,519}
        
        setProperty('camFollow.x',camPos[1])
        setProperty('camFollow.y',camPos[2])
        setProperty('camFollowPos.x',camPos[1])
        setProperty('camFollowPos.y',camPos[2])
        setProperty('camGame.zoom',2.5)
    end,
    [392] = function()
        doTweenAlpha('evilFade','evilblu',0.5,8*(stepCrochet/1000),'circIn')
    end,
    [400] = function()
        --go wacky
        setProperty('evilblu.alpha',0.15)
        for _,i in pairs(bgsprites) do
            setProperty(i..'.visible',false)
        end
        visions = true

        setProperty('camGame.visible',true)
        triggerEvent('Change Character','dad','steven-front')
        triggerEvent('Change Character','bf','mike-fp')

        setProperty('boyfriend.x',945)
        setProperty('boyfriend.y',945-400)
        setProperty('dad.x',275)
        setProperty('dad.y',1325+400)
        setProperty('dad.alpha',0)
        setProperty('boyfriend.alpha',0)
        doTweenY('higuys-mike','boyfriend',945,6,'quadOut')
        doTweenY('higuys-steven','dad',1325,6,'quadOut')
        doTweenAlpha('heyguys-mike','boyfriend',1,6,'quadOut')
        doTweenAlpha('heyguys-steven','dad',1,6,'quadOut')

        local camPos = {990,1560}

        setProperty('camFollow.x',camPos[1])
        setProperty('camFollow.y',camPos[2])
        setProperty('camFollowPos.x',camPos[1])
        setProperty('camFollowPos.y',camPos[2])
        setProperty('defaultCamZoom',1)

        setProperty('isCameraOnForcedPos',true)
    end,
    [904] = function()
        --Goodbye.
        removeLuaSprite('blu',false)
        for _,i in pairs(shit) do
            setProperty(i..'.visible',false)
        end

        addLuaSprite('steven',true)

        playAnim('steven','idle')

        runHaxeCode('game.iconP2.changeIcon("steven-evil");')
    end,
    [912] = function()
        --appears
        strangled = true
        shake = true
        for _,i in pairs(shit) do
            setProperty(i..'.visible',true)
        end
        setProperty('redoverlay.alpha',0.7)
        setProperty('dad.alpha',0.45)
        setProperty('boyfriend.alpha',0.45)
        pulseb = 0.15
        pulsel = 0.5
    end,
    [1440] = function()
        --yikes
        visions = false
        shake = false
        setProperty('redoverlay.alpha',1)
        setProperty('evilblu.alpha',1)
        addLuaSprite('blu',true)
        setProperty('blu.alpha',0)
        doTweenAlpha('itsover1','evilblu',0,3,'quadInOut')
        doTweenAlpha('itsover2','blu',0.7,3,'quadInOut')
        doTweenAlpha('itsover3','redoverlay',0,1,'quadOut')
        doTweenAlpha('byeguys-steven','dad',0,2,'quadIn')
        doTweenAlpha('byeguys-mike','boyfriend',0,2.5,'quadIn')
        doTweenY('imdead-mike','boyfriend',945-400,2,'quadIn')

        for i = 0,3 do
            setPropertyFromGroup('playerStrums',i,'x',_G['defaultPlayerStrumX'..i])
            setPropertyFromGroup('playerStrums',i,'y',_G['defaultPlayerStrumY'..i])
        end

        doTweenZoom('zoomout','camGame',0.7,4,'quadIn')
    end,
    [1468] = function()
        setProperty('camGame.visible',false)
        setProperty('camHUD.visible',false)
    end,
}

function onStepHit()
    if stepcase[curStep] then stepcase[curStep]() end
end

function onEvent(name,v1,v2)
    if name == 'Dissension Flash' and flashingLights then
        setProperty('evilblu.alpha',0.4)
        doTweenAlpha('evilflash','evilblu',0,0.5,'quadOut')
    end
end

local anims = {
    'left',
    'down',
    'up',
    'right'
}

function opponentNoteHit(id,data,type,sustain)
    if strangled then
        playAnim('steven',anims[data+1],true)
    end
end

function onBeatHit()
    if strangled and getProperty('steven.animation.curAnim.finished') and not (getProperty('steven.animation.curAnim.name') == 'idle' and not visions) then
        playAnim('steven','idle',true)
    end
end

function onUpdate(elapsed)
    if visions then
        setProperty('evilblu.alpha',math.sin(curDecBeat/2*math.pi)*pulsel/2+pulsel/2+pulseb)
    end
    if strangled then
        if getHealth() > 0.395 then
            addHealth(-0.002*elapsed*80)
        end
    end
end

function onUpdatePost(elapsed)
    if strangled then
        for i = 0,getProperty('notes.length') do
            if getPropertyFromGroup('notes',i,'mustPress') then
                local wiggle = (getPropertyFromGroup('notes',i,'strumTime')-getSongPosition())/40
                setPropertyFromGroup('notes',i,'x',getPropertyFromGroup('notes',i,'x')+math.sin(wiggle)*10)
                if getPropertyFromGroup('notes',i,'isSustainNote') then
                    setPropertyFromGroup('notes',i,'angle',getPropertyFromGroup('notes',i,'angle')+math.rad(math.sin(wiggle)*30))
                end
            end
        end
    end
    if shake then
        ouch = (getSongPosition()-(226*crochet))/(crochet*134)
        for i = 0,3 do
            setPropertyFromGroup('playerStrums',i,'x',_G['defaultPlayerStrumX'..i]+math.random(-10,10)*ouch)
            setPropertyFromGroup('playerStrums',i,'y',_G['defaultPlayerStrumY'..i]+math.random(-10,10)*ouch)
        end
    end
end