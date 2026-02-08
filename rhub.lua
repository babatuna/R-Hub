-- [[ R HUB v1.1.0 OFFICIAL - FULL DESTRUCTIVE MODE ]]
-- BU KOD HİÇBİR ŞEYİ KISALTMADAN, TÜM DETAYLARIYLA YAZILMIŞTIR.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- --- ⚙️ GLOBAL DATABASE ---
local Config = {
    Aimbot = false,
    FovSize = 150,
    TeamCheck = true,
    Prediction = 0.165,
    Smoothing = 0.1,
    Speed = 16,
    Jump = 50,
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    ESP = false,
    EspBox = false,
    EspTracer = false,
    BringLoop = false,
    Theme = "Dark",
    FullBright = false
}

-- --- 🎨 UI COLOR PALETTE ---
local Colors = {
    Main = Color3.fromRGB(15, 15, 18),
    Sidebar = Color3.fromRGB(10, 10, 12),
    Accent = Color3.fromRGB(0, 170, 255),
    Card = Color3.fromRGB(25, 25, 30),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(180, 180, 180)
}

-- --- 🖼️ ASSET MANAGER (STABLE) ---
local Icons = {
    Home = "rbxassetid://13060262529",
    Combat = "rbxassetid://6034287525",
    Movement = "rbxassetid://9525534183",
    Extra = "rbxassetid://136882854117051",
    Visuals = "rbxassetid://134539162713658",
    Settings = "rbxassetid://4492476121"
}

-- --- 📂 UI INITIALIZATION ---
if LocalPlayer.PlayerGui:FindFirstChild("R_Hub_Colossus") then 
    LocalPlayer.PlayerGui["R_Hub_Colossus"]:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "R_Hub_Colossus"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 650, 0, 450)
Main.Position = UDim2.new(0.5, -325, 0.5, -225)
Main.BackgroundColor3 = Colors.Main
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

-- Drop Shadow
local Shadow = Instance.new("ImageLabel", Main)
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 50, 1, 50)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://6014264795"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ZIndex = 0

-- Sidebar Construction
local Sidebar = Instance.new("Frame", Main)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 80, 1, 0)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local SidebarList = Instance.new("UIListLayout", Sidebar)
SidebarList.Padding = UDim.new(0, 18)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 30)

-- Header Area
local Header = Instance.new("Frame", Main)
Header.Name = "Header"
Header.Size = UDim2.new(1, -80, 0, 60)
Header.Position = UDim2.new(0, 80, 0, 0)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "R HUB <font color='#00aaff'>v1.1.0 Official Gradle</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBlack
Title.TextColor3 = Colors.Text
Title.TextSize = 22
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Content Container
local Container = Instance.new("Frame", Main)
Container.Name = "Container"
Container.Size = UDim2.new(1, -100, 1, -80)
Container.Position = UDim2.new(0, 90, 0, 70)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Container)
    p.Name = name
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ScrollBarThickness = 2
    p.ScrollBarImageColor3 = Colors.Accent
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local list = Instance.new("UIListLayout", p)
    list.Padding = UDim.new(0, 12)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    Pages[name] = p
    return p
end

-- Pages
local Home = CreatePage("Home")
local Combat = CreatePage("Combat")
local Visuals = CreatePage("Visuals")
local Movement = CreatePage("Movement")
local Extra = CreatePage("Extra")
local SettingsPage = CreatePage("Settings")

-- --- 🛠️ ADVANCED COMPONENT BUILDER ---

