-- LocalScript, taruh di StarterPlayerScripts
-- GUI dengan tombol Start/Stop Tween, character akan bergerak
-- mengikuti waypoint dengan speed setara jalan default (16 studs/detik),
-- lalu diam sesuai durasi tiap titik, dan repeat (loop) terus menerus.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

----------------------------------------------------------------
-- WAYPOINTS: {Position, waitTime}
----------------------------------------------------------------
local waypoints = {
    {Vector3.new(-145.35, -34.47, -161.18), 4.0},
    {Vector3.new(-111.17, -26.47, -188.23), 4.0},
    {Vector3.new(-128.69, -35.00, -183.10), 0.2},
    {Vector3.new(-135.87, -7.03, -205.82), 4.0},
    {Vector3.new(-126.00, -3.75, -215.39), 0.1},
    {Vector3.new(223.61, -3.00, -204.31), 0.1},
    {Vector3.new(461.60, 16.56, 142.94), 0.1},
    {Vector3.new(475.04, 12.85, 150.14), 4.0},
    {Vector3.new(504.06, 12.74, 188.21), 0.1},
    {Vector3.new(470.37, 11.96, 235.59), 4.0},
    {Vector3.new(663.29, 32.85, -186.40), 4.0},
    {Vector3.new(697.37, 27.11, -182.30), 0.2},
    {Vector3.new(727.39, 24.90, -221.17), 0.2},
    {Vector3.new(740.64, 20.49, -277.09), 0.2},
    {Vector3.new(678.81, 52.51, -317.05), 0.2},
    {Vector3.new(682.06, 80.56, -372.30), 0.2},
    {Vector3.new(677.09, 78.95, -381.96), 4.0},
    {Vector3.new(633.86, 48.47, -357.08), 0.2},
    {Vector3.new(580.62, 13.45, -350.00), 0.2},
    {Vector3.new(609.73, -6.18, -353.38), 4.0},
    {Vector3.new(622.33, -6.21, -359.16), 4.0},
    {Vector3.new(636.71, -7.20, -375.39), 4.0},
    {Vector3.new(613.61, -6.25, -384.32), 4.0},
    {Vector3.new(557.05, 11.62, -393.43), 0.2},
    {Vector3.new(-79.71, 5.00, -533.88), 0.2},
    {Vector3.new(-212.27, 25.33, -625.94), 4.0},
    {Vector3.new(-291.56, -39.85, -678.88), 0.2},
    {Vector3.new(-226.31, -38.97, -633.08), 0.2},
    {Vector3.new(-149.40, -23.31, -563.70), 0.2},
    {Vector3.new(-118.20, -39.51, -611.25), 0.2},
    {Vector3.new(-146.85, -54.88, -631.76), 0.2},
    {Vector3.new(-177.84, -64.19, -608.29), 0.2},
    {Vector3.new(-208.41, -61.63, -626.84), 4.0},
    {Vector3.new(-177.84, -64.19, -608.29), 0.2},
    {Vector3.new(-158.42, -64.82, -591.58), 0.2},
    {Vector3.new(-175.88, -63.80, -553.14), 0.2},
    {Vector3.new(-164.27, -63.02, -521.57), 0.2},
    {Vector3.new(-190.30, -66.24, -464.96), 0.2},
    {Vector3.new(-91.88, -103.00, -425.60), 0.2},
    {Vector3.new(-50.10, -103.00, -430.36), 0.1},
    {Vector3.new(18.88, -99.85, -411.12), 0.1},
    {Vector3.new(25.49, -99.01, -373.50), 0.1},
    {Vector3.new(37.75, -99.08, -370.12), 4.0},
    {Vector3.new(56.27, -98.64, -358.45), 4.0},
    {Vector3.new(17.02, -98.66, -387.86), 0.1},
    {Vector3.new(18.76, -99.90, -416.97), 0.1},
    {Vector3.new(-87.45, -102.32, -431.01), 0.2},
    {Vector3.new(-122.78, -102.90, -335.43), 0.1},
    {Vector3.new(-112.94, -91.12, -279.20), 0.1},
    {Vector3.new(-153.35, -87.36, -257.07), 0.1},
    {Vector3.new(-224.83, -83.06, -259.45), 0.1},
    {Vector3.new(-245.45, -82.74, -245.67), 4.0},
    {Vector3.new(-224.83, -83.06, -259.45), 0.1},
    {Vector3.new(-245.03, -74.41, -297.54), 0.2},
    {Vector3.new(-252.99, -74.54, -314.63), 0.1},
    {Vector3.new(-303.95, -75.70, -371.95), 4.0},
    {Vector3.new(-252.99, -74.54, -314.63), 0.1},
    {Vector3.new(-245.03, -74.41, -297.54), 0.2},
    {Vector3.new(-224.83, -83.06, -259.45), 0.1},
    {Vector3.new(-303.95, -75.70, -371.95), 0.2},
    {Vector3.new(-89.26, -82.73, -218.67), 0.2},
    {Vector3.new(-49.30, -81.96, -213.02), 0.1},
    {Vector3.new(-10.98, -83.42, -182.03), 0.1},
    {Vector3.new(3.33, -80.45, -150.76), 0.2},
    {Vector3.new(46.73, -75.16, -141.67), 0.1},
    {Vector3.new(82.95, -71.91, -130.99), 0.1},
    {Vector3.new(92.68, -48.71, -48.34), 0.1},
    {Vector3.new(43.29, -36.63, -41.88), 0.2},
    {Vector3.new(-6.70, -32.38, -129.97), 0.2},
    {Vector3.new(-63.66, -35.00, -136.64), 9.0},
    {Vector3.new(-65.00, -35.03, -97.20), 0.1},
    {Vector3.new(-96.43, -35.47, -105.77), 0.1},
    {Vector3.new(-122.10, -36.63, -129.21), 0.1},
}

