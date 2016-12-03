-- this is time logic for enginesounds 

defineProperty("total_time", globalPropertyf("sim/time/total_flight_time_sec")) -- flight sim time
defineProperty("sim_run_time", globalPropertyf("sim/time/total_running_time_sec")) -- sim time
defineProperty("frame_time", globalPropertyf("frame_time")) -- frame time
defineProperty("flight_time", globalPropertyf("flight_time")) -- flight time
defineProperty("frame_number", globalPropertyf("frame_number")) -- flight time

local time_begin = get(sim_run_time) -- time at flight beginning
local time_last = get(sim_run_time)  -- time for previous frame

function update()

set(frame_number, get(frame_number)+1)
if get(total_time)<1 then 
 time_begin = get(sim_run_time) -- time at flight beginning 
 time_last = get(sim_run_time)  -- time for previous frame
end

local time_now = get(sim_run_time)
local passed = math.abs(time_now - time_begin)
local diff = math.abs(time_now - time_last)
  
set(flight_time, passed)
set(frame_time, diff)

time_last = time_now

end