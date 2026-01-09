-- 音乐设置GUI for Roblox
local MusicSettingsGUI = {}
MusicSettingsGUI.__index = MusicSettingsGUI

-- 导入之前的音乐播放器（假设已经存在）
local MusicPlayer = getgenv().MusicPlayer or require(script.Parent.MusicPlayer)

function MusicSettingsGUI.new()
    local self = setmetatable({}, MusicSettingsGUI)
    self.gui = nil
    self.visible = false
    self:createGUI()
    return self
end

function MusicSettingsGUI:createGUI()
    -- 创建主窗口
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "MusicSettingsGUI"
    self.gui.ResetOnSpawn = false
    
    -- 主窗口框架
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- 标题栏
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    titleBar.BorderSizePixel = 0
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "音乐播放器设置"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    
    -- 关闭按钮
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    
    closeButton.MouseButton1Click:Connect(function()
        self:toggle()
    end)
    
    -- 内容区域
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -60)
    contentFrame.Position = UDim2.new(0, 10, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 4
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    -- 组装UI
    titleBar.Parent = mainFrame
    title.Parent = titleBar
    closeButton.Parent = titleBar
    contentFrame.Parent = mainFrame
    mainFrame.Parent = self.gui
    
    -- 创建设置内容
    self:createSettingsContent(contentFrame)
end

function MusicSettingsGUI:createSettingsContent(parent)
    local padding = 10
    local currentY = 0
    
    -- 当前播放信息
    local infoSection = self:createSection("当前播放信息", parent, currentY)
    currentY = currentY + 40
    
    self.currentTrackLabel = Instance.new("TextLabel")
    self.currentTrackLabel.Size = UDim2.new(1, -20, 0, 30)
    self.currentTrackLabel.Position = UDim2.new(0, 10, 0, currentY)
    self.currentTrackLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    self.currentTrackLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    self.currentTrackLabel.Text = "无音乐播放"
    self.currentTrackLabel.Font = Enum.Font.Gotham
    self.currentTrackLabel.TextSize = 14
    self.currentTrackLabel.Parent = parent
    
    currentY = currentY + 40
    
    -- 播放控制区域
    local controlSection = self:createSection("播放控制", parent, currentY)
    currentY = currentY + 40
    
    -- 控制按钮容器
    local controlButtons = Instance.new("Frame")
    controlButtons.Size = UDim2.new(1, -20, 0, 40)
    controlButtons.Position = UDim2.new(0, 10, 0, currentY)
    controlButtons.BackgroundTransparency = 1
    
    -- 播放/暂停按钮
    self.playPauseButton = self:createButton("播放", UDim2.new(0, 80, 0, 40), Color3.fromRGB(70, 150, 70))
    self.playPauseButton.Parent = controlButtons
    
    -- 停止按钮
    local stopButton = self:createButton("停止", UDim2.new(0, 200, 0, 40), Color3.fromRGB(150, 70, 70))
    stopButton.Position = UDim2.new(0, 90, 0, 0)
    stopButton.Parent = controlButtons
    
    -- 上一首/下一首
    local prevButton = self:createButton("上一首", UDim2.new(0, 80, 0, 40), Color3.fromRGB(70, 100, 150))
    prevButton.Position = UDim2.new(0, 290, 0, 0)
    prevButton.Parent = controlButtons
    
    local nextButton = self:createButton("下一首", UDim2.new(0, 380, 0, 40), Color3.fromRGB(70, 100, 150))
    nextButton.Position = UDim2.new(0, 380, 0, 0)
    nextButton.Parent = controlButtons
    
    controlButtons.Parent = parent
    currentY = currentY + 50
    
    -- 音量设置
    local volumeSection = self:createSection("音量设置", parent, currentY)
    currentY = currentY + 40
    
    local volumeSlider = Instance.new("Frame")
    volumeSlider.Size = UDim2.new(1, -20, 0, 30)
    volumeSlider.Position = UDim2.new(0, 10, 0, currentY)
    volumeSlider.BackgroundTransparency = 1
    
    local volumeLabel = Instance.new("TextLabel")
    volumeLabel.Size = UDim2.new(0, 60, 1, 0)
    volumeLabel.BackgroundTransparency = 1
    volumeLabel.Text = "音量:"
    volumeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    volumeLabel.Font = Enum.Font.Gotham
    volumeLabel.TextSize = 14
    
    self.volumeSlider = Instance.new("TextBox")
    self.volumeSlider.Size = UDim2.new(0, 60, 1, 0)
    self.volumeSlider.Position = UDim2.new(0, 70, 0, 0)
    self.volumeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    self.volumeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.volumeSlider.Text = "50"
    self.volumeSlider.PlaceholderText = "0-100"
    self.volumeSlider.Font = Enum.Font.Gotham
    
    local slider = Instance.new("Slider")
    slider.Size = UDim2.new(0, 200, 0, 20)
    slider.Position = UDim2.new(0, 140, 0.5, -10)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    slider.BorderSizePixel = 0
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    volumeLabel.Parent = volumeSlider
    self.volumeSlider.Parent = volumeSlider
    slider.Parent = volumeSlider
    volumeSlider.Parent = parent
    currentY = currentY + 40
    
    -- 循环设置
    local loopSection = self:createSection("播放设置", parent, currentY)
    currentY = currentY + 40
    
    self.loopToggle = self:createToggle("循环播放", false)
    self.loopToggle.Position = UDim2.new(0, 10, 0, currentY)
    self.loopToggle.Parent = parent
    currentY = currentY + 40
    
    -- 文件夹设置
    local folderSection = self:createSection("文件夹设置", parent, currentY)
    currentY = currentY + 40
    
    local folderFrame = Instance.new("Frame")
    folderFrame.Size = UDim2.new(1, -20, 0, 60)
    folderFrame.Position = UDim2.new(0, 10, 0, currentY)
    folderFrame.BackgroundTransparency = 1
    
    self.folderPath = Instance.new("TextBox")
    self.folderPath.Size = UDim2.new(1, 0, 0, 30)
    self.folderPath.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    self.folderPath.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.folderPath.Text = "C:\\Music\\"
    self.folderPath.PlaceholderText = "输入音乐文件夹路径"
    self.folderPath.Font = Enum.Font.Gotham
    
    local refreshButton = self:createButton("刷新列表", UDim2.new(0, 100, 0, 25), Color3.fromRGB(70, 100, 150))
    refreshButton.Position = UDim2.new(0.5, -50, 1, -30)
    
    self.folderPath.Parent = folderFrame
    refreshButton.Parent = folderFrame
    folderFrame.Parent = parent
    
    -- 连接事件
    self:connectEvents()
end

function MusicSettingsGUI:createSection(title, parent, yPosition)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, -20, 0, 30)
    section.Position = UDim2.new(0, 10, 0, yPosition)
    section.BackgroundTransparency = 1
    section.Text = title
    section.TextColor3 = Color3.fromRGB(150, 150, 255)
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Font = Enum.Font.GothamBold
    section.TextSize = 16
    section.Parent = parent
    
    return section