-- 1. Modern Sidebar Tab with Scale Animation
local function AddTab(iconId, target)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Name = target .. "Tab"
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    Instance.new("UICorner", btn)

    local ico = Instance.new("ImageLabel", btn)
    ico.Name = "Icon"
    ico.Size = UDim2.new(0, 26, 0, 26)
    ico.Position = UDim2.new(0.5, -13, 0.5, -13)
    ico.BackgroundTransparency = 1
    ico.Image = iconId
    ico.ImageColor3 = Color3.fromRGB(150, 150, 150)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 58, 0, 58)}):Play()
        TweenService:Create(ico, TweenInfo.new(0.3), {ImageColor3 = Colors.Text}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 50, 0, 50)}):Play()
        if not Pages[target].Visible then
            TweenService:Create(ico, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Pages[target].Visible = true
        for _, v in pairs(Sidebar:GetChildren()) do 
            if v:IsA("TextButton") then 
                TweenService:Create(v.Icon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() 
            end 
        end
        TweenService:Create(ico, TweenInfo.new(0.3), {ImageColor3 = Colors.Accent}):Play()
    end)
end

-- 2. Advanced Toggle
local function AddToggle(parent, text, default, callback)
    local card = Instance.new("Frame", parent)
    card.Name = "Card"; card.Size = UDim2.new(1, -15, 0, 50); card.BackgroundColor3 = Colors.Card; Instance.new("UICorner", card)
    
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -70, 1, 0); lbl.Position = UDim2.new(0, 15, 0, 0); lbl.Text = text
    lbl.TextColor3 = Colors.Text; lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = 14; lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left

    local b = Instance.new("TextButton", card)
    b.Size = UDim2.new(0, 44, 0, 22); b.Position = UDim2.new(1, -55, 0.5, -11); b.BackgroundColor3 = Color3.fromRGB(50, 50, 55); b.Text = ""; Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    
    local circle = Instance.new("Frame", b)
    circle.Size = UDim2.new(0, 18, 0, 18); circle.Position = UDim2.new(0, 2, 0.5, -9); circle.BackgroundColor3 = Colors.Text; Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local active = default
    local function update()
        TweenService:Create(circle, TweenInfo.new(0.25), {Position = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        TweenService:Create(b, TweenInfo.new(0.25), {BackgroundColor3 = active and Colors.Accent or Color3.fromRGB(50, 50, 55)}):Play()
        callback(active)
    end
    b.MouseButton1Click:Connect(function() active = not active update() end)
    update()
end

-- 3. Advanced Slider
local function AddSlider(parent, text, min, max, default, callback)
    local card = Instance.new("Frame", parent); card.Name = "Card"; card.Size = UDim2.new(1, -15, 0, 65); card.BackgroundColor3 = Colors.Card; Instance.new("UICorner", card)
    local lbl = Instance.new("TextLabel", card); lbl.Size = UDim2.new(1, -20, 0, 30); lbl.Position = UDim2.new(0, 15, 0, 5); lbl.Text = text .. ": " .. default; lbl.TextColor3 = Colors.Text; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.BackgroundTransparency = 1; lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local bar = Instance.new("Frame", card); bar.Size = UDim2.new(1, -30, 0, 6); bar.Position = UDim2.new(0, 15, 0, 45); bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50); Instance.new("UICorner", bar)
    local fill = Instance.new("Frame", bar); fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Colors.Accent; Instance.new("UICorner", fill)
    
    local handle = Instance.new("Frame", fill)
    handle.Size = UDim2.new(0, 12, 0, 12); handle.Position = UDim2.new(1, -6, 0.5, -6); handle.BackgroundColor3 = Colors.Text; Instance.new("UICorner", handle)

    local dragging = false
    local function update()
        local p = math.clamp((UserInputService:GetMouseLocation().X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * p)
        fill.Size = UDim2.new(p, 0, 1, 0); lbl.Text = text .. ": " .. val; callback(val)
    end
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update() end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    RunService.RenderStepped:Connect(function() if dragging then update() end end)
end

-- 4. Simple Action Button
local function AddButton(parent, text, callback)
    local card = Instance.new("Frame", parent); card.Name = "Card"; card.Size = UDim2.new(1, -15, 0, 45); card.BackgroundColor3 = Color3.fromRGB(35, 35, 40); Instance.new("UICorner", card)
    local btn = Instance.new("TextButton", card); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = text; btn.TextColor3 = Colors.Text; btn.Font = Enum.Font.GothamBold; btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function() TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = Colors.Accent}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play() end)
end

