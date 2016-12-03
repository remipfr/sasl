-------------X-Plane and SASL volume controls
defineProperty("mastervol", globalPropertyf("com/dkmp/mastervol"))
defineProperty("mastervolknob", globalPropertyf("com/dkmp/mastervolknob"))

defineProperty("XPsound", globalPropertyf("sim/operation/sound/sound_on"))
defineProperty("volume", globalPropertyf("volumeX"))

defineProperty("xF", globalPropertyf("maxF"))
defineProperty("iF", globalPropertyf("minF"))
defineProperty("xB", globalPropertyf("maxB"))
defineProperty("iB", globalPropertyf("minB"))

defineProperty("frame_time", globalPropertyf("frame_time"))
defineProperty("acfpitch", globalPropertyf("sim/flightmodel/position/theta"))
defineProperty("acfroll", globalPropertyf("sim/flightmodel/position/phi"))

------------Camera and source direction
defineProperty("view_hdg", globalPropertyf("sim/graphics/view/view_heading"))
defineProperty("acf_hdg", globalPropertyf("sim/flightmodel/position/psi"))
defineProperty("view", globalPropertyf("sim/graphics/view/view_is_external"))
defineProperty("ENGN1", globalPropertyf("sim/flightmodel/engine/ENGN_N1_[0]"))

------------Sound source position, Distance
defineProperty("acfposX", globalPropertyf("sim/flightmodel/position/local_x"))
defineProperty("acfposY", globalPropertyf("sim/flightmodel/position/local_y"))
defineProperty("acfposZ", globalPropertyf("sim/flightmodel/position/local_z"))

------------Camera position
defineProperty("viewX", globalPropertyf("sim/graphics/view/view_x"))
defineProperty("viewY", globalPropertyf("sim/graphics/view/view_y"))
defineProperty("viewZ", globalPropertyf("sim/graphics/view/view_z"))

------------Throttle
defineProperty("volume", globalPropertyf("volumeX"))

------------Inside sound
defineProperty("canopy", globalPropertyf("sim/flightmodel2/misc/canopy_open_ratio"))

------------master_gain
defineProperty("sim_speed", globalPropertyi("sim/time/sim_speed"))

--###############################################################################

local ENGNsound_bl = loadSample('sounds/custom/EngineBL.wav')
local ENGNsound_br = loadSample('sounds/custom/EngineBR.wav')
local ENGNsound_fl = loadSample('sounds/custom/EngineFL.wav')
local ENGNsound_fr = loadSample('sounds/custom/EngineFR.wav')
local alpha = 0
local alphaP = 0
local zeta=0

local LR=1.6 -- left/right damping
local UD=1.2 -- up/down damping

local Tb=get(iB)
local Tf=get(iF)
local TbM=get(xB)
local TfM=get(xF)

local backgain = 300
local backgainR = 300
local backgainL = 300

local frontgain = 300
local frontgainR = 300
local frontgainL = 300

local temp=0
local temp1=0
local t=0

local pitchb=1000
local pitchf=1000

local DIS_old=0
local VolX=0

--###############################################################################

