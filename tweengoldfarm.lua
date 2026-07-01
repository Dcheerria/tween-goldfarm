-- LocalScript, taruh di StarterPlayerScripts
-- Fitur:
--  - Character digerakkan pakai BodyVelocity mengikuti waypoint (loop terus).
--  - Speed bisa di-custom lewat GUI.
--  - Titik-titik "long wait" (dulu 4s) durasinya bisa di-custom lewat 1 input,
--    gak perlu edit tiap titik manual.
--  - Toggle "Show Next Point": nyalain beam/garis penunjuk arah dari character
--    ke titik tujuan berikutnya, plus marker bola kecil di titik itu.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

----------------------------------------------------------------
-- WAYPOINTS: {Position, fixedWait or nil, isLongWait}
-- Kalau isLongWait == true, waitTime dipakai dari `longWaitDuration` (custom)
-- Kalau isLongWait == false, pakai fixedWait apa adanya
----------------------------------------------------------------
local waypoints = {
    {Vector3.new(-145.35, -34.47, -161.18), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(-109.24, -24.17, -187.50), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(-128.69, -35.00, -183.10), 0.2, false},
    {Vector3.new(-141.02, -11.87, -188.26), 0.1, false},
    {Vector3.new(-126.94, -7.79, -206.08), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(-126.00, -3.75, -215.39), 0.1, false},
    {Vector3.new(102.89, -3.00, -326.25), 0.1, false},
    {Vector3.new(186.08, -3.47, -233.67), 0.1, false},
    {Vector3.new(223.61, -3.00, -204.31), 0.1, false},
    {Vector3.new(411.89, -3.67, 128.87), 0.1, false},
    {Vector3.new(461.60, 16.56, 142.94), 0.1, false},
    {Vector3.new(475.04, 12.85, 150.14), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(504.06, 12.74, 188.21), 0.1, false},
    {Vector3.new(470.37, 11.96, 235.59), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(663.29, 32.85, -186.40), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(697.37, 27.11, -182.30), 0.2, false},
    {Vector3.new(727.39, 24.90, -221.17), 0.2, false},
    {Vector3.new(740.64, 20.49, -277.09), 0.2, false},
    {Vector3.new(678.81, 52.51, -317.05), 0.2, false},
    {Vector3.new(682.06, 80.56, -372.30), 0.2, false},
    {Vector3.new(677.09, 78.95, -381.96), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(633.86, 48.47, -357.08), 0.2, false},
    {Vector3.new(580.62, 13.45, -350.00), 0.2, false},
    {Vector3.new(609.73, -6.18, -353.38), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(622.33, -6.21, -359.16), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(636.71, -7.20, -375.39), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(613.61, -6.25, -384.32), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(557.05, 11.62, -393.43), 0.2, false},
    {Vector3.new(-79.71, 5.00, -533.88), 0.2, false},
    {Vector3.new(-212.27, 25.33, -625.94), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(-291.56, -39.85, -678.88), 0.2, false},
    {Vector3.new(-226.31, -38.97, -633.08), 0.2, false},
    {Vector3.new(-149.40, -23.31, -563.70), 0.2, false},
    {Vector3.new(-118.20, -39.51, -611.25), 0.2, false},
    {Vector3.new(-146.85, -54.88, -631.76), 0.2, false},
    {Vector3.new(-177.84, -64.19, -608.29), 0.2, false},
    {Vector3.new(-208.41, -61.63, -626.84), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(-177.84, -64.19, -608.29), 0.2, false},
    {Vector3.new(-158.42, -64.82, -591.58), 0.2, false},
    {Vector3.new(-175.88, -63.80, -553.14), 0.2, false},
    {Vector3.new(-164.27, -63.02, -521.57), 0.2, false},
    {Vector3.new(-190.30, -66.24, -464.96), 0.2, false},
    {Vector3.new(-91.88, -103.00, -425.60), 0.2, false},
    {Vector3.new(-50.10, -103.00, -430.36), 0.1, false},
    {Vector3.new(18.88, -99.85, -411.12), 0.1, false},
    {Vector3.new(25.49, -99.01, -373.50), 0.1, false},
    {Vector3.new(37.75, -99.08, -370.12), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(56.27, -98.64, -358.45), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(17.02, -98.66, -387.86), 0.1, false},
    {Vector3.new(18.76, -99.90, -416.97), 0.1, false},
    {Vector3.new(-87.45, -102.32, -431.01), 0.2, false},
    {Vector3.new(-122.78, -102.90, -335.43), 0.1, false},
    {Vector3.new(-112.94, -91.12, -279.20), 0.1, false},
    {Vector3.new(-153.35, -87.36, -257.07), 0.1, false},
    {Vector3.new(-224.83, -83.06, -259.45), 0.1, false},
    {Vector3.new(-245.45, -82.74, -245.67), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(-224.83, -83.06, -259.45), 0.1, false},
    {Vector3.new(-245.03, -74.41, -297.54), 0.2, false},
    {Vector3.new(-252.99, -74.54, -314.63), 0.1, false},
    {Vector3.new(-303.95, -75.70, -371.95), nil, true}, -- LONG WAIT (custom)
    {Vector3.new(-252.99, -74.54, -314.63), 0.1, false},
    {Vector3.new(-245.03, -74.41, -297.54), 0.2, false},
    {Vector3.new(-224.83, -83.06, -259.45), 0.1, false},
    {Vector3.new(-303.95, -75.70, -371.95), 0.2, false},
    {Vector3.new(-89.26, -82.73, -218.67), 0.2, false},
    {Vector3.new(-49.30, -81.96, -213.02), 0.1, false},
    {Vector3.new(-10.98, -83.42, -182.03), 0.1, false},
    {Vector3.new(3.33, -80.45, -150.76), 0.2, false},
    {Vector3.new(46.73, -75.16, -141.67), 0.1, false},
    {Vector3.new(82.95, -71.91, -130.99), 0.1, false},
    {Vector3.new(92.68, -48.71, -48.34), 0.1, false},
    {Vector3.new(43.29, -36.63, -41.88), 0.2, false},
    {Vector3.new(-6.70, -32.38, -129.97), 0.2, false},
    {Vector3.new(-63.66, -35.00, -136.64), 9.0, false},
    {Vector3.new(-65.00, -35.03, -97.20), 0.1, false},
    {Vector3.new(-96.43, -35.47, -105.77), 0.1, false},
    {Vector3.new(-122.10, -36.63, -129.21), 0.1, false},
}

