-- Tab Component - Individual tab in window

local Components = {}

local Creator = require(script.Parent.Parent.Creator)
local New = Creator.New

function Components.Tab(Config, Window, Library)
    local Theme = Library:GetCurrentThemeColors()
    
    -- Tab button
    local TabBtn = New("TextButton", {
        Parent = Window.TabButtons,
        Text = Config.Title,
        TextColor3 = Theme.TextSecondary,
        Size = UDim2.new(1, -4, 0, 30),
        Position = UDim2.new(0, 2, 0, (#Window.TabsHolder) * 32 + 2),
        BackgroundTransparency = 1,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    })
    
    -- Tab content panel
    local ContentPanel = New("ScrollingFrame", {
        Parent = Window.ContentContainer,
        Name = "Tab_" .. Config.Title,
        Visible = (#Window.TabsHolder == 0),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ZIndex = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    -- Tab selector indicator (neon line)
    local Selector = New("Frame", {
        Parent = Window.TabButtons,
        Size = UDim2.new(0.85, 0, 0, 2),
        Position = UDim2.new(0.075, 0, 0, (#Window.TabsHolder) * 32 + 32),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 5
    })
    
    -- Store tab info
    local TabData = {
        Button = TabBtn,
        Content = ContentPanel,
        Selector = Selector,
        Index = #Window.TabsHolder + 1,
        Elements = {},
        Title = Config.Title
    }
    
    table.insert(Window.TabsHolder, TabData)
    
    -- Function to switch to this tab
    local function Select()
        -- Hide all content panels
        for _, Tab in ipairs(Window.TabsHolder) do
            Tab.Content.Visible = false
            Tab.Button.TextColor3 = Theme.TextSecondary
        end
        
        -- Show this tab
        ContentPanel.Visible = true
        TabBtn.TextColor3 = Theme.Accent
        
        -- Move selector
        Selector.Position = UDim2.new(0.075, 0, 0, TabData.Index * 32 - 2)
        
        Window.CurrentTab = TabData
    end
    
    -- Click to select
    TabBtn.MouseButton1Click:Connect(Select)
    
    -- If this is the first tab, select it
    if #Window.TabsHolder == 1 then
        Select()
    end
    
    -- Method to add elements to this tab
    function TabData:AddElement(ElementType, ElementConfig)
        local ElementModule = require(script.Parent.Parent.Elements)[ElementType]
        if not ElementModule then
            warn("[CyberGUI] Unknown element type:", ElementType)
            return nil
        end
        
        local Element = ElementModule:New(ElementConfig, ContentPanel, Library)
        table.insert(TabData.Elements, Element)
        return Element
    end
    
    -- Auto-generate Add[Element] methods
    local ElementsList = require(script.Parent.Parent.Elements)
    for _, ElementModule in ipairs(ElementsList) do
        local Type = ElementModule.__type
        if Type then
            TabData["Add" .. Type] = function(self, Config)
                return self:AddElement(Type, Config)
            end
        end
    end
    
    return TabData
end

return Components.Tab
