local fellas = {
    ['Chansey'] = {''}
}

local drain = 0.023*0.75

function onCreate()
    makeAnimatedLuaSprite('dastare','pokecenter/intro/Purinsoulstare',530,600)
    scaleObject('dastare',1.2,1.2)
    addAnimationByPrefix('dastare','idle','Jigglypuff bg',24,true)
    playAnim('dastare','idle')
    addLuaSprite('dastare',false)
    setObjectOrder('dastare',getObjectOrder('fog')-1)

    --[[local c = 0
    for i,v in pairs(fellas) do
        makeAnimatedLuaSprite('fella'..c,i,)
        c = c + 1
    end--]]

    setProperty('isCameraOnForcedPos',true)
    setProperty('camFollow.x',600)

    makeLuaSprite('black','',-screenWidth,-screenHeight)
    makeGraphic('black',screenWidth*3,screenHeight*3,'000000')
    addLuaSprite('black',true)

    addCharacterToList('purinturn')
end

function onCountdownStarted()
    setProperty('skipCountdown',true)
end

local picoanims = {
    ['idle0'] = {'PICO WHAT',true,0,0},
    ['turn0'] = {'PICO CHILL0',false,4,6},
    ['idle1'] = {'PICO CHILL IDLE',true,3,-3},
    ['turn1'] = {'PICO CHILLturnback0',false,3,1},
    ['idle2'] = {'PICO CHILLturnback idle',true,-1,1},
    ['knife'] = {'PICO CHILL knife',false,14,6},
}

function onCreatePost()
    setProperty('dad.visible',false)
    setProperty('boyfriend.visible',false)

    setProperty('backlayer.color',getColorFromHex('000000'))
    setProperty('hang.color',getColorFromHex('000000'))

    makeAnimatedLuaSprite('picointro','characters/purin/pico_purin_intro',780,380)
    for i,v in pairs(picoanims) do
        addAnimationByPrefix('picointro',i,v[1],24,v[2])
        addOffset('picointro',i,v[3],v[4])
    end
    playAnim('picointro','idle0')
    addLuaSprite('picointro',false)
end

local cases = {
    [16] = function()
        doTweenAlpha('fadein','black',0,crochet*6/1000,'quadInOut')
    end,
    [64] = function()
        doTweenAlpha('heappear','fog',0.4,crochet*3/1000,'quadOut')
    end,
    [70] = function()
        --turn
        playAnim('picointro','turn0')
        runTimer('idle1',0.75)
    end,
    [80] = function()
        runHaxeCode([[
            FlxTween.tween(game, {defaultCamZoom: 1.2}, (Conductor.crochet*32)/1000, {easeType: FlxEase.quadInOut});
        ]])
        --first guy appear
    end,
    [144] = function()
        doTweenColor('ohdamn','backlayer','ffffff',crochet/1000,'circOut')
        doTweenColor('ohdamn2','hang','ffffff',crochet/1000,'circOut')
    end,
    [192] = function()
        doTweenAlpha('fadeout','black',1,crochet*4/1000,'cubicInOut')
    end,
    [216] = function()
        setProperty('dad.visible',true)
        removeLuaSprite('dastare',true)
        doTweenAlpha('fadein','black',0,crochet*6/1000,'quadIn')
    end,
    [236] = function()
        --playAnim('boyfriend','turn',true,true)
        playAnim('picointro','turn1')
        runTimer('idle2',0.42)
        setProperty('isCameraOnForcedPos',false)
    end,
    [364] = function()
        --playAnim('boyfriend','knife',true)
        playAnim('picointro','knife')
    end,
    [368] = function()
        setProperty('boyfriend.visible',true)
        removeLuaSprite('picointro',true)
        --playAnim('boyfriend','idle',true)
    end,
    [1192] = function()
        setProperty('isCameraOnForcedPos',true)
        setProperty('camFollow.x',250)
        setProperty('camFollow.y',650)
        setProperty('defaultCamZoom',1.2)
        drain = 0
    end,
}

local timers = {
    ['idle1'] = function()
        playAnim('picointro','idle1')
    end,
    ['idle2'] = function()
        playAnim('picointro','idle2')
    end,
}

function onTimerCompleted(tag)
    if timers[tag] ~= nil then timers[tag]() end
end

function onStepHit()
    if cases[curStep] ~= nil then cases[curStep]() end
end

function opponentNoteHit()
    setHealth(math.max(getHealth()-drain,0.01))
end