local DEFAULT_SPEED = 16
local currentSpeed = DEFAULT_SPEED
local DEFAULT_LONG_WAIT = 4.2
local longWaitDuration = DEFAULT_LONG_WAIT
local ARRIVE_THRESHOLD = 1.5

local showIndicator = false -- toggle state
local autoClickerOn = false -- toggle state autoclicker
local clickInterval = 0.1 -- detik antar klik (default 10 klik/detik)

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BodyVelocityPathGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Start/Stop button
local button = Instance.new("TextButton")
button.Name = "StartButton"
button.Size = UDim2.new(0, 160, 0, 45)
button.Position = UDim2.new(0, 20, 0, 20)
button.Text = "Start Path"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

-- Speed input
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedCaption"
speedLabel.Size = UDim2.new(0, 80, 0, 45)
speedLabel.Position = UDim2.new(0, 190, 0, 20)
speedLabel.Text = "Speed:"
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedLabel.BackgroundTransparency = 0.3
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Parent = screenGui

local cornerSpeedLabel = Instance.new("UICorner")
cornerSpeedLabel.CornerRadius = UDim.new(0, 8)
cornerSpeedLabel.Parent = speedLabel

local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedInput"
speedBox.Size = UDim2.new(0, 70, 0, 45)
speedBox.Position = UDim2.new(0, 280, 0, 20)
speedBox.Text = tostring(DEFAULT_SPEED)
speedBox.PlaceholderText = "16"
speedBox.TextScaled = true
speedBox.Font = Enum.Font.GothamBold
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.ClearTextOnFocus = false
speedBox.Parent = screenGui

local cornerSpeedBox = Instance.new("UICorner")
cornerSpeedBox.CornerRadius = UDim.new(0, 8)
cornerSpeedBox.Parent = speedBox

speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if num and num > 0 then
        currentSpeed = num
        speedBox.Text = tostring(num)
    else
        speedBox.Text = tostring(currentSpeed)
    end
end)

-- Long wait duration input
local longWaitLabel = Instance.new("TextLabel")
longWaitLabel.Name = "LongWaitCaption"
longWaitLabel.Size = UDim2.new(0, 110, 0, 45)
longWaitLabel.Position = UDim2.new(0, 360, 0, 20)
longWaitLabel.Text = "Long Wait:"
longWaitLabel.TextScaled = true
longWaitLabel.Font = Enum.Font.Gotham
longWaitLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
longWaitLabel.BackgroundTransparency = 0.3
longWaitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
longWaitLabel.Parent = screenGui

