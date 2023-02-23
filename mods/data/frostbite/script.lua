local dont = false

local jumpaberration = 0.75
local jumpscale = 0.65
local jumpvis = false

local function lerp(a,b,t) return a + (b - a) * t end

function onCreate()
	makeLuaSprite('introFog', '', 0,0)
	setObjectCamera("introFog", "camOther")
	makeGraphic("introFog", screenWidth*3, screenHeight*3, '0xFFF0E9FB')
	setObjectOrder("introFog", 999)
	screenCenter("introFog", "XY")
	setScrollFactor('introFog', 0, 0)
	addLuaSprite("introFog", true)
end

function onCountdownStarted()
    setProperty('skipCountdown',true)
end

function onUpdate(elapsed)
	if jumpvis then
		jumpaberration = lerp(jumpaberration,0.35,0.3)
		jumpscale = lerp(jumpscale,0.35,0.3)
		setShaderFloat('jumpscare','aberration',jumpaberration)
		setShaderFloat('jumpscare','effectTime',jumpaberration)
		scaleObject('jumpscare',jumpscale,jumpscale)
		setProperty('jumpscare.x',screenWidth/2-(2000*jumpscale))
		setProperty('jumpscare.y',screenHeight/2-(1125*jumpscale))
	end
end

local cases = {
	[8] = function()
		doTweenAlpha('bitch','introFog',0.1,5,'quadInOut')
	end,
	[1376] = function()
		setProperty('vocals.volume',0)
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
		setProperty('inCutscene',true)
		dont = true
		setProperty('camGame.visible',false)
		setProperty('camHUD.visible',false)
		playSound('Frostbite_ending',1,'hedead')
		
		makeLuaSprite('jumpscare','mountain/Pikachu',screenWidth/2-2000,screenHeight/2-1125)
		setObjectCamera('jumpscare','other')
		addLuaSprite('jumpscare',true)
		setProperty('jumpscare.visible',false)
		runTimer('endingstart',10.12)

		initLuaShader('aberration')
		setSpriteShader('jumpscare','aberration')

		setProperty('snowval.x',0)
		setProperty('snowval.y',0)
	end,
}

function onStepHit()
	if cases[curStep] ~= nil then cases[curStep]() end
end

function onTimerCompleted(tag)
	if tag == 'endingstart' then
		jumpvis = true
		setProperty('jumpscare.visible',true)
		if flashingLights then
			cameraShake('other',0.008,3.08)
		else
			setProperty('jumpscare.alpha',0)
			doTweenAlpha('jumpscarefade','jumpscare',1,0.5,'linear')
		end
		runTimer('hidejump',3.08)
	elseif tag == 'hidejump' then
		jumpvis = false
		setProperty('jumpscare.visible',false)
		runTimer('endsong',1)
	elseif tag == 'endsong' then
		dont = false
		endSong()
	end
end

function onEndSong()
	if dont then
		return Function_Stop
	end
	return Function_Continue
end
