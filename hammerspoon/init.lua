-- keep the built-in mic as default input, even when AirPods connect
local function builtInMic()
  for _, dev in ipairs(hs.audiodevice.allInputDevices()) do
    if dev:transportType() == "Built-in" then return dev end
  end
end

local function pinBuiltInMic()
  local mic = builtInMic()
  if mic and hs.audiodevice.defaultInputDevice() ~= mic then
    mic:setDefaultInputDevice()
  end
end

hs.audiodevice.watcher.setCallback(function(event)
  if event == "dIn " or event == "dev#" then pinBuiltInMic() end
end)
hs.audiodevice.watcher.start()
pinBuiltInMic()