local cornerLongWaitLabel = Instance.new("UICorner")
cornerLongWaitLabel.CornerRadius = UDim.new(0, 8)
cornerLongWaitLabel.Parent = longWaitLabel

local longWaitBox = Instance.new("TextBox")
longWaitBox.Name = "LongWaitInput"
longWaitBox.Size = UDim2.new(0, 70, 0, 45)
longWaitBox.Position = UDim2.new(0, 480, 0, 20)
longWaitBox.Text = tostring(DEFAULT_LONG_WAIT)
longWaitBox.PlaceholderText = "4.2"
longWaitBox.TextScaled = true
longWaitBox.Font = Enum.Font.GothamBold
longWaitBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
longWaitBox.TextColor3 = Color3.fromRGB(255, 255, 255)
longWaitBox.ClearTextOnFocus = false
longWaitBox.Parent = screenGui

local cornerLongWaitBox = Instance.new("UICorner")
cornerLongWaitBox.CornerRadius = UDim.new(0, 8)
cornerLongWaitBox.Parent = longWaitBox

longWaitBox.FocusLost:Connect(function()
    local num = tonumber(longWaitBox.Text)
    if num and num >= 0 then
        longWaitDuration = num
        longWaitBox.Text = tostring(num)
    else
        longWaitBox.Text = tostring(longWaitDuration)
    end
end)

-- Toggle "Show Next Point" indicator
local indicatorToggle = Instance.new("TextButton")
indicatorToggle.Name = "IndicatorToggle"
indicatorToggle.Size = UDim2.new(0, 180, 0, 45)
indicatorToggle.Position = UDim2.new(0, 20, 0, 75)
indicatorToggle.Text = "Show Next Point: OFF"
indicatorToggle.TextScaled = true
indicatorToggle.Font = Enum.Font.GothamBold
indicatorToggle.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
indicatorToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
indicatorToggle.Parent = screenGui

local cornerToggle = Instance.new("UICorner")
cornerToggle.CornerRadius = UDim.new(0, 8)
cornerToggle.Parent = indicatorToggle

-- Toggle Autoclicker
local autoClickerToggle = Instance.new("TextButton")
autoClickerToggle.Name = "AutoClickerToggle"
autoClickerToggle.Size = UDim2.new(0, 180, 0, 45)
autoClickerToggle.Position = UDim2.new(0, 210, 0, 75)
autoClickerToggle.Text = "Autoclicker: OFF"
autoClickerToggle.TextScaled = true
autoClickerToggle.Font = Enum.Font.GothamBold
autoClickerToggle.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
autoClickerToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoClickerToggle.Parent = screenGui

local cornerAutoClicker = Instance.new("UICorner")
cornerAutoClicker.CornerRadius = UDim.new(0, 8)
cornerAutoClicker.Parent = autoClickerToggle

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 400, 0, 40)
statusLabel.Position = UDim2.new(0, 20, 0, 185)
statusLabel.Text = "Status: Idle"
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statusLabel.BackgroundTransparency = 0.3
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Parent = screenGui

local cornerLabel = Instance.new("UICorner")
cornerLabel.CornerRadius = UDim.new(0, 8)
cornerLabel.Parent = statusLabel

----------------------------------------------------------------
-- AUTOCLICKER PANEL (target reticle draggable + interval input)
----------------------------------------------------------------
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local autoClickerPanel = Instance.new("Frame")
autoClickerPanel.Name = "AutoClickerPanel"
autoClickerPanel.Size = UDim2.new(0, 220, 0, 90)
autoClickerPanel.Position = UDim2.new(0, 210, 0, 130)
autoClickerPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
autoClickerPanel.BackgroundTransparency = 0.3
autoClickerPanel.Visible = false
autoClickerPanel.Parent = screenGui

local cornerAutoPanel = Instance.new("UICorner")
cornerAutoPanel.CornerRadius = UDim.new(0, 8)
cornerAutoPanel.Parent = autoClickerPanel

local intervalLabel = Instance.new("TextLabel")
intervalLabel.Name = "IntervalCaption"
intervalLabel.Size = UDim2.new(0, 120, 0, 35)
intervalLabel.Position = UDim2.new(0, 10, 0, 10)
intervalLabel.Text = "Interval (s):"
intervalLabel.TextScaled = true
intervalLabel.Font = Enum.Font.Gotham
intervalLabel.BackgroundTransparency = 1
intervalLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalLabel.Parent = autoClickerPanel

