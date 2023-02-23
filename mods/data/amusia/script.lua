function onCreate()
	setProperty('skipCountdown', true)
	addCharacterToList('ponyta-perspective')
	addCharacterToList('wiggles-death-stare')
	addCharacterToList('wiggles-terror')
	precacheImage('disabled/wiggles_questionare')
	precacheImage('disabled/questionare')
end

local insane = 0.0125
local flipped = false

local fotes = false
local fnotes2 = false
local flevel = 0
local flevel2 = 0

local canAnswer = false

local speen = false

local wiggleoffset = 1

local curback = 'background'

local function stepDel(step)
	return step*(stepCrochet/1000)
end

local function remapToRange(value, start1, stop1, start2, stop2)
    return start2 + (value - start1) * ((stop2 - start2) / (stop1 - start1))
end

local function spinem(leng)
	if not leng then leng = 8 end
	for i = 0,3 do
		setPropertyFromGroup('playerStrums',i,'angle',0)
		setPropertyFromGroup('opponentStrums',i,'angle',0)
		noteTweenAngle('speen'..i,i,360,stepDel(leng),'cubeInOut')
		noteTweenAngle('speen'..i+4,i+4,360,stepDel(leng),'cubeInOut')
	end
end

local cases = {
	[16] = function()
		doTweenX('hey','dad',228,stepCrochet/125,'circOut')
	end,
	[24] = function()
		doTweenX('hi','boyfriend',770,stepCrochet/125,'circOut')
	end,
	[32] = function()
		setProperty('isCameraOnForcedPos',false)
		setProperty('black.alpha',0)
		setProperty('white.alpha',0)
		if flashingLights then
			cameraFlash('other','ffffff',stepDel(8))
		else
			cameraFlash('other','000000',stepDel(8))
		end
		setProperty('boyfriend.color',getColorFromHex('ffffff'))
		setProperty('dad.color',getColorFromHex('ffffff'))
	end,
	[536] = function()
		doTweenAlpha('vignette3','staticSprite',0.25,stepDel(8),'circIn')
		doTweenAlpha('vignette4','staticOverlay',0.6,stepDel(8),'circIn')
	end,
	[792] = function()
		setProperty('camFollow.x',715)
		setProperty('camFollow.y',13)
		setProperty('isCameraOnForcedPos',true)
		--begin perspective change
		doTweenX('perspective1','boyfriend',defaultBoyfriendX-screenWidth,stepDel(8),'circIn')
		doTweenX('perspective2','dad',defaultOpponentX+screenWidth,stepDel(8),'circIn')
		doTweenX('plateR1','plateR',656-screenWidth,stepDel(8),'circIn')
		doTweenX('plateL1','plateL',128+screenWidth,stepDel(8),'circIn')
		doTweenAlpha('bargobyebye','healthBar',0,stepDel(8),'circIn')
		doTweenAlpha('iconbye1','iconP2F',0,stepDel(8),'circIn')
		doTweenAlpha('iconbye2','iconP1',0,stepDel(8),'circIn')
	end,
	[800] = function()
		insane = 1.25
		fnotes = true
		--finish perspective change
		triggerEvent('Change Character','dad','wiggles-death-stare')
		triggerEvent('Change Character','bf','ponyta-perspective')
		setProperty('boyfriend.x',64+screenWidth)
		setProperty('boyfriend.y',96)
		setProperty('dad.x',786-screenWidth)
		setProperty('dad.y',-144)
		setProperty('plateL.x',-128+screenWidth)
		doTweenX('perspective3','boyfriend',64,stepDel(8),'circOut')
		doTweenX('perspective4','dad',786,stepDel(8),'circOut')
		doTweenX('plateR2','plateR',656,stepDel(8),'circOut')
		doTweenX('plateL2','plateL',-128,stepDel(8),'circIn')
		
		doTweenAlpha('bargohellow','healthBar',1,stepDel(8),'circOut')
		doTweenAlpha('iconhi1','iconP2F',1,stepDel(8),'circOut')
		doTweenAlpha('iconhi2','iconP1',1,stepDel(8),'circOut')
		flipped = true
		setProperty('iconP1.flipX', true)
		setProperty('iconP2F.flipX', true)
		callScript('characters/wigglytuff.lua','flipPlease')

		scaleObject('healthBar',-1,1)
		
		if not middlescroll then
			for i = 0,3 do
				noteTweenX('swap'..i,i,_G['defaultPlayerStrumX'..i],stepDel(16),'circInOut')
				noteTweenX('swap'..i+4,i+4,_G['defaultOpponentStrumX'..i],stepDel(16),'circInOut')
			end
			spinem(16)
		end
	end,
	[808] = function()
		setProperty('isCameraOnForcedPos',false)
	end,
	[1312] = function()
		--go fucking insane
		triggerEvent('Change Character','dad','wiggles-terror')
		speen = true
		fnotes2 = true
		setProperty('dad.x',435)
		setProperty('dad.y',-255)
	end,
	[2052] = function()
		--running away
		doTweenAlpha('vignette1','staticSprite',1,stepDel(8),'linear')
		doTweenAlpha('vignette2','staticOverlay',1,stepDel(8),'linear')
	end,
	[2080] = function()
		--music box
		curback = ''
		setProperty('dad.visible',false)
		setProperty('boyfriend.visible',false)
		removeLuaSprite('background',true)
		removeLuaSprite('background2',true)
		removeLuaSprite('plateL',true)
		removeLuaSprite('plateR',true)
		setProperty('camHUD.visible',false)
		doTweenAlpha('vignette1','staticSprite',0,stepDel(64),'linear')
		doTweenAlpha('vignette2','staticOverlay',0,stepDel(64),'linear')

		makeLuaSprite('qbackground','disabled/questionare',0,75)
		scaleObject('qbackground',0.25,0.25)
		setScrollFactor('qbackground',0,0)
		screenCenter('qbackground','x')
		makeAnimatedLuaSprite('qwiggly','disabled/wiggles_questionare',512,130)
		setScrollFactor('qwiggly',0,0)
		addAnimationByPrefix('qwiggly','idle0','questionnaire idle',24,true)
		addAnimationByPrefix('qwiggly','lookup','Give me your sing',24,false)
		addAnimationByPrefix('qwiggly','idle2','angry',24,true)
		addOffset('qwiggly','idle2',0,-10)

		addLuaSprite('qbackground',true)
		addLuaSprite('qwiggly',true)
		
		makeAnimatedLuaSprite('qwigglyclose','disabled/Givemeyoursing',110,-258)
		setScrollFactor('qwigglyclose',0,0)
		addAnimationByPrefix('qwigglyclose','move','Upfront',24,true)
		addAnimationByPrefix('qwigglyclose','idle','stareLoop',24,true)
	end
}

