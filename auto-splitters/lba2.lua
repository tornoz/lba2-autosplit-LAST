process('DOSBox.exe')

local old = {location, cinematic, startCinematic, endCinematic}
local current = {location, cinematic, startCinematic, endCinematic}
local locationsOld = {3328, 6917, 13286, 22631, 8837, 20139, 22411, 6400}
local locationsCurrent =  {23808, 19369, 10238, 8939, 24320, 22411, 22263, 6540}
local startCinematicOld = 66;
local endCinematicCurrent = 19463;
local splitCount = 10;
local completedSplits = 1;

function startup()
    refreshRate = 120
end


function state()
   old.location = current.location
   old.cinematic = current.cinematic
   -- old.startCinematic = current.startCinematic
   -- old.endCinematic = current.endCinematic

    current.location = readAddress('ushort', 0x75B6D0, 0x04D178)
    current.cinematic = readAddress('ushort', 0x75B6D0, 0x2B0880)
    
end


function start()
   if (old.cinematic == startCinematicOld  and current.cinematic == 0 ) then
    
        completedSplits = 1
        print('Start')
        return true
     end
end

function isLoading()
    return (current.loading == 1 or (current.menuStage == 3 and current.paused == 4))
end

function split()
    if(current.cinematic == endCinematicCurrent) then
        completedSplits = splitCount;
    end   

    if(
        (completedSplits < splitCount and current.location == locationsCurrent[completedSplits] and old.location == locationsOld[completedSplits]) or
        completedSplits >= splitCount
    ) then
        if(completedSplits < splitCount) then completedSplits = completedSplits + 1 end
        print("Split " .. completedSplits)
        return true
    end

    return false   
end

function update()
    if (current.location ~= old.location) then
        print("old location: " .. old.location)
        print("new location: " .. current.location)
    end
   
    if (current.cinematic ~= old.cinematic) then
        print("cinematic: " .. current.cinematic)
    end
end