local intervalBox = Instance.new("TextBox")
intervalBox.Name = "IntervalInput"
intervalBox.Size = UDim2.new(0, 70, 0, 35)
intervalBox.Position = UDim2.new(0, 140, 0, 10)
intervalBox.Text = tostring(clickInterval)
intervalBox.PlaceholderText = "0.1"
intervalBox.TextScaled = true
intervalBox.Font = Enum.Font.GothamBold
intervalBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
intervalBox.TextColor3 = Color3.fromRGB(255, 255, 255)
intervalBox.ClearTextOnFocus = false
intervalBox.Parent = autoClickerPanel

local cornerIntervalBox = Instance.new("UICorner")
cornerIntervalBox.CornerRadius = UDim.new(0, 6)
cornerIntervalBox.Parent = intervalBox

intervalBox.FocusLost:Connect(function()
    local num = tonumber(intervalBox.Text)
    if num and num > 0 then
        clickInterval = num
        intervalBox.Text = tostring(num)
    else
        intervalBox.Text = tostring(clickInterval)
    end
end)

local clickCountLabel = Instance.new("TextLabel")
clickCountLabel.Name = "ClickCountLabel"
clickCountLabel.Size = UDim2.new(0, 200, 0, 30)
clickCountLabel.Position = UDim2.new(0, 10, 0, 50)
clickCountLabel.Text = "Clicks: 0"
clickCountLabel.TextScaled = true
clickCountLabel.Font = Enum.Font.Gotham
clickCountLabel.BackgroundTransparency = 1
clickCountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
clickCountLabel.Parent = autoClickerPanel

-- Target reticle (draggable)
local reticle = Instance.new("Frame")
reticle.Name = "AutoClickTarget"
reticle.Size = UDim2.new(0, 50, 0, 50)
reticle.Position = UDim2.new(0.5, -25, 0.5, -25)
reticle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
reticle.BackgroundTransparency = 0.4
reticle.Visible = false
reticle.ZIndex = 10
reticle.Parent = screenGui

local reticleCorner = Instance.new("UICorner")
reticleCorner.CornerRadius = UDim.new(1, 0) -- bulat
reticleCorner.Parent = reticle

local reticleStroke = Instance.new("UIStroke")
reticleStroke.Thickness = 3
reticleStroke.Color = Color3.fromRGB(255, 255, 255)
reticleStroke.Parent = reticle

local reticleDot = Instance.new("Frame")
reticleDot.Size = UDim2.new(0, 8, 0, 8)
reticleDot.Position = UDim2.new(0.5, -4, 0.5, -4)
reticleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
reticleDot.ZIndex = 11
reticleDot.Parent = reticle

local reticleDotCorner = Instance.new("UICorner")
reticleDotCorner.CornerRadius = UDim.new(1, 0)
reticleDotCorner.Parent = reticleDot

-- Drag logic buat reticle
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

reticle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = reticle.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

reticle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        reticle.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Loop autoclicker: kirim klik mouse ke posisi reticle tiap `clickInterval`
local autoClickRunId = 0
local totalClicks = 0

local function getReticleScreenPosition()
    local absPos = reticle.AbsolutePosition
    local absSize = reticle.AbsoluteSize
    return absPos + absSize / 2 -- titik tengah reticle
end

local function runAutoClicker(thisRunId)
    totalClicks = 0
    while autoClickerOn and thisRunId == autoClickRunId do
        local pos = getReticleScreenPosition()
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
        totalClicks += 1
        clickCountLabel.Text = "Clicks: " .. totalClicks
        task.wait(clickInterval)
    end
end

autoClickerToggle.MouseButton1Click:Connect(function()
    autoClickerOn = not autoClickerOn
    autoClickerToggle.Text = "Autoclicker: " .. (autoClickerOn and "ON" or "OFF")
    autoClickerToggle.BackgroundColor3 = autoClickerOn
        and Color3.fromRGB(30, 90, 40)
        or Color3.fromRGB(80, 30, 30)

    autoClickerPanel.Visible = autoClickerOn
    reticle.Visible = autoClickerOn

    if autoClickerOn then
        autoClickRunId += 1
        task.spawn(runAutoClicker, autoClickRunId)
    else
        autoClickRunId += 1 -- invalidate loop lama
    end
end)

----------------------------------------------------------------
-- NEXT-POINT INDICATOR (beam + marker)
----------------------------------------------------------------
local indicatorFolder = Instance.new("Folder")
indicatorFolder.Name = "PathIndicatorFolder"
indicatorFolder.Parent = workspace

