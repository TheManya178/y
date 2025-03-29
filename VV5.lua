local Default = {
    Main = Color3.fromRGB(25, 25, 25),
    Second = Color3.fromRGB(32, 32, 32),
    Stroke = Color3.fromRGB(49, 49, 49),
    Divider = Color3.fromRGB(60, 60, 60),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150)
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function CreateElement(className, properties, children)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = element
        end
    end
    return element
end

local OrionLib = {}

local Orion = CreateElement("ScreenGui", {
    Name = "OrionUI",
    Parent = game.CoreGui
})

function OrionLib:MakeWindow(WindowConfig)
    WindowConfig = WindowConfig or {}
    WindowConfig.Name = WindowConfig.Name or "Orion UI"
    
    -- النافذة الرئيسية
    local MainWindow = CreateElement("Frame", {
        BackgroundColor3 = Default.Main,
        Position = UDim2.new(0.5, -190, 0.5, -90),
        Size = UDim2.new(0, 380, 0, 180),
        Parent = Orion
    }, {
        CreateElement("UICorner", {CornerRadius = UDim.new(0, 4)}),
        CreateElement("UIStroke", {Color = Default.Stroke, Thickness = 1}),
        
        -- شريط العنوان
        CreateElement("Frame", {
            Name = "TopBar",
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Default.Second,
            BorderSizePixel = 0
        }, {
            CreateElement("UICorner", {CornerRadius = UDim.new(0, 4, 0, 0)}),
            CreateElement("TextLabel", {
                Text = WindowConfig.Name,
                TextColor3 = Default.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                Size = UDim2.new(1, -80, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            CreateElement("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = Default.Stroke,
                BorderSizePixel = 0
            })
        }),
        
        -- منطقة التبويبات
        CreateElement("ScrollingFrame", {
            Name = "TabArea",
            Size = UDim2.new(0, 120, 1, -30),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundColor3 = Default.Second,
            ScrollBarThickness = 4,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        }, {
            CreateElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim2.new(0, 5)
            }),
            CreateElement("UIPadding", {
                PaddingTop = UDim2.new(0, 5),
                PaddingLeft = UDim2.new(0, 5)
            })
        }),
        
        -- منطقة المحتوى
        CreateElement("ScrollingFrame", {
            Name = "ContentArea",
            Size = UDim2.new(1, -120, 1, -30),
            Position = UDim2.new(0, 120, 0, 30),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        }, {
            CreateElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim2.new(0, 5)
            }),
            CreateElement("UIPadding", {
                PaddingTop = UDim2.new(0, 5),
                PaddingLeft = UDim2.new(0, 5),
                PaddingRight = UDim2.new(0, 5)
            })
        })
    })
    
    -- وظيفة السحب للنافذة
    local Dragging, DragInput, MousePos, FramePos = false
    MainWindow.TopBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            MousePos = Input.Position
            FramePos = MainWindow.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - MousePos
            MainWindow.Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
        end
    end)
    
    -- وظائف التبويبات
    local TabFunctions = {}
    
    function TabFunctions:MakeTab(TabConfig)
        TabConfig = TabConfig or {}
        TabConfig.Name = TabConfig.Name or "New Tab"
        
        local TabButton = CreateElement("TextButton", {
            Text = TabConfig.Name,
            TextColor3 = Default.Text,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Size = UDim2.new(1, -10, 0, 25),
            BackgroundColor3 = Default.Second,
            AutoButtonColor = false,
            Parent = MainWindow.TabArea
        }, {
            CreateElement("UICorner", {CornerRadius = UDim.new(0, 4)})
        })
        
        local TabContent = CreateElement("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = MainWindow.ContentArea
        }, {
            CreateElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim2.new(0, 5)
            })
        })
        
        TabButton.MouseButton1Click:Connect(function()
            for _, Content in pairs(MainWindow.ContentArea:GetChildren()) do
                if Content:IsA("Frame") then
                    Content.Visible = false
                end
            end
            TabContent.Visible = true
        end)
        
        -- وظائف العناصر داخل التبويب
        local ElementFunctions = {}
        
        function ElementFunctions:AddButton(ButtonConfig)
            ButtonConfig = ButtonConfig or {}
            ButtonConfig.Name = ButtonConfig.Name or "Button"
            ButtonConfig.Callback = ButtonConfig.Callback or function() end
            
            local Button = CreateElement("TextButton", {
                Text = ButtonConfig.Name,
                TextColor3 = Default.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = Default.Second,
                AutoButtonColor = false,
                Parent = TabContent
            }, {
                CreateElement("UICorner", {CornerRadius = UDim.new(0, 4)}),
                CreateElement("UIStroke", {Color = Default.Stroke, Thickness = 1})
            })
            
            Button.MouseButton1Click:Connect(function()
                ButtonConfig.Callback()
            end)
            
            local ButtonFunctions = {}
            function ButtonFunctions:Set(NewText)
                Button.Text = NewText
            end
            
            return ButtonFunctions
        end
        
        return ElementFunctions
    end
    
    return TabFunctions
end

return OrionLib