end

function MusicSettingsGUI:createButton(text, size, color)
    local button = Instance.new("TextButton")
    button.Size = size
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.AutoButtonColor = false
    
    -- 悬停效果
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = color * Color3.new(1.2, 1.2, 1.2)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = color
    end)
    
    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = color * Color3.new(0.8, 0.8, 0.8)
    end)
    
    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = color * Color3.new(1.2, 1.2, 1.2)
    end)
    
    return button
end

function MusicSettingsGUI:createToggle(text, defaultValue)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.BackgroundTransparency = 1
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 30, 0, 30)
    toggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(70, 150, 70) or Color3.fromRGB(150, 70, 70)
    toggleButton.Text = defaultValue and "✓" : "✗"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.GothamBold
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -40, 1, 0)
    toggleLabel.Position = UDim2.new(0, 40, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    
    toggleButton.Parent = toggle
    toggleLabel.Parent = toggle
    
    toggleButton.MouseButton1Click:Connect(function()
        local newValue = not defaultValue
        toggleButton.BackgroundColor3 = newValue and Color3.fromRGB(70, 150, 70) or Color3.fromRGB(150, 70, 70)
        toggleButton.Text = newValue and "✓" or "✗"
        defaultValue = newValue
    end)
    
    return toggle
end

function MusicSettingsGUI:connectEvents()
    -- 播放/暂停按钮
    self.playPauseButton.MouseButton1Click:Connect(function()
        if MusicPlayer.isPlaying then
            MusicPlayer:togglePause()
            self.playPauseButton.Text = "播放"
            self.playPauseButton.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
        else
            MusicPlayer:togglePause()
            self.playPauseButton.Text = "暂停"
            self.playPauseButton.BackgroundColor3 = Color3.fromRGB(150, 150, 70)
        end
        self:updateInfo()
    end)
    
    -- 停止按钮
    self.playPauseButton:FindFirstChildWhichIsA("TextButton", true).MouseButton1Click:Connect(function()
        MusicPlayer:stop()
        self.playPauseButton.Text = "播放"
        self.playPauseButton.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
        self:updateInfo()
    end)
    
    -- 音量设置
    self.volumeSlider.FocusLost:Connect(function()
        local volume = tonumber(self.volumeSlider.Text)
        if volume and volume >= 0 and volume <= 100 then
            MusicPlayer:setVolume(volume / 100)
        else
            self.volumeSlider.Text = tostring(math.floor(MusicPlayer.config.volume * 100))
        end
    end)
    
    -- 循环切换
    self.loopToggle:FindFirstChildWhichIsA("TextButton").MouseButton1Click:Connect(function()
        MusicPlayer:toggleLoop()
    end)
end

function MusicSettingsGUI:updateInfo()
    if self.currentTrackLabel then
        self.currentTrackLabel.Text = MusicPlayer:getInfo()
    end
end

function MusicSettingsGUI:toggle()
    self.visible = not self.visible
    if self.gui then
        self.gui.Enabled = self.visible
    end
end

function MusicSettingsGUI:show()
    self.visible = true
    if self.gui then
        self.gui.Enabled = true
        self.gui.Parent = game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
end

function MusicSettingsGUI:hide()
    self.visible = false
    if self.gui then
        self.gui.Enabled = false
    end
end

-- 创建全局快捷键
function MusicSettingsGUI:createHotkey()
    -- 监听按键事件打开/关闭GUI
    local UserInputService = game:GetService("UserInputService")
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F7 then
            self:toggle()
        end
    end)
end

-- 初始化并显示GUI
local settingsGUI = MusicSettingsGUI.new()
settingsGUI:show()
settingsGUI:createHotkey()

-- 将GUI实例设为全局可用
getgenv().MusicSettingsGUI = settingsGUI

return settingsGUI