local DEFAULT_SPEED = 16 -- studs/detik, sama kayak default WalkSpeed
local currentSpeed = DEFAULT_SPEED -- bisa diubah lewat GUI

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TweenPathGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Name = "StartTweenButton"
button.Size = UDim2.new(0, 180, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.Text = "Start Tween"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

-- Input custom speed
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedCaption"
speedLabel.Size = UDim2.new(0, 90, 0, 50)
speedLabel.Position = UDim2.new(0, 210, 0, 20)
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
speedBox.Size = UDim2.new(0, 80, 0, 50)
speedBox.Position = UDim2.new(0, 310, 0, 20)
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

-- Validasi & update speed setiap kali player selesai ngetik (Enter / lost focus)
speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if num and num > 0 then
        currentSpeed = num
        speedBox.Text = tostring(num)
    else
        -- input gak valid, balikin ke speed yang lagi aktif
        speedBox.Text = tostring(currentSpeed)
    end
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 370, 0, 40)
statusLabel.Position = UDim2.new(0, 20, 0, 80)
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
-- TWEEN LOGIC
----------------------------------------------------------------
local isRunning = false
local currentTween = nil
local runId = 0 -- dipakai buat cancel loop lama kalau tombol ditekan lagi

local function getCharacterParts()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    return character, hrp, humanoid
end

local function runTweenLoop(thisRunId)
    local character, hrp, humanoid = getCharacterParts()

    -- Anchor biar gerakan smooth, gak kena physics/collision aneh
    hrp.Anchored = true

    while isRunning and thisRunId == runId do
        for i, waypoint in ipairs(waypoints) do
            if not isRunning or thisRunId ~= runId then break end

            local targetPos = waypoint[1]
            local waitTime = waypoint[2]

            local currentPos = hrp.Position
            local distance = (targetPos - currentPos).Magnitude
            local duration = distance / currentSpeed

            if duration > 0 then
                local tweenInfo = TweenInfo.new(
                    duration,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.InOut
                )
                local targetCFrame = CFrame.new(targetPos, targetPos + (targetPos - currentPos))
                -- pertahankan rotasi menghadap arah gerak (opsional, bisa dihapus kalau gak perlu)
                local goalCFrame = CFrame.new(targetPos)

                currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = goalCFrame})
                currentTween:Play()

                statusLabel.Text = string.format("Menuju titik %d/%d", i, #waypoints)

                currentTween.Completed:Wait()
            end

            if not isRunning or thisRunId ~= runId then break end

            if waitTime > 0 then
                statusLabel.Text = string.format("Diam di titik %d/%d (%.1fs)", i, #waypoints, waitTime)
                task.wait(waitTime)
            end
        end
        -- selesai satu putaran, balik ke awal (loop)
    end

    if thisRunId == runId then
        hrp.Anchored = false
        statusLabel.Text = "Status: Idle"
    end
end

button.MouseButton1Click:Connect(function()
    if not isRunning then
        isRunning = true
        runId += 1
        button.Text = "Stop Tween"
        statusLabel.Text = "Status: Starting..."
        task.spawn(runTweenLoop, runId)
    else
        isRunning = false
        runId += 1 -- invalidate loop yang sedang jalan
        button.Text = "Start Tween"
        statusLabel.Text = "Status: Stopping..."

        -- unanchor manual kalau lagi di tengah tween
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = false
            end
        end
    end
end)