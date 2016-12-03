------------flap, speedbrake
defineProperty("flap_req", globalPropertyf("sim/cockpit2/controls/flap_ratio")) -- 0 to 1
defineProperty("speedbrake_req", globalPropertyf("sim/cockpit2/controls/speedbrake_ratio")) -- 0 to 1

------------Inside sound
defineProperty("vue", globalPropertyf("sim/graphics/view/view_is_external"))
defineProperty("volumeSon", globalPropertyf("volumeSon"))
defineProperty("Xvue", globalPropertyf("sim/graphics/view/view_x"))
defineProperty("Yvue", globalPropertyf("sim/graphics/view/view_y"))
defineProperty("Zvue", globalPropertyf("sim/graphics/view/view_z"))
defineProperty("Xavion", globalPropertyf("sim/flightmodel/position/local_x"))
defineProperty("Yavion", globalPropertyf("sim/flightmodel/position/local_y"))
defineProperty("Zavion", globalPropertyf("sim/flightmodel/position/local_z"))

------------canopy
defineProperty("canopy",globalPropertyf("sim/cockpit2/switches/canopy_open"))
defineProperty("canopy_ratio",globalPropertyf("sim/flightmodel2/misc/canopy_open_ratio"))

------------sonicboom
defineProperty("mach",globalPropertyf("sim/flightmodel/misc/machno"))

------------chute
defineProperty("chute_req", globalPropertyf("sim/cockpit2/switches/parachute_deploy")) -- 0 to 1

------------probe
defineProperty("probe_req", globalPropertyf("sim/cockpit2/switches/tailhook_deploy")) -- 0 to 1

------------Sound
defineProperty("pause", globalPropertyf("sim/time/paused"))

--###############################################################################

local CAO = loadSample('sounds/custom/canopyopen.wav')
local CAC = loadSample('sounds/custom/canopyclose.wav')
local M = loadSample('sounds/custom/sonicboom.wav')
local FL = loadSample('sounds/custom/flap.wav')
local SB = loadSample('sounds/custom/airbrake.wav')
local CH = loadSample('sounds/custom/chute.wav')
local PR = loadSample('sounds/custom/probe.wav')

local detentflap = get(flap_req)
local detentflap_prev = detentflap
local detentsb = get(speedbrake_req)
local detentsb_prev = detentsb
local chute = 0                        -- assume starts up this way
local chute_prev = 0
local probe = 0                        -- assume starts up this way
local probe_prev = 0

--###############################################################################

function update()

	local v=get(vue)
	
	------------Inside sound
	if (get(canopy)==1) and v==0 then
		volumefinal=200*get(volumeSon)
	else
		volumefinal=100*get(volumeSon)
	end
	
	local axeX=get(Xavion)
	local axeY=get(Yavion)
	local axeZ=get(Zavion)

	local X=get(Xvue)
	local Y=get(Yvue)
	local Z=get(Zvue)
	
	if v==1 then
		cam_pos = {X - axeX, Y-axeY, Z-axeZ}
		volumefinal = (200*get(volumeSon)*math.exp(-((cam_pos[1])^2 + (cam_pos[2])^2 + (cam_pos[3])^2)/100000))
	end
	
		setSampleGain(CAO, volumefinal*(v+0.8*(1-v)))
	if (get(canopy)==1 and get(canopy_ratio)<0.01) or (get(canopy)==0 and get(canopy_ratio)>0.99) then  playSample(CAO, 0) end
 	
	------------sonicboom
	setSampleGain(M, 2*volumefinal)	
	if get(mach) >0.999 and get(mach) < 1.001 and isSamplePlaying(M) == false then 
		playSample(M, 0)
	end
	
	------------flap
	setSampleGain(FL, 2*volumefinal)	
	detentflap = get(flap_req)
  
	if detentflap ~= detentflap_prev then		-- request for change made
		playSample(FL, 0)
		detentflap_prev = detentflap
	end
	
	------------speedbrake
	setSampleGain(SB, 2*volumefinal)	
	detentsb = get(speedbrake_req)
  
	if detentsb ~= detentsb_prev then		-- request for change made
		playSample(SB, 0)
		detentsb_prev = detentsb
	end
	
	------------chute
	setSampleGain(CH, 2*volumefinal)	
	chute = get(chute_req)
  
	if chute ~= chute_prev then		-- request for change made
		playSample(CH, 0)
		chute_prev = chute
	end
	
	------------probe
	setSampleGain(PR, 2*volumefinal)	
	probe = get(probe_req)
  
	if probe ~= probe_prev then		-- request for change made
		playSample(PR, 0)
		probe_prev = probe
	end
	
	------------Sound
	if get(pause)==1 then 
		stopSample(CAO) 
		stopSample(CAC) 
		stopSample(M) 
		stopSample(FL) 
		stopSample(SB) 
		stopSample(CH) 
	end
	
end