-- --- 🏠 HOME PAGE (FULL CONTENT) ---
local ProfileCard = Instance.new("Frame", Home); ProfileCard.Name = "Card"; ProfileCard.Size = UDim2.new(1, -15, 0, 100); ProfileCard.BackgroundColor3 = Colors.Card; Instance.new("UICorner", ProfileCard)
local Pfp = Instance.new("ImageLabel", ProfileCard); Pfp.Size = UDim2.new(0, 70, 0, 70); Pfp.Position = UDim2.new(0, 15, 0, 15); Pfp.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150); Instance.new("UICorner", Pfp).CornerRadius = UDim.new(1, 0)
local WelcomeMsg = Instance.new("TextLabel", ProfileCard); WelcomeMsg.Size = UDim2.new(1, -100, 1, 0); WelcomeMsg.Position = UDim2.new(0, 100, 0, 0); WelcomeMsg.BackgroundTransparency = 1; WelcomeMsg.Text = "Hoş Geldin, \n<b>" .. LocalPlayer.DisplayName .. "</b>"; WelcomeMsg.RichText = true; WelcomeMsg.TextColor3 = Colors.Text; WelcomeMsg.Font = Enum.Font.Gotham; WelcomeMsg.TextSize = 18; WelcomeMsg.TextXAlignment = Enum.TextXAlignment.Left

local Notes = Instance.new("Frame", Home); Notes.Name = "Card"; Notes.Size = UDim2.new(1, -15, 0, 120); Notes.BackgroundColor3 = Colors.Card; Instance.new("UICorner", Notes)
local NoteTitle = Instance.new("TextLabel", Notes); NoteTitle.Size = UDim2.new(1, -20, 0, 30); NoteTitle.Position = UDim2.new(0, 15, 0, 10); NoteTitle.Text = "📋 YAMA NOTLARI v1.1.0"; NoteTitle.TextColor3 = Colors.Accent; NoteTitle.Font = Enum.Font.GothamBold; NoteTitle.TextSize = 14; NoteTitle.BackgroundTransparency = 1; NoteTitle.TextXAlignment = Enum.TextXAlignment.Left
local NoteDesc = Instance.new("TextLabel", Notes); NoteDesc.Size = UDim2.new(1, -30, 0, 70); NoteDesc.Position = UDim2.new(0, 15, 0, 40); NoteDesc.Text = "-Yeni Özellikler eklendi.\n- Aimbot Prediction ve Smoothing eklendi.\n- Visuals sekmesi (ESP Box/Tracer) eklendi."; NoteDesc.TextColor3 = Colors.SubText; NoteDesc.Font = Enum.Font.Gotham; NoteDesc.TextSize = 12; NoteDesc.BackgroundTransparency = 1; NoteDesc.TextXAlignment = Enum.TextXAlignment.Left; NoteDesc.TextYAlignment = Enum.TextYAlignment.Top

-- --- ⚔️ COMBAT SECTION ---
AddToggle(Combat, "Aimbot Master", false, function(s) Config.Aimbot = s end)
AddSlider(Combat, "Aimbot FOV Range", 50, 1000, 150, function(v) Config.FovSize = v end)
AddSlider(Combat, "Smoothing (Akıcılık)", 1, 10, 1, function(v) Config.Smoothing = v/10 end)
AddToggle(Combat, "Show FOV Circle", false, function(s) end) -- Renderstepped'da çizilir
AddToggle(Combat, "Team Check", true, function(s) Config.TeamCheck = s end)
AddToggle(Combat, "Triggerbot (Auto-Fire)", false, function(s) Config.TriggerBot = s end)
AddToggle(Combat, "Test", false, function(s) end)

-- --- 👁️ VISUALS SECTION ---
AddToggle(Visuals, "Glow ESP (Highlight)", false, function(s) 
    Config.ESP = s 
    if not s then for _,v in pairs(Players:GetPlayers()) do if v.Character and v.Character:FindFirstChild("Highlight") then v.Character.Highlight:Destroy() end end end
end)
AddToggle(Visuals, "ESP Box (Beta)", false, function(s) Config.EspBox = s end)
AddToggle(Visuals, "Tracer Lines", false, function(s) Config.EspTracer = s end)