function update ()
	
	------------Prepare the value for "masterVol" (Volume)
	if get(sim_speed) >= 1  then
	masterVol = get(mastervolknob) * get(XPsound) 
	else
	masterVol = 0
	end
	
	------------	
		
	local LOC={-0.5, -0.5, -1} --1st engine
	
	local FT=get(frame_time)	
	local W=-get(acfpitch)*3.141592/180
	local U=-get(acfroll)*3.141592/180	
	
	------------Camera and source direction
	local beta=get(view_hdg)
	local gamma=get(acf_hdg)-5.56429
	
	if gamma<0 then gamma=360+gamma end
	local V=gamma*3.141592/180
	
	local v=get(view)
	local e=get(ENGN1)
	
	------------Engine location	
	SHIFT={LOC[1]*math.cos(U)-LOC[3]*math.sin(U), LOC[2], LOC[3]*math.cos(U)+LOC[1]*math.sin(U)}
	LOC=SHIFT
	SHIFT={LOC[1], LOC[2]*math.cos(W)-LOC[3]*math.sin(W), LOC[3]*math.cos(W)+LOC[2]*math.sin(W)}
	LOC=SHIFT
	SHIFT={LOC[1]*math.cos(V)-LOC[2]*math.sin(V), LOC[2]*math.cos(V)+LOC[1]*math.sin(V), LOC[3]}		
	
	------------Sound source position
	local Ox=get(acfposX)+SHIFT[1]
	local Oy=get(acfposZ)+SHIFT[2]
	local Oz=get(acfposY)+SHIFT[3]

	------------Camera position
	local X=get(viewX)
	local Y=get(viewZ)
	local Z=get(viewY)
	
	-------------Distance
	cam_pos = {X - Ox, Y-Oy, Z-Oz}
	local DIS=(cam_pos[1])^2 + (cam_pos[2])^2 + (cam_pos[3])^2
	
	local lDIS=math.sqrt((X-get(acfposX))^2+(Y-get(acfposZ))^2+(Z-get(acfposY))^2)
	
	------------Throttle
	Tb=get(iB)*get(volume)
	Tf=get(iF)*get(volume)
	TbM=get(xB)*get(volume)
	TfM=get(xF)*get(volume)

	if e>33 then
		SM=(TbM-Tb)/67*e+TbM-(TbM-Tb)/67*100
		SMf=(TfM-Tf)/67*e+TfM-(TfM-Tf)/67*100
	else
		SM=Tb*e/33
		SMf=Tf*e/33
	end
	
	if FT>0 then
		pitchb=math.min(math.max(1000*(1+(e-33)/67)*(1-((lDIS-DIS_old)/FT)/1500), 200), 2500)
		pitchf=math.min(math.max(900*(1+(e-33)/120)*(1-((lDIS-DIS_old)/FT)/1500), 200), 2500)
		
		DIS_old=lDIS
	end
	
	------------Camera
	if (Ox-X)<0 then
		alpha = 180/3.141592*math.atan((Oy-Y)/(Ox-X))+270
	else
		alpha = 180/3.141592*math.atan((Oy-Y)/(Ox-X))+90
	end
	
	if beta>alpha then 
		temp=(beta-alpha)/180-1
	else
		temp=-(alpha-beta)/180+1
	end
	
	if temp>0.5 then t=1-temp
	elseif temp<-0.5 then t=-temp-1
	else t=temp
	end
	
	------------Engine direction
	alphaP=math.mod(180+alpha, 360)
	
	if gamma>alphaP then
		temp1=(gamma-alphaP)/180-1
	else
		temp1=-(alphaP-gamma)/180+1
	end

	local t1=(((1-math.abs(temp1)*(1)))+0.5)/1.5
	local t2=(math.abs(temp1)+0.5)/1.5
	
	------------Inside sound
	local factorL=0.2+math.max(get(canopy)*0.5)
	local factorR=0.2+math.max(get(canopy)*0.5)
	
	------------Vertical
	zeta = -180/3.141592*math.sin((Oz-Z)/math.sqrt(DIS))
	
	tzb=math.abs(zeta-W*180/3.141592)/45*v
	tzf=math.abs(zeta+W*180/3.141592)/45*v
	
	------------Sound Power
	backgain = (SM*masterVol*(0.6)*math.exp(-DIS/800000))*(1-tzb*UD/2) -- 1 = ratio back/front
	frontgain = (SMf*masterVol*(0.3)*math.exp(-DIS/800000))*(1-tzf*UD/2) -- 0.4 = ratio back/front
	
	------------Back/Front
	if v==1 then
		backgainR=backgain*(1+LR*t)*(v*t1+(1-v)*factorR)
		backgainL=backgain*(1-LR*t)*(v*t1+(1-v)*factorL)
	
		frontgainR=frontgain*(1+LR*t)*(v*t2+(1-v)*factorR)
		frontgainL=frontgain*(1-LR*t)*(v*t2+(1-v)*factorL)
	else
		backgainR=backgain*(1.2+LR*t/2)*factorR
		backgainL=backgain*(1.2-LR*t/2)*factorL
	
		frontgainR=frontgain*(1.2+LR*t/2)*factorR
		frontgainL=frontgain*(1.2-LR*t/2)*factorL
	end
	
	------------Sound
	setSamplePitch(ENGNsound_bl, pitchb)
	setSamplePitch(ENGNsound_br, pitchb)
	
	setSamplePitch(ENGNsound_fl, pitchf)
	setSamplePitch(ENGNsound_fr, pitchf)
	
	setSampleGain(ENGNsound_bl, backgainL)
	setSampleGain(ENGNsound_br, backgainR)

	setSampleGain(ENGNsound_fl, frontgainL)
	setSampleGain(ENGNsound_fr, frontgainR)
	
	if isSamplePlaying(ENGNsound_bl) == false and isSamplePlaying(ENGNsound_br) == false then
		playSample(ENGNsound_bl, 1)
		playSample(ENGNsound_br, 1)
	end
	
	if isSamplePlaying(ENGNsound_fl) == false and isSamplePlaying(ENGNsound_fr) == false then
		playSample(ENGNsound_fl, 1)
		playSample(ENGNsound_fr, 1)
	end	
		
end