function onCreatePost()
	if timeBarType == 'Disabled' then wiggleoffset = 0 end

	setProperty('defaultCamZoom',1)
	setProperty('camFollow.x',screenWidth/2)
	setProperty('isCameraOnForcedPos',true)

	setProperty('gf.alpha', 0)
	
	setProperty('boyfriend.x',770-screenWidth)
	setProperty('dad.x',228+screenWidth)
	
	setProperty('boyfriend.color',getColorFromHex('000000'))
	setProperty('dad.color',getColorFromHex('000000'))
	
	setProperty('camFollow.x',screenWidth/2)
	setProperty('camFollowPos.x',screenWidth/2)
end

local phaseinten = {0.0125,0.05,0.125,0.5}
local boxmade = false

local speech = {
	"I just wanted to Sing.",
	"Why... why... why can't I Sing?",
	"Just... Sing... Sing...Sing...",
	"I only need to Sing...",
	"Can you sing?",
	"You're lying. You... can Sing.",
	"Give me your Sing.",
	"Give me your Sing.",
	"GIVE ME YOUR Sing.",
	"GIVE ME YOUR SING.GIVE ME YOUR SING.GIVE ME YOUR SING.GIVE ME YOUR SING.GIVE ME YOUR SING.GIVE ME YOUR SING.G111111VE ME YOUR SING.33GIVE 555ME YOUR SIN444G.GIVE ME YOUR SING.GIVE ME YOUR SING.GIVE ME YOUR SING.GIVE ME YOUR SING.GIVE ME YOUR SING.GIVE ME YOUR SING.GIVE ME YOUR SING."
}