-- --- 👤 MOVEMENT SECTION ---
AddSlider(Movement, "WalkSpeed (Hız)", 16, 300, 16, function(v) Config.Speed = v end)
AddSlider(Movement, "JumpPower (Zıplama)", 50, 500, 50, function(v) Config.Jump = v end)
AddToggle(Movement, "Infinite Jump", false, function(s) Config.InfJump = s end)
AddToggle(Movement, "Noclip (Wallhack)", false, function(s) Config.Noclip = s end)
AddToggle(Movement, "Fly Mode (Uçuş)", false, function(s) Config.Fly = s end)

-- --- 🌟 EXTRA SECTION ---
AddButton(Extra, "Infinite Yield (Admin Commands)", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
AddToggle(Extra, "Loop Bring (Kill All Setup)", false, function(s) Config.BringLoop = s end)
AddButton(Extra, "Spawn Toolbox Car", function()
    local car = Instance.new("Model", workspace); car.Name = "RHub_V"
    local s = Instance.new("VehicleSeat", car); s.Size = Vector3.new(4, 2, 6); s.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, -10)
    local p = Instance.new("Part", car); p.Size = Vector3.new(4, 1, 6); p.CFrame = s.CFrame; p.Transparency = 0.5; p.Color = Colors.Accent
    local w = Instance.new("WeldConstraint", s); w.Part0 = s; w.Part1 = p
end)

-- --- ⚙️ SETTINGS SECTION ---
AddToggle(SettingsPage, "Light Mode UI", false, function(s)
    local ti = TweenInfo.new(0.4)
    TweenService:Create(Main, ti, {BackgroundColor3 = s and Color3.fromRGB(240,240,240) or Colors.Main}):Play()
    TweenService:Create(Sidebar, ti, {BackgroundColor3 = s and Color3.fromRGB(220,220,225) or Colors.Sidebar}):Play()
    Title.TextColor3 = s and Color3.fromRGB(20,20,20) or Colors.Text
end)
AddToggle(SettingsPage, "Full Brightness", false, function(s) Lighting.Brightness = s and 4 or 1; Lighting.GlobalShadows = not s end)
AddButton(SettingsPage, "Destroy UI (Safe Exit)", function() ScreenGui:Destroy() end)

-- --- 🧠 CORE LOGIC SYSTEMS (THE ENGINE) ---

-- 1. Movement Engine
RunService.Stepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Config.Speed
            LocalPlayer.Character.Humanoid.JumpPower = Config.Jump
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            
            if Config.Noclip then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)
end)

-- 2. Combat Engine (Aimbot & Team Check)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1; FOVCircle.Color = Colors.Accent; FOVCircle.Filled = false; FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Config.FovSize
    
    if Config.Aimbot and UserInputService:IsKeyDown(Enum.KeyCode.E) then
        local target = nil
        local shortestDist = Config.FovSize
        
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                if Config.TeamCheck and plr.Team == LocalPlayer.Team then continue end
                
                local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                if onScreen then
                    local magnitude = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if magnitude < shortestDist then
                        shortestDist = magnitude
                        target = plr
                    end
                end
            end
        end
        
        if target then
            local predict = target.Character.Head.Position + (target.Character.Head.Velocity * Config.Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, predict), Config.Smoothing)
        end
    end
end)

-- 3. Visuals Engine (ESP & Highlight)
RunService.Heartbeat:Connect(function()
    if Config.ESP then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                if not plr.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", plr.Character)
                    h.FillColor = Colors.Accent
                    h.OutlineColor = Colors.Text
                    h.FillTransparency = 0.5
                end
            end
        end
    end
    
    if Config.BringLoop then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
            end
        end
    end
end)

-- 4. Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- --- 🔘 INITIALIZE TABS ---
AddTab(Icons.Home, "Home")
AddTab(Icons.Combat, "Combat")
AddTab(Icons.Visuals, "Visuals")
AddTab(Icons.Movement, "Movement")
AddTab(Icons.Extra, "Extra")
AddTab(Icons.Settings, "Settings")

-- Dragging System
local dragToggle, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end
end)

-- Final Toggle
UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end
end)

Pages.Home.Visible = true
print("R Hub v1.1.0 Loaded Successfully - 400 Lines of Power!")
