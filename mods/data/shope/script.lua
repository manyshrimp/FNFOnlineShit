
local Box
local Group
local Alphabet

local mainbox
local subbox
local shopGroup
local freeGroup

local shopTitle

local canControl = true
local inShop = true
local inFree = false
local canPick = true
local shopPick = 1
local freePick = 1
local freeCooldown = 0

local enteringSong = false

local realCrochet = 60/166
local realBeat = 0
local realTime = 0

local boxPos1 = 0
local boxPos2 = 0

local listx = 0

local cgIdle = 0

local fadein = ''
local fadeout = ''

local function lerp(a, b, t)
    return a+(b-a)*t
end

local function clamp(num,a,b) --a is less, b is more
    local temp = b 
    b = a > b and a or b
    a = a > temp and temp or a
    return num < a and a or num > b and b or num
end

local function what(str)
    local final = ''
    for i = 1,#str do
        local letter = str:sub(i,i)
        if string.match(letter, '%a') then
            final = final .. '?'
        else
            final = final .. letter
        end
    end
    return final
end

local lockedShit = {}

local freeButtons = {}

local freeStuff = {'blank','unknown'}
local shopStuff = {'cg','candle','maintext','choices','epicArrow','shope','headerbg','buyBox'}

local shopItems = {
    [1] = {
        desc = 'Oh now you want it? Make up your mind, you freak.',
        song = ''
    },
    [2] = {
        desc = 'Stupid thing does nothing but make annoying noises. Fuckin\' take it.',
        song = 'isotope'
    },
    [3] = {
        desc = 'Looks ordinary, no?',
        song = 'dissension'
    },
    [4] = {
        desc = 'The fire won\'t go out, no matter what you do.',
        song = 'purin'
    },
    [5] = {
        desc = 'This envelope has your name on it.',
        song = 'death-toll'
    },
    [6] = {
        desc = 'She can\'t sing...',
        song = 'amusia'
    },
    [7] = {
        desc = 'Even monsters sometimes need some time to relax.',
        song = 'pasta-night'
    },
    [8] = {
        desc = 'Dont feel bad for him. Bastard doesnt deserve an ounce of symphathy.',
        song = 'bygone-purpose'
    },
    [9] = {
        desc = 'I don\'t want this... But it\'s funny to make you pay for it.',
        song = 'shinto'
    }
    
}

local portOffsets = {
    [1] = {164,98},
    [2] = {96,81},
    [3] = {54.5,54.5},
    [4] = {80,63},
    [5] = {56,63},
    [6] = {55,63},
    [7] = {66,63},
    [8] = {55,120},
    [9] = {56.5,63.5},
    [10] = {55.5,63},
    [11] = {55.5,63},
    [12] = {231,102},
    [13] = {66.5,66},
    [14] = {56.5,63},
    [15] = {55.5,63},
    [16] = {55.5,63},
    [17] = {135.5,108.5}
}

local freeSongs = {
    'Safety-Lullaby', 'Left-Unchecked', 'Lost-Cause', 
    'Frostbite', 'Insomnia', 'Monochrome',
    'Missingno', 'Brimstone',
    'Amusia','Bygone-Purpose', 'Death-Toll', 'Dissension', 'Isotope', 'Pasta-Night', 'Purin', 'Shinto', 'Shitno'
}

local cgNum = -1
local cgLine = 'Hi.'
local cgProg = 0

local cgDict = {
        idleLines = {
            "Don't worry, I got eternity. Can you say the same?",
            "Your nose is weird.",
            "You're ugly.",
            "Ever heard of NFTs? The suits are really out of line nowadays, huh?",
            "Pokemon? I just sell shitty games to snot riddled twerps like you. I don't play them.",
            "Be glad I'm in a good mood today. Normally I just steal shit.",
            "Is it fun just sitting there like the fat lard you are?",
            "Don't sympathize with evil. Understanding it may be of use, however.",
            "Speaking ill of another man's hat is dishonorable. Yes, even the red man's.",
            "Sorry, I don't rap. Try your luck on someone else.",
            "No, you can't drink from my head. I know you see the handle but I'm not a mug.",
            "My outfit isn't \"suspicious\", it's called class. Have any?",
        },
        hellLines = {
            "Interesting.",
            "Nice knowing you bub, say hi to my mom when you're dead.",
            "I'd say you got this, but you probably don't.",
            "Ha ha... this should be fun to watch.",
            "Good luck.",
            "I hope you know what you're getting into."
        },
        poorLines = {
            "Come back with more green, chump.",
            "You tryna rip me off here, buddy?",
            "Count your money again, dipshit.",
            "This ain't a charity, pal.",
            "I'm trying to run a business here.",
            "You're joking, right?"
        }
}