local speechprog = 1
local textprog = 1
local textdel = 0.05
local canSing = true

local fadetarget = 'question'

function onCountdownStarted()
    setProperty('skipCountdown',true)
end

function onEvent(name,val1,val2)
	if name == 'Wiggly Change' and getProperty('background.visible') then
		insane = phaseinten[val1+1]
	elseif name == 'Progress Dialogue' then
		if boxmade then
			--do things
			speechprog = speechprog + 1
			textprog = 1
			runTimer('textwrite',textdel)
			if speechprog == 5 then
				--answer da question
				addLuaSprite('answer')
				doTweenX('questionslide','question',286-33*3,1.3,'linear')
				doTweenX('textslide','curText',286-27*3,1.3,'linear')
				doTweenX('answerslide','answer',1024-33*3,1.3,'linear')

				setProperty('answer.alpha',0.25)
				fadetarget = 'answer'
				runTimer('fadein',0.4)
			end
		else
			boxmade = true
			setProperty('inCutscene',true)
			makeLuaSprite('question','UI/amusia/questionareTextBox',286,175*3)
			setObjectCamera('question','other')
			setScrollFactor('question',0,0)
			addLuaSprite('question',true)

			setProperty('question.alpha',0.25)
			runTimer('fadein',0.4)

			makeLuaText('curText','',500,286+6*3,180*3)
			setObjectCamera('curText','other')
			setTextAlignment('curText','left')
			setTextFont('curText','poketext.ttf')
			setTextBorder('curText',0,'000000')
			setTextColor('curText','000000')
			addLuaText('curText')
			setTextSize('curText',24)

			runTimer('textwrite',textdel)

			makeLuaSprite('answer','UI/amusia/questionareAnswerBox',286+246*3,181*3)
			setObjectCamera('answer','other')
			setScrollFactor('answer',0,0)
		end
	end
end

local timerswitch = {
	['textwrite'] = function()
		if luaTextExists('curText') and textprog < #speech[speechprog] then
			textprog = textprog + 1
			setTextString('curText',string.sub(speech[speechprog],1,textprog))
			runTimer('textwrite',textdel+(string.sub(speech[speechprog],textprog,textprog)=='.' and 0.05 or 0))
		end
	end,
	['fadein'] = function()
		local alpha = getProperty(fadetarget..'.alpha')
		setProperty(fadetarget..'.alpha',alpha+0.25)
		if alpha ~= 1 then
			runTimer('fadein',0.4)
		end
	end,
	['qidle'] = function()
		if getProperty('qwiggly.animation.curAnim.name') == 'lookup' then
			playAnim('qwiggly','idle2',true)
			setProperty('qwiggly.y',118)
		else
			playAnim('qwigglyclose','idle',true)
		end
	end,
	['wigglysung'] = function()
		canAnswer = false
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
		removeLuaSprite('qbackground',true)
		removeLuaSprite('qwigglyclose',true)
		removeLuaSprite('question',true)
		removeLuaSprite('answer',true)
		removeLuaSprite('answerarrow',true)
		removeLuaSprite('staticOverlay',true)
		removeLuaSprite('staticSprite',true)
		runTimer('itsover',2)
	end,
	['itsover'] = function()
		endSong()
	end
}

function onTimerCompleted(tag)
	if timerswitch[tag] then timerswitch[tag]() end
end

function onTweenCompleted(tag)
	if tag == 'vignette3' then
		doTweenAlpha('vignette1','staticSprite',0.25*0.25,stepDel(4),'circOut')
		doTweenAlpha('vignette2','staticOverlay',0.6*0.25,stepDel(4),'circOut')
		removeLuaSprite('background',true)
		insane = 0.75
		setProperty('background2.visible',true)
		curback = 'background2'
	elseif tag == 'answerslide' then
		makeLuaSprite('answerarrow','UI/pauseMenuStuff/selector',925+6*3,192*3)
		setProperty('answerarrow.antialiasing',false)
		setObjectCamera('answerarrow','other')
		scaleObject('answerarrow',3,3)
		addLuaSprite('answerarrow',true)
		canAnswer = true
	end