local markerPart = Instance.new("Part")
markerPart.Name = "NextPointMarker"
markerPart.Shape = Enum.PartType.Ball
markerPart.Size = Vector3.new(2, 2, 2)
markerPart.Anchored = true
markerPart.CanCollide = false
markerPart.CanQuery = false
markerPart.Material = Enum.Material.Neon
markerPart.Color = Color3.fromRGB(255, 200, 0)
markerPart.Transparency = 1 -- disembunyikan default
markerPart.Parent = indicatorFolder

local markerAttachment = Instance.new("Attachment")
markerAttachment.Parent = markerPart

local sourceAttachment = nil -- dipasang ke HRP saat character ada

local beam = Instance.new("Beam")
beam.Name = "NextPointBeam"
beam.Width0 = 0.4
beam.Width1 = 0.15
beam.Color = ColorSequence.new(Color3.fromRGB(255, 200, 0))
beam.Transparency = NumberSequence.new(0.2)
beam.FaceCamera = true
beam.Enabled = false
beam.Parent = markerPart

local function setupIndicatorForCharacter(hrp)
    if sourceAttachment then
        sourceAttachment:Destroy()
    end
    sourceAttachment = Instance.new("Attachment")
    sourceAttachment.Name = "PathIndicatorSource"
    sourceAttachment.Parent = hrp

    beam.Attachment0 = sourceAttachment
    beam.Attachment1 = markerAttachment
end

local function updateIndicatorTarget(targetPos)
    markerPart.Position = targetPos
end

local function setIndicatorVisible(visible)
    beam.Enabled = visible
    markerPart.Transparency = visible and 0.2 or 1
end

indicatorToggle.MouseButton1Click:Connect(function()
    showIndicator = not showIndicator
    indicatorToggle.Text = "Show Next Point: " .. (showIndicator and "ON" or "OFF")
    indicatorToggle.BackgroundColor3 = showIndicator
        and Color3.fromRGB(30, 90, 40)
        or Color3.fromRGB(80, 30, 30)
    setIndicatorVisible(showIndicator)
end)

----------------------------------------------------------------
-- MOVEMENT LOGIC (BodyVelocity)
----------------------------------------------------------------
local isRunning = false
local runId = 0
local bodyVelocity = nil

local function getCharacterParts()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    return character, hrp, humanoid
end

local function createBodyVelocity(hrp)
    local bv = Instance.new("BodyVelocity")
    bv.Name = "PathBodyVelocity"
    bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
    bv.Velocity = Vector3.zero
    bv.P = 1250
    bv.Parent = hrp
    return bv
end

local function moveToPoint(hrp, targetPos, thisRunId)
    local reached = false

    while isRunning and thisRunId == runId and not reached do
        local currentPos = hrp.Position
        local toTarget = targetPos - currentPos
        local distance = toTarget.Magnitude

        if distance <= ARRIVE_THRESHOLD then
            bodyVelocity.Velocity = Vector3.zero
            reached = true
        else
            local direction = toTarget.Unit
            bodyVelocity.Velocity = direction * currentSpeed
        end

        RunService.Heartbeat:Wait()
    end

    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.zero
    end
end

local function runPathLoop(thisRunId)
    local character, hrp, humanoid = getCharacterParts()

    bodyVelocity = createBodyVelocity(hrp)
    setupIndicatorForCharacter(hrp)
    setIndicatorVisible(showIndicator)

    while isRunning and thisRunId == runId do
        for i, waypoint in ipairs(waypoints) do
            if not isRunning or thisRunId ~= runId then break end

            local targetPos = waypoint[1]
            local fixedWait = waypoint[2]
            local isLongWait = waypoint[3]
            local waitTime = isLongWait and longWaitDuration or fixedWait

            -- update indicator ke titik tujuan saat ini
            updateIndicatorTarget(targetPos)

            statusLabel.Text = string.format("Menuju titik %d/%d", i, #waypoints)
            moveToPoint(hrp, targetPos, thisRunId)

            if not isRunning or thisRunId ~= runId then break end

            if waitTime and waitTime > 0 then
                statusLabel.Text = string.format("Diam di titik %d/%d (%.1fs)", i, #waypoints, waitTime)
                task.wait(waitTime)
            end
        end
    end

    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end

    setIndicatorVisible(false)

    if thisRunId == runId then
        statusLabel.Text = "Status: Idle"
    end
end

button.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        runId += 1
        button.Text = "Stop Path"
        statusLabel.Text = "Status: Starting..."
        task.spawn(runPathLoop, runId)
    else
        isRunning = false
        runId += 1
        button.Text = "Start Path"
        statusLabel.Text = "Status: Stopping..."

        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end

        setIndicatorVisible(false)
    end
end)