local speakDel = 0.05
local speakDel2 = {
    [','] = 0.2,
    ['.'] = 0.3,
    ['?'] = 0.3,
    ['"'] = 0.15
}

local function speakLol()
    if cgProg<#cgLine then
        cgProg = cgProg + 1
        setTextString('maintext',string.sub(cgLine,1,cgProg))
        playSound('cgSpeak',0.1)
        runTimer('cgSpeak',speakDel2[string.sub(cgLine,cgProg,cgProg)] or speakDel)
    end
end

local function updateDialogue(str)
    local curLines = 'idleLines'
    if str == nil then
        local temp = cgNum
        while cgNum == temp do
            cgNum = math.floor(math.random(1,#cgDict[curLines]+1))
        end
        cgLine = cgDict[curLines][cgNum]
    else
        cgLine = str
    end
    
    cgProg = 1
    speakLol()
end

local function freeSelect(num)
    fadeout = 'unknown'
    if luaSpriteExists('port-'..freePick) then
        fadeout = 'port-'..freePick
    end

    freePick = freePick + num
    if freePick < 1 then
        freePick = #freeButtons+freePick
    elseif freePick > #freeButtons then
        freePick = freePick % #freeButtons
    end

    fadein = 'unknown'

    if luaSpriteExists('port-'..freePick) then
        fadein = 'port-'..freePick
        playAnim(fadein,'idle',true)
    end

    if fadein ~= fadeout or num == 0 then
        doTweenAlpha('fade-'..fadeout,fadeout,0,0.3,'quadInOut')
        doTweenAlpha('fade-'..fadein,fadein,1,0.3,'quadInOut')
    end

    if num ~= 0 then
        playSound('scrollMenu')
    end
end

local function switchState(free)
    if free then
        inShop = false
        inFree = true
        freeSelect(0)
    else
        inFree = false

        playAnim('shope','swing',true)
        cgIdle = math.floor(math.random(1,4))
        local frame = getProperty('cg.animation.curAnim.curFrame')
        playAnim('cg','idle-'..cgIdle,true,false,frame)

        updateDialogue()
    end
end

function onCreate()
    luaDebugMode = true

    initSaveData('hypnoProgress')

    addHaxeLibrary("FlxG", "flixel")
    addHaxeLibrary('FlxSpriteGroup','flixel.group.FlxSpriteGroup')

    runHaxeCode([[
        FlxG.cameras.remove(game.camOther, false);

        camMenu = new FlxCamera();
        camMenu.bgColor = 0xff;

        FlxG.cameras.add(camMenu,false);

        game.variables.set('camMenu',camMenu);

        FlxG.cameras.add(game.camOther, false);
    ]])
    
    --SHOP MENU
    makeAnimatedLuaSprite('cg','UI/menus/shop/CGShop_assets',0,0)
    scaleObject('cg',1.375,1.375)
    setProperty('cg.y',screenHeight-getProperty('cg.height'))
    for i = 1,3 do
        addAnimationByPrefix('cg','idle-'..i,'CG_Idle0'..i..'0',24,true)
        addAnimationByPrefix('cg','idle-'..i..'-alt','CG_Idle0'..i..'_Alt0',24,true)
    end

    math.randomseed(os.time())
    cgIdle = math.floor(math.random(1,4))
    playAnim('cg','idle-'..cgIdle,true)
    addLuaSprite('cg',true)

    makeLuaSprite('candle','UI/menus/shop/CandleLight',67-187,getProperty('cg.y')+514-186)
    addLuaSprite('candle',true)

    Box = dofile('mods/'..currentModDirectory..'/scripts/class/Box.lua')
    Group = dofile('mods/'..currentModDirectory..'/scripts/class/Group.lua')
    Alphabet = dofile('mods/'..currentModDirectory..'/scripts/class/Alphabet.lua')

    local space = 10*9
    mainbox = Box:new('mainbox','',0,0,24*9,4*9,3,3)
    subbox = Box:new('subbox','',0,0,5*9,6*9,3,3)
    local totalWidth = mainbox:getWidth()+space+subbox:getWidth()
    mainbox:setPosition(screenWidth/2-totalWidth/2,screenHeight-(screenHeight/5+36))
    subbox:setPosition(screenWidth/2+totalWidth/2-subbox:getWidth(),mainbox.y-(subbox:getHeight()-mainbox:getHeight()))
    mainbox:setCamera('camMenu')
    subbox:setCamera('camMenu')

    boxPos1 = mainbox.x
    boxPos2 = subbox.x
    makeLuaText('maintext','fuck shit piss ass cum semen boobies dick butt poop fart funny silly dick penis balls testicles',mainbox.width*3,mainbox.x+9*3,mainbox.y+9*3)
    setTextAlignment('maintext','left')
    setTextFont('maintext','poketext.ttf')
    setTextColor('maintext','000000')
    setTextBorder('maintext',0)
    setTextSize('maintext',24)
    setProperty('maintext.antialiasing',false)
    addLuaText('maintext')

    makeLuaText('choices','BUY\nSELL\nEXIT',0,subbox.x+9*6,subbox.y+9*6)
    setTextAlignment('choices','left')
    setTextFont('choices','poketext.ttf')
    setTextColor('choices','000000')
    setTextBorder('choices',0)
    setTextSize('choices',24)
    setProperty('choices'..'.antialiasing',false)
    addLuaText('choices')

    makeLuaSprite('epicArrow', "UI/menus/pixel/selector", subbox.x+9*3, subbox.y+9*6+3)
    scaleObject('epicArrow',3,3)
    setProperty('epicArrow.antialiasing',false)
    addLuaSprite('epicArrow',true)

    --buy menu
    makeLuaSprite('buyBox','selectionBox',647,116)
    setProperty('buyBox.visible',false)
    addLuaSprite('buyBox',true)

    --for 

    --freeplay menu
    makeLuaSprite('blank','UI/menus/freeplay/blank',screenWidth/8,8)
    scaleObject('blank',0.75,0.75)
    screenCenter('blank','y')
    addLuaSprite('blank',true)

    makeAnimatedLuaSprite('unknown','UI/menus/freeplay/ports/unknown',screenWidth/8+3)
    scaleObject('unknown',0.75,0.75)
    addAnimationByPrefix('unknown','idle','unknown',24,true)
    playAnim('unknown','idle')
    screenCenter('unknown','y')
    addLuaSprite('unknown',true)
    setProperty('unknown.alpha',0)

    --freeplay list setup
    local yeah = (screenWidth/8+384)
    listx = yeah+(screenWidth-yeah)/2
    for i,v in ipairs(freeSongs) do
        local unlocked = i<4 or getDataFromSave('hypnoProgress','song-'..i,false)
        local newSong = Alphabet:new('song-'..i,unlocked and v or what(v),true,listx,screenHeight/2,1,'center')
        newSong:setCamera('camMenu')
        table.insert(freeButtons,newSong)

        if unlocked then
            local name = 'port-'..i
            local offset = portOffsets[i] or {0,0}
            makeAnimatedLuaSprite(name,'UI/menus/freeplay/ports/'..string.lower(v),screenWidth/8,8)
            scaleObject(name,0.75,0.75,true)
            addAnimationByPrefix(name,'idle',string.lower(v),24,true)
            playAnim(name,'idle')
            screenCenter(name,'y')
            addLuaSprite(name,true)
            setProperty(name..'.alpha',0)
            table.insert(freeStuff,name)

            setProperty(name..'.offset.x',offset[1])
            setProperty(name..'.offset.y',offset[2])
        else
            setDataFromSave('hypnoProgress','song-'..i,false)
            
            local name = 'lock-'..i
            makeAnimatedLuaSprite(name,'UI/menus/freeplay/unlocked',0,0)
            addAnimationByPrefix(name,'idle','lock',24,true)
            addAnimationByPrefix(name,'unlock','unlock',24,false)
            playAnim(name,'idle')
            setProperty(name..'.alpha',0)
            addLuaSprite(name,true)
            table.insert(freeStuff,name)

            lockedShit[i] = true
        end
    end

    freeGroup = Group:new('freeGroup',freeStuff,0,0,'camMenu')

    --header shit i had to put here because of sprite ordering
    makeLuaSprite('headerbg','',0,0)
    makeGraphic('headerbg',screenWidth*2,screenHeight/8,'ffffff')
    addLuaSprite('headerbg',true)

    makeAnimatedLuaSprite('shope','UI/menus/shop/CGShopSign_assets',screenWidth/2-241,getProperty('headerbg.height'))
    addAnimationByPrefix('shope','swing','ShopSign',24,false)
    addLuaSprite('shope',true)

    shopTitle = Alphabet:new('shopTitle','shop',true,screenWidth/2,screenHeight/8,1,'center')
    shopTitle:setCamera('camMenu')

    shopGroup = Group:new('shopGroup',shopStuff,0,0,'camMenu')
    freeTitle = Alphabet:new('freeTitle','freeplay',true,screenWidth/2,screenHeight/8,1,'center')
    freeTitle:setCamera('camMenu')

    flushSaveData('hypnoProgress')

    switchState(false)
end

function onCreatePost()
    setProperty('camHUD.visible',false)
    playMusic('freeplayMenu',1,true)

    --setPropertyFromClass('flixel.FlxG','mouse.visible',true)

    callScript('scripts/camera.lua','addShader',{'shopShader','shopShader','camMenu',true})
    setShaderFloat('shopShader','effectTime',0.05)
end

local buttons = {
    [1] = function()
        debugPrint('buy')
        inShop = true
    end,
    [2] = function()
        debugPrint('fuck off dipshit')
    end,
    [3] = function()
        doTweenAlpha('camFade','camHUD',0,realCrochet*2,'quadOut')
        endSong()
    end,
}

local function shopSelect(num)
    shopPick = shopPick + num
    if shopPick < 1 then
        shopPick = 3
    elseif shopPick > 3 then
        shopPick = 1
    end

    shopGroup.items.epicArrow.y = getProperty('choices.y')+30*(shopPick-1)+3
    playSound('scrollMenu')
end

local function realBeatHit()
    --this is a beat
end

function enterSong(id)
    playSound('confirmMenu')
    enteringSong = true
    canControl = false
    canPick = false
    runTimer('textFlicker',0.12,6)
    freeButtons[freePick].visible = false
    freeButtons[freePick].alpha = 1
end

function onTimerCompleted(tag,loops,loopsLeft)
    if tag == 'textFlicker' then
        debugPrint(loopsLeft)
        if loopsLeft == 0 then
            funnyZoom = true
        else
            freeButtons[freePick].visible = not freeButtons[freePick].visible
        end
    elseif tag == 'cgSpeak' and not inFree then
        speakLol()
    end
end

function onUpdate(elapsed)
    if canControl then
        if keyboardPressed('UP') then
            if inFree then
                if freeCooldown >= 0 then
                    freeSelect(keyboardPressed('SHIFT') and -3 or -1)
                    freeCooldown = -0.25
                end
                freeCooldown = freeCooldown+elapsed
            elseif keyboardJustPressed('UP') then
                shopSelect(-1)
            end    
        elseif keyboardPressed('DOWN') then
            if inFree then
                if freeCooldown >= 0 then
                    freeSelect(keyboardPressed('SHIFT') and 3 or 1)
                    freeCooldown = -0.25
                end
                freeCooldown = freeCooldown+elapsed
            elseif keyboardJustPressed('DOWN') then
                shopSelect(1)
            end  
        else
            freeCooldown = 0
        end

        if keyboardJustPressed('ENTER') then
            if inFree then
                if lockedShit[freePick] then
                    playSound('errorMenu')
                else
                    enterSong(freePick)
                end
            else
                playSound('confirmMenu')
                buttons[shopPick]()
            end
        elseif keyboardJustPressed('RIGHT') and not inFree then
            switchState(true)
        elseif keyboardJustPressed('LEFT') and inFree then
            switchState(false)
        end
    end

    realTime = realTime + elapsed
    if realTime/realCrochet>=1 then
        realBeat = (realBeat+1)%4
        realBeatHit()
        realTime = realTime%realCrochet
    end

    --[[setProperty('port-'..target..'.offset.x',(getMouseX('hud')-getProperty('blank.x'))/2)
    setProperty('port-'..target..'.offset.y',(getMouseY('hud')-getProperty('blank.y'))/2)
    debugPrint(getProperty('port-'..target..'.offset.x') ..', '.. getProperty('port-'..target..'.offset.y'))
    if mouseClicked('left') then
        target = target + 1
    elseif mouseClicked('right') then
        target = target - 1
    end--]]
end

local menux = 0

local shaderValue = 0
local shaderTime = 0
local shaderSpeed = 0.055

function onUpdatePost(elapsed)
    menux = lerp(menux,screenWidth*(inFree and -1 or 0),elapsed*13)
    shopGroup.x = menux
    freeGroup.x = menux+screenWidth
    mainbox.x = boxPos1 + menux
    subbox.x = boxPos2 + menux
    shopTitle.x = screenWidth/2+menux
    freeTitle.x = screenWidth*3/2+menux
    --setProperty('shopGroup.x',menux)
    --setProperty('freeCam.x',menux+screenWidth)
    if enteringSong and funnyZoom then
        if shaderTime < 1.35 then
            shaderValue = shaderValue + elapsed*15*shaderSpeed*1.12
            shaderTime = shaderTime + elapsed*15*shaderSpeed
            shaderSpeed = shaderSpeed + elapsed/24
            setShaderFloat('shopShader','aberration',shaderValue)
            setShaderFloat('shopShader','effectTime',shaderTime)
        end
        if shaderTime > 1 then
            local daalpha = lerp(freeButtons[freePick].alpha,0,elapsed*18)
            freeButtons[freePick].alpha = daalpha
            if daalpha < 0.05 then
                loadSong(string.lower(freeSongs[freePick]))
            end
        end
    end

    for i,button in pairs(freeButtons) do
        if enteringSong then 
            if i == freePick then
                button.x = lerp(button.x,screenWidth/2,elapsed*6)
                button.y = lerp(button.y,screenHeight/2+(button.height*button.size)/2,elapsed*6)
                setProperty('blank.alpha',lerp(getProperty('blank.alpha'),0,elapsed*6))
                if luaSpriteExists('port-'..i) then
                    setProperty('port-'..i..'.alpha',lerp(getProperty('port-'..i..'.alpha'),0,elapsed*6))
                end
            else
                button.alpha = lerp(button.alpha,0,elapsed*12)
                if lockedShit[i] then 
                    setProperty('lock-'..i..'.alpha',button.alpha)
                end
            end
        else
            local diff = i-freePick
            local depth = math.sin(clamp((diff/10*math.pi),math.pi/-2,math.pi/2)+math.pi/2) --when picked is 1, goes to 0 as its further away
            local alpha = diff == 0 and 1 or ((depth-1/4)*2/3)
            local ypos = math.sin(clamp(diff/7*math.pi,math.pi/-2,math.pi/2))*230
            ypos = ypos + 50*(ypos>0 and 1 or ypos<0 and -1 or 0)
            button.size = lerp(button.size,depth,elapsed*12)
            button.alpha = lerp(button.alpha,alpha,elapsed*12)
            button.y = lerp(button.y,(screenHeight*7/8)/2+screenHeight/8+ypos+(button.height*button.size)/2,elapsed*12)

            button.x = listx+menux+screenWidth

            if lockedShit[i] then 
                scaleObject('lock-'..i,button.size,button.size)
                freeGroup.items['lock-'..i].x = listx - getProperty('lock-'..i..'.width')/2
                freeGroup.items['lock-'..i].y = button.y - (button.height*button.size)/2 - getProperty('lock-'..i..'.height')/2
                setProperty('lock-'..i..'.alpha',button.alpha)
            end
        end
    end
    

    Box:update()
    Group:update()
    Alphabet:update(elapsed)
end

function onStartCountdown()
    return Function_Stop
end

--help