end

function onStepHit()
	if cases[curStep] then cases[curStep]() end
	if speen and curStep % 32 == 0 then
		spinem()
	end
end

function onUpdate()
	if canAnswer then
		if keyboardJustPressed('UP') or keyboardJustPressed('DOWN') then
			canSing = not canSing
			if canSing then
				setProperty('answerarrow.y',192*3)
			else
				setProperty('answerarrow.y',200*3)
			end
		elseif keyJustPressed('accept') or keyJustPressed('space') then
			if canSing then
				if speechprog == 5 then
					speechprog = 7
					textprog = 1
					runTimer('textwrite',textdel)
					playAnim('qwiggly','lookup',true)
					runTimer('qidle',0.625)
				else
					--thanks :)
				end
			elseif speechprog < #speech then
				speechprog = speechprog + 1
				textprog = 1
				runTimer('textwrite',textdel)
				if speechprog == 6 then
					playAnim('qwiggly','lookup',true)
					runTimer('qidle',0.625)
				elseif speechprog == 8 then
					removeLuaSprite('qwiggly',true)
					addLuaSprite('qwigglyclose',true)
					playAnim('qwigglyclose','move',true)
					runTimer('qidle',0.255)
				elseif speechprog == 10 then
					textdel = 0.01
					playSound('WigglySing',1.3,'shecantsing')
					triggerEvent('Chromatic Riser','5','32')
					runTimer('wigglysung',3)
				end
			end
		end
	end
end

function onUpdatePost(elapsed)
	if curStep<32 then
		setProperty('black.alpha', 1 - math.abs(math.sin(((getSongPosition()) / (stepCrochet * 8)) * math.pi) * 0.5))
	end
	if curback ~= '' and luaSpriteExists(curback) then
		if flashingLights then
			setShaderFloat(curback,'prob',insane)
		end
		setShaderFloat(curback,'time',getSongPosition()/stepCrochet*0.1)
	end

	if not hideHud and flipped then
		setProperty('iconP1.x', -593+getProperty('healthBar.x') + (getProperty('healthBar.width')*(remapToRange(getProperty('healthBar.percent'), 0, -100, 100, 0)*0.01))-(150 * getProperty('iconP1.scale.x'))/2 - 26*2)
	end
	if fnotes then
		if flevel < 24 then
			flevel = flevel + (elapsed/(1/60))
		end
		for i = 0,3 do
			local a = (flevel/2) + -math.sin((getSongPosition() / ((stepCrochet*8)-i))*math.pi)*flevel
			
			setPropertyFromGroup('playerStrums',i,'y',_G['defaultPlayerStrumY'..i] + a-flevel*wiggleoffset)
			setPropertyFromGroup('opponentStrums',i,'y',_G['defaultPlayerStrumY'..i] + a-flevel*wiggleoffset)
		end
		if fnotes2 then
			if flevel2 < 64 then
				flevel2 = flevel2 + (elapsed/(1/60))
			end
			for i = 0,3 do
				a = (flevel2/2) + -math.sin((getSongPosition() / (stepCrochet*16))*math.pi)*flevel2
				if middlescroll then
					setPropertyFromGroup('playerStrums',i,'x',_G['defaultPlayerStrumX'..i] + a)
					setPropertyFromGroup('opponentStrums',i,'x',_G['defaultOpponentStrumX'..i] + a)
				else
					setPropertyFromGroup('playerStrums',i,'x',_G['defaultOpponentStrumX'..i] + a)
					setPropertyFromGroup('opponentStrums',i,'x',_G['defaultPlayerStrumX'..i] + a)
				end
			end
		end
	end
end

function onMoveCamera(chara)
	if chara == 'boyfriend' then
		--doTweenZoom('newzoom','camera',getProperty('defaultCamZoom')+0.2,0.8,'quadInOut')
		setProperty('defaultCamZoom',1.2)
	end
end