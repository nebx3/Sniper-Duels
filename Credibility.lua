local library = {}
local utility = {}
local obelus = {
	connections = {}
}
local uis = game:GetService("UserInputService")
local cre = game:GetService("CoreGui")
library.__index = library
do
	function utility:Create(createInfo)
		local createInfo = createInfo or {}
		if createInfo.Type then
			local instance = Instance.new(createInfo.Type)
			if createInfo.Properties and typeof(createInfo.Properties) == "table" then
				for property, value in pairs(createInfo.Properties) do
					instance[property] = value
				end
			end
			return instance
		end
	end
	function utility:Connection(connectionInfo)
		local connectionInfo = connectionInfo or {}
		if connectionInfo.Type then
			local connection = connectionInfo.Type:Connect(connectionInfo.Callback or function() end)
			obelus.connections[#obelus.connections] = connection
			return connection
		end
	end
	function utility:RemoveConnection(connectionInfo)
		local connectionInfo = connectionInfo or {}
		if connectionInfo.Connection then
			local found = table.find(obelus.connections, connectionInfo.Connection)
			if found then
				connectionInfo.Connection:Disconnect()
				table.remove(obelus.connections, found)
			end
		end
	end
end
do
	function library:Window(windowInfo)
		local info = windowInfo or {}
		local window = {Pages = {}, Dragging = false, Delta = UDim2.new(), Delta2 = Vector3.new()}
		local screen = utility:Create({Type = "ScreenGui", Properties = {
			Parent = cre,
			DisplayOrder = 8888,
			IgnoreGuiInset = true,
			Name = "credibility",
			ZIndexBehavior = "Global",
			ResetOnSpawn = false
		}})

		local inputBlocker = utility:Create({Type = "TextButton", Properties = {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = screen,
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			ZIndex = 1
		}})
		local controls = nil
		local function setMenuOpen(open)
			screen.Enabled = open
			if controls == nil then
				local ok, module = pcall(function()
					local ps = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts", 10)
					return ps and require(ps:WaitForChild("PlayerModule", 10))
				end)
				if ok and module then
					controls = module:GetControls()
				end
			end
			if controls then
				if open then
					controls:Disable()
				else
					controls:Enable()
				end
			end
		end
		library.setMenuOpen = setMenuOpen
		game:GetService("UserInputService").InputBegan:Connect(function(k, g)
			if not g and k.KeyCode == Enum.KeyCode.RightShift then
				if cre:FindFirstChild("CredibilitySplash") then
					return
				end
				setMenuOpen(not screen.Enabled)
			end
		end)
		task.defer(function()
			setMenuOpen(screen.Enabled)
		end)
		local main = utility:Create({Type = "Frame", Properties = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(51, 51, 51),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderMode = "Inset",
			BorderSizePixel = 1,
			Parent = screen,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(0, 516, 0, 563)
		}})
		local frame = utility:Create({Type = "Frame", Properties = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(12, 12, 12),
			BorderSizePixel = 0,
			Parent = main,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -2, 1, -2),
		}})

		local draggingButton = utility:Create({Type = "TextButton", Properties = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = frame,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 24),
			Text = ""
		}})
		local title = utility:Create({Type = "TextLabel", Properties = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = frame,
			Position = UDim2.new(0, 9, 0, 6),
			Size = UDim2.new(1, -16, 0, 15),
			Font = "Code",
			RichText = true,
			Text = info.Name or info.name or "credibility",
			TextColor3 = Color3.fromRGB(142, 142, 142),
			TextStrokeTransparency = 0.5,
			TextSize = 13,
			TextXAlignment = "Left"
		}})
		local accent = utility:Create({Type = "Frame", Properties = {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = frame,
			Position = UDim2.new(0, 8, 0, 22),
			Size = UDim2.new(1, -16, 0, 2)
		}})
		local accentFirst = utility:Create({Type = "Frame", Properties = {
			BackgroundColor3 = Color3.fromRGB(170, 85, 235),
			BorderSizePixel = 0,
			Parent = accent,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 1)
		}})
		local accentSecond = utility:Create({Type = "Frame", Properties = {
			BackgroundColor3 = Color3.fromRGB(101, 51, 141),
			BorderSizePixel = 0,
			Parent = accent,
			Position = UDim2.new(0, 0, 0, 1),
			Size = UDim2.new(1, 0, 0, 1)
		}})
		local tabs = utility:Create({Type = "Frame", Properties = {
			BackgroundColor3 = Color3.fromRGB(1, 1, 1),
			BorderSizePixel = 0,
			Parent = frame,
			Position = UDim2.new(0, 8, 0, 29),
			Size = UDim2.new(1, -16, 0, 30)
		}})
		local tabsInline = utility:Create({Type = "Frame", Properties = {
			BackgroundColor3 = Color3.fromRGB(1, 1, 1),
			BorderSizePixel = 0,
			Parent = tabs,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, -1, 1, 0)
		}})
		utility:Create({Type = "UIListLayout", Properties = {
			Padding = UDim.new(0, 0),
			Parent = tabsInline,
			FillDirection = "Horizontal"
		}})
		local pagesHolder = utility:Create({Type = "Frame", Properties = {
			BackgroundColor3 = Color3.fromRGB(51, 51, 51),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderMode = "Inset",
			BorderSizePixel = 1,
			Parent = frame,
			Position = UDim2.new(0, 8, 0, 65),
			Size = UDim2.new(1, -16, 1, -76)
		}})
		local pagesFrame = utility:Create({Type = "Frame", Properties = {
			BackgroundColor3 = Color3.fromRGB(13, 13, 13),
			BorderSizePixel = 0,
			Parent = pagesHolder,
			Position = UDim2.new(0, 1, 0, 1),
			Size = UDim2.new(1, -2, 1, -2)
		}})
		local pagesFolder = utility:Create({Type = "Folder", Properties = {
			Parent = pagesFrame
		}})
		local connection = utility:Connection({Type = draggingButton.InputBegan, Callback = function(Input)
			if not window.Dragging and Input.UserInputType == Enum.UserInputType.MouseButton1 then
				window.Dragging = true
				window.Delta = main.Position
				window.Delta2 = Input.Position
			end
		end})
		local connection2 = utility:Connection({Type = uis.InputEnded, Callback = function(Input)
			if window.Dragging and Input.UserInputType == Enum.UserInputType.MouseButton1 then
				window.Dragging = false
				window.Delta = UDim2.new()
				window.Delta2 = Vector3.new()
			end
		end})
		local connection3 = utility:Connection({Type = uis.InputChanged, Callback = function(Input)
			if window.Dragging then
				local Delta = Input.Position - window.Delta2
				main.Position = UDim2.new(window.Delta.X.Scale, window.Delta.X.Offset + Delta.X, window.Delta.Y.Scale, window.Delta.Y.Offset + Delta.Y)
			end
		end})
		function window:RefreshTabs()
			for index, page in pairs(window.Pages) do
				page.Tab.Size = UDim2.new(1 / (#window.Pages), 0, 1, 0)
			end
		end
		function window:Page(pageInfo)
			local info = pageInfo or {}
			local page = {Open = false}
			local tab = utility:Create({Type = "Frame", Properties = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = tabsInline,
				Size = UDim2.new(1, 0, 1, 0)
			}})
			local tabButton = utility:Create({Type = "TextButton", Properties = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = tab,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 1, 0)
			}})
			local tabInline = utility:Create({Type = "Frame", Properties = {
				BackgroundColor3 = Color3.fromRGB(41, 41, 41),
				BorderSizePixel = 0,
				Parent = tab,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -1, 1, -2)
			}})
			local tabInlineGradient = utility:Create({Type = "Frame", Properties = {
				BackgroundColor3 = Color3.fromRGB(41, 41, 41),
				BorderSizePixel = 0,
				Parent = tabInline,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2)
			}})
			local tabGradient = utility:Create({Type = "UIGradient", Properties = {
				Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))}),
				Rotation = 90,
				Parent = tabInlineGradient
			}})
			local tabTitle = utility:Create({Type = "TextLabel", Properties = {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = tabInlineGradient,
				Position = UDim2.new(0, 4, 0.5, 0),
				Size = UDim2.new(1, -8, 0, 15),
				Font = "Code",
				RichText = true,
				Text = info.Name or info.name or "tab",
				TextColor3 = Color3.fromRGB(142, 142, 142),
				TextStrokeTransparency = 0.5,
				TextSize = 13,
				TextXAlignment = "Center"
			}})
			local pageHolder = utility:Create({Type = "Frame", Properties = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = pagesFolder,
				Position = UDim2.new(0, 10, 0, 10),
				Size = UDim2.new(1, -20, 1, -20),
				Visible = false
			}})
			local leftHolder = utility:Create({Type = "Frame", Properties = {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = pageHolder,
				Position = UDim2.new(0, 0, 0 ,0),
				Size = UDim2.new(0.5, -5, 1, 0)
			}})
			local rightHolder = utility:Create({Type = "Frame", Properties = {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = pageHolder,
				Position = UDim2.new(1, 0, 0 ,0),
				Size = UDim2.new(0.5, -5, 1, 0)
			}})
			utility:Connection({Type = tabButton.MouseButton1Down, Callback = function()
				if not page.open then
					for index, other_page in pairs(window.Pages) do
						if other_page ~= page then
							other_page:Turn(false)
						end
					end
				end
				page:Turn(true)
			end})
			function page:Turn(state)
				tabTitle.TextColor3 = state and Color3.fromRGB(170, 85, 235) or Color3.fromRGB(142, 142, 142)
				tabGradient.Color = state and ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(155, 155, 155))}) or ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))})
				page.PageHolder.Visible = state
				page.Open = state
			end
			function page:Section(sectionInfo)
				local info = sectionInfo or {}
				local section = {}
				local sectionMain = utility:Create({Type = "Frame", Properties = {
					BackgroundColor3 = Color3.fromRGB(45, 45, 45),
					BorderColor3 = Color3.fromRGB(13, 13, 13),
					BorderMode = "Inset",
					BorderSizePixel = 1,
					Parent = page[((info.Side and info.Side:lower() == "right") or (info.side and info.side:lower() == "right")) and "Right" or "Left"],
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, (info.Size or info.size or 200) + 4)
				}})
				local sectionFrame = utility:Create({Type = "Frame", Properties = {
					BackgroundColor3 = Color3.fromRGB(19, 19, 19),
					BorderSizePixel = 0,
					Parent = sectionMain,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2)
				}})
				local sectionTitle = utility:Create({Type = "TextLabel", Properties = {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = sectionMain,
					Position = UDim2.new(0, 13, 0, 0),
					Size = UDim2.new(1, -26, 0, 15),
					Font = "Code",
					RichText = true,
					Text = info.Name or info.name or "new section",
					TextColor3 = Color3.fromRGB(205, 205, 205),
					TextStrokeTransparency = 0.5,
					TextSize = 13,
					TextXAlignment = "Left",
					ZIndex = 2
				}})
				local sectionTitleLine = utility:Create({Type = "Frame", Properties = {
					BackgroundColor3 = Color3.fromRGB(19, 19, 19),
					BorderSizePixel = 0,
					Parent = sectionMain,
					Position = UDim2.new(0, 9, 0, 0),
					Size = UDim2.new(0, sectionTitle.TextBounds.X + 6, 0, 1)
				}})
				local sectionScrolling = utility:Create({Type = "Frame", Properties = {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = sectionMain,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					Visible = false
				}})
				local sectionScrollingBar = utility:Create({Type = "Frame", Properties = {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = Color3.fromRGB(45, 45, 45),
					BorderSizePixel = 0,
					Parent = sectionScrolling,
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.new(0, 5, 1, 0),
					ZIndex = 3
				}})
				local sectionScrollingGradient = utility:Create({Type = "ImageLabel", Properties = {
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = sectionScrolling,
					Position = UDim2.new(0, 0, 1, 0),
					Size = UDim2.new(1, 0, 0, 20),
					ZIndex = 2,
					Image = "rbxassetid://7783533907",
					ImageTransparency = 0,
					ImageColor3 = Color3.fromRGB(19, 19, 19),
					ScaleType = "Stretch"
				}})
				local sectionContentHolder = utility:Create({Type = "ScrollingFrame", Properties = {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Parent = sectionFrame,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ZIndex = 4,
					AutomaticCanvasSize = "Y",
					BottomImage = "rbxassetid://7783554086",
					CanvasSize = UDim2.new(0, 0, 0, 0),
					MidImage = "rbxassetid://7783554086",
					ScrollBarImageColor3 = Color3.fromRGB(65, 65, 65),
					ScrollBarThickness = 4,
					TopImage = "rbxassetid://7783554086",
					VerticalScrollBarInset = "ScrollBar"
				}})
				utility:Create({Type = "UIListLayout", Properties = {
					Padding = UDim.new(0, 5),
					Parent = sectionContentHolder,
					FillDirection = "Vertical"
				}})
				local sectionInline = utility:Create({Type = "Frame", Properties = {
					BackgroundColor3 = Color3.fromRGB(19, 19, 19),
					BorderSizePixel = 0,
					Parent = sectionContentHolder,
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, 0, 0, 10)
				}})
				function section:Update()
					if sectionContentHolder.AbsoluteCanvasSize.Y > ((info.Size or info.size or 200) + 4) then
						sectionScrolling.Visible = true
					else
						sectionScrolling.Visible = false
					end
				end
				function section:Label(labelInfo)
					local info = labelInfo or {}
					local label = {}
					local contentHolder = utility:Create({Type = "Frame", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = sectionContentHolder,
						Size = UDim2.new(1, 0, 0, 14)
					}})
					local labelTitle = utility:Create({Type = "TextLabel", Properties = {
						AnchorPoint = Vector2.new(0, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = contentHolder,
						Size = UDim2.new(1, -(info.Offset or 36), 1, 0),
						Position = UDim2.new(0, info.Offset or 36, 0, 0),
						Font = "Code",
						RichText = true,
						Text = info.Name or info.name or info.Text or info.text or "new label",
						TextColor3 = Color3.fromRGB(180, 180, 180),
						TextStrokeTransparency = 0.5,
						TextSize = 13,
						TextXAlignment = "Left"
					}})
					function label:Set(text)
						labelTitle.Text = text
					end
					function label:Remove()
						contentHolder:Remove()
						label = nil
						section:Update()
					end
					section:Update()
					return label
				end
				function section:Toggle(toggleInfo)
					local info = toggleInfo or {}
					local toggle = {
						state = (info.Default or info.default or info.Def or info.def or false),
						callback = (info.Callback or info.callback or function() end)
					}
					local contentHolder = utility:Create({Type = "Frame", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = sectionContentHolder,
						Size = UDim2.new(1, 0, 0, 14)
					}})
					local toggleButton = utility:Create({Type = "TextButton", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = contentHolder,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Text = ""
					}})
					local toggleTitle = utility:Create({Type = "TextLabel", Properties = {
						AnchorPoint = Vector2.new(0, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = contentHolder,
						Size = UDim2.new(1, -36, 1, 0),
						Position = UDim2.new(0, 36, 0, 0),
						Font = "Code",
						RichText = true,
						Text = info.Name or info.name or info.Text or info.text or "new toggle",
						TextColor3 = Color3.fromRGB(180, 180, 180),
						TextStrokeTransparency = 0.5,
						TextSize = 13,
						TextXAlignment = "Left"
					}})
					local toggleFrame = utility:Create({Type = "Frame", Properties = {
						BackgroundColor3 = Color3.fromRGB(1, 1, 1),
						BorderSizePixel = 0,
						Parent = contentHolder,
						Position = UDim2.new(0, 16, 0, 2),
						Size = UDim2.new(0, 10, 0, 10)
					}})
					local toggleInlineGradient = utility:Create({Type = "Frame", Properties = {
						BackgroundColor3 = toggle.state and Color3.fromRGB(170, 85, 235) or Color3.fromRGB(63, 63, 63),
						BorderSizePixel = 0,
						Parent = toggleFrame,
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2)
					}})
					local toggleGradient = utility:Create({Type = "UIGradient", Properties = {
						Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 125, 125))}),
						Rotation = 90,
						Parent = toggleInlineGradient
					}})
					local connection = utility:Connection({Type = toggleButton.MouseButton1Down, Callback = function()
						toggle.state = not toggle.state
						toggleInlineGradient.BackgroundColor3 = toggle.state and Color3.fromRGB(170, 85, 235) or Color3.fromRGB(63, 63, 63)
						toggle.callback(toggle.state)
					end})
					function toggle:Remove()
						contentHolder:Remove()
						toggle = nil
						utility:RemoveConnection({Connection = connection})
						connection = nil
						section:Update()
					end
					function toggle:Get()
						return toggle.state
					end
					function toggle:Set(value)
						if typeof(value) == "boolean" then
							toggle.state = value
						end
					end
					section:Update()
					return toggle
				end
				function section:Button(buttonInfo)
					local info = buttonInfo or {}
					local button = {
						callback = (info.Callback or info.callback or function() end)
					}
					local contentHolder = utility:Create({Type = "Frame", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = sectionContentHolder,
						Size = UDim2.new(1, 0, 0, 20)
					}})
					local buttonButton = utility:Create({Type = "TextButton", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = contentHolder,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Text = ""
					}})
					local buttonFrame = utility:Create({Type = "Frame", Properties = {
						BackgroundColor3 = Color3.fromRGB(45, 45, 45),
						BorderColor3 = Color3.fromRGB(1, 1, 1),
						BorderMode = "Inset",
						BorderSizePixel = 1,
						Parent = contentHolder,
						Position = UDim2.new(0, 16, 0, 0),
						Size = UDim2.new(1, -32, 1, 0)
					}})
					local buttonInline = utility:Create({Type = "Frame", Properties = {
						BackgroundColor3 = Color3.fromRGB(25, 25, 25),
						BorderSizePixel = 0,
						Parent = buttonFrame,
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2)
					}})
					local buttonTitle = utility:Create({Type = "TextLabel", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = contentHolder,
						Size = UDim2.new(1, -32, 1, 0),
						Position = UDim2.new(0, 16, 0, 0),
						Font = "Code",
						RichText = true,
						Text = info.Name or info.name or info.Text or info.text or "new button",
						TextColor3 = Color3.fromRGB(180, 180, 180),
						TextStrokeTransparency = 0.5,
						TextSize = 13,
						TextXAlignment = "Center"
					}})
					local connection = utility:Connection({Type = buttonButton.MouseButton1Down, Callback = function()
						button.callback()
					end})
					function button:Set(text)
						buttonTitle.Text = text
					end
					function button:Remove()
						contentHolder:Remove()
						button = nil
						utility:RemoveConnection({Connection = connection})
						connection = nil
						section:Update()
					end
					section:Update()
					return button
				end
				function section:Slider(sliderInfo)
					local info = sliderInfo or {}
					local slider = {
						state = (info.Default or info.default or info.Def or info.def or 0),
						min = (info.Minimum or info.minimum or info.Min or info.min or 0),
						max = (info.Maximum or info.maximum or info.Max or info.max or 10),
						decimals = (1 / (info.Decimals or info.decimals or info.Tick or info.tick or 0.25)),
						suffix = (info.Suffix or info.suffix or info.Ending or info.ending or ""),
						callback = (info.Callback or info.callback or function() end),
						holding = false
					}
					local contentHolder = utility:Create({Type = "Frame", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = sectionContentHolder,
						Size = UDim2.new(1, 0, 0, (info.Name or info.name or info.Text or info.text) and 24 or 10)
					}})
					local sliderButton = utility:Create({Type = "TextButton", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = contentHolder,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(1, 0, 1, 0),
						Text = ""
					}})
					if (info.Name or info.name or info.Text or info.text) then
						local sliderTitle = utility:Create({Type = "TextLabel", Properties = {
							AnchorPoint = Vector2.new(0, 0),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Parent = contentHolder,
							Size = UDim2.new(1, -16, 0, 14),
							Position = UDim2.new(0, 16, 0, 0),
							Font = "Code",
							RichText = true,
							Text = (info.Name or info.name or info.Text or info.text),
							TextColor3 = Color3.fromRGB(180, 180, 180),
							TextStrokeTransparency = 0.5,
							TextSize = 13,
							TextXAlignment = "Left"
						}})
					end
					local sliderFrame = utility:Create({Type = "Frame", Properties = {
						BackgroundColor3 = Color3.fromRGB(1, 1, 1),
						BorderSizePixel = 0,
						Parent = contentHolder,
						Position = UDim2.new(0, 16, 0, (info.Name or info.name or info.Text or info.text) and 14 or 0),
						Size = UDim2.new(1, -32, 0, 10)
					}})
					local sliderInlineGradient = utility:Create({Type = "Frame", Properties = {
						BackgroundColor3 = Color3.fromRGB(63, 63, 63),
						BorderSizePixel = 0,
						Parent = sliderFrame,
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2)
					}})
					local sliderGradient = utility:Create({Type = "UIGradient", Properties = {
						Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 125, 125))}),
						Rotation = 90,
						Parent = sliderInlineGradient
					}})
					local sliderSlideHolder = utility:Create({Type = "Frame", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = sliderFrame,
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2)
					}})
					local sliderSlide = utility:Create({Type = "Frame", Properties = {
						BackgroundColor3 = Color3.fromRGB(170, 85, 235),
						BorderSizePixel = 0,
						Parent = sliderSlideHolder,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(0.5, 0, 1, 0)
					}})
					local sliderGradient = utility:Create({Type = "UIGradient", Properties = {
						Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 125, 125))}),
						Rotation = 90,
						Parent = sliderSlide
					}})
					local sliderValue = utility:Create({Type = "TextLabel", Properties = {
						AnchorPoint = Vector2.new(0.5, 0.25),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = sliderSlide,
						Size = UDim2.new(0, 10, 0, 14),
						Position = UDim2.new(1, 0, 0.5, 0),
						Font = "Code",
						RichText = true,
						Text = tostring(slider.state) .. tostring(slider.suffix),
						TextColor3 = Color3.fromRGB(180, 180, 180),
						TextStrokeTransparency = 0.5,
						TextSize = 13,
						TextXAlignment = "Left"
					}})
					local connection = utility:Connection({Type = sliderButton.MouseButton1Down, Callback = function()
						slider.holding = true
						slider:Refresh()
					end})
					local connection2 = utility:Connection({Type = uis.InputEnded, Callback = function()
						slider.holding = false
					end})
					local connection3 = utility:Connection({Type = uis.InputChanged, Callback = function()
						if slider.holding then
							slider:Refresh()
						end
					end})
					function slider:Remove()
						contentHolder:Remove()
						slider = nil
						utility:RemoveConnection({Connection = connection})
						connection = nil
						utility:RemoveConnection({Connection = connection2})
						connection2 = nil
						utility:RemoveConnection({Connection = connection3})
						connection3 = nil
						section:Update()
					end
					function slider:Get()
						return slider.state
					end
					function slider:Set(value)
						slider.state = math.clamp(math.round(value * slider.decimals) / slider.decimals, slider.min, slider.max)
						sliderSlide.Size = UDim2.new(1 - ((slider.max - slider.state) / (slider.max - slider.min)), 0, 1, 0)
						sliderValue.Text = tostring(slider.state) .. tostring(slider.suffix)
						pcall(slider.callback, slider.state)
					end
					function slider:Refresh()
						if slider.holding then
							local mouseLocation = uis:GetMouseLocation()
							slider:Set(math.clamp(math.floor((slider.min + (slider.max - slider.min) * (math.clamp(mouseLocation.X - sliderSlide.AbsolutePosition.X, 0, sliderSlideHolder.AbsoluteSize.X) / sliderSlideHolder.AbsoluteSize.X)) * slider.decimals) / slider.decimals, slider.min, slider.max))
						end
					end
					section:Update()
					slider:Set(slider.state)
					return slider
				end
				function section:ColorPicker(pickerInfo)
					local info = pickerInfo or {}
					local picker = {
						color = info.Color or Color3.fromRGB(255, 70, 70),
						callback = info.Callback or function() end,
						holding = false
					}
					local contentHolder = utility:Create({Type = "Frame", Properties = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = sectionContentHolder,
						Size = UDim2.new(1, 0, 0, 154)
					}})
					local pickerTitle = utility:Create({Type = "TextLabel", Properties = {
						AnchorPoint = Vector2.new(0, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Parent = contentHolder,
						Position = UDim2.new(0, 16, 0, 0),
						Size = UDim2.new(1, -16, 0, 14),
						Font = "Code",
						RichText = true,
						Text = info.Name or info.name or "color",
						TextColor3 = Color3.fromRGB(180, 180, 180),
						TextStrokeTransparency = 0.5,
						TextSize = 13,
						TextXAlignment = "Left"
					}})
					local wheel = utility:Create({Type = "TextButton", Properties = {
						AutoButtonColor = false,
						BackgroundColor3 = Color3.fromRGB(255, 0, 0),
						BorderSizePixel = 0,
						Parent = contentHolder,
						Position = UDim2.new(0, 16, 0, 16),
						Size = UDim2.new(1, -32, 0, 130),
						Text = ""
					}})
					utility:Create({Type = "UIGradient", Properties = {
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
							ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
							ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
							ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
							ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
							ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
						}),
						Parent = wheel
					}})
					local shade = utility:Create({Type = "Frame", Properties = {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0,
						Parent = wheel,
						Size = UDim2.new(1, 0, 1, 0)
					}})
					utility:Create({Type = "UIGradient", Properties = {
						Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)),
						Rotation = 90,
						Parent = shade
					}})
					local marker = utility:Create({Type = "Frame", Properties = {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 1,
						Parent = wheel,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						Size = UDim2.new(0, 8, 0, 8),
						ZIndex = 3
					}})
					do
						local H, S, V = picker.color:ToHSV()
						marker.Position = UDim2.new(H, 0, 1 - V, 0)
					end
					local function refresh()
						local mouseLocation = uis:GetMouseLocation()
						local x = math.clamp(mouseLocation.X - wheel.AbsolutePosition.X, 0, wheel.AbsoluteSize.X)
						local y = math.clamp(mouseLocation.Y - wheel.AbsolutePosition.Y, 0, wheel.AbsoluteSize.Y)
						local hue = wheel.AbsoluteSize.X > 0 and x / wheel.AbsoluteSize.X or 0
						local value = wheel.AbsoluteSize.Y > 0 and 1 - y / wheel.AbsoluteSize.Y or 1
						picker.color = Color3.fromHSV(hue, 1, value)
						marker.Position = UDim2.new(hue, 0, 1 - value, 0)
						pcall(picker.callback, picker.color)
					end
					local connection = utility:Connection({Type = wheel.MouseButton1Down, Callback = function()
						picker.holding = true
						refresh()
					end})
					local connection2 = utility:Connection({Type = uis.InputEnded, Callback = function()
						picker.holding = false
					end})
					local connection3 = utility:Connection({Type = uis.InputChanged, Callback = function()
						if picker.holding then
							refresh()
						end
					end})
					function picker:Remove()
						contentHolder:Remove()
						picker = nil
						utility:RemoveConnection({Connection = connection})
						connection = nil
						utility:RemoveConnection({Connection = connection2})
						connection2 = nil
						utility:RemoveConnection({Connection = connection3})
						connection3 = nil
						section:Update()
					end
					function picker:Get()
						return picker.color
					end
					function picker:Set(color)
						picker.color = color
						local hue, saturation, value = color:ToHSV()
						marker.Position = UDim2.new(hue, 0, 1 - value, 0)
						pcall(picker.callback, picker.color)
					end
					section:Update()
					return picker
				end
				return section
			end
			page.Tab = tab
			page.PageHolder = pageHolder
			page.Left = leftHolder
			page.Right = rightHolder
			window.Pages[#window.Pages + 1] = page
			window:RefreshTabs()
			return page
		end
		return window
	end
end
local window = library:Window({name = "<font color=\"#AA55EB\">credibility</font>"})
local aimbot = window:Page({Name = "aimbot"})
local antiaim = window:Page({Name = "antiaim"})
local visuals = window:Page({Name = "visuals"})
local credits = window:Page({Name = "credits"})
local aimbot_section = aimbot:Section({Name = "players", size = 300})
local antiaim_section = antiaim:Section({Name = "angles", size = 220})
local visuals_section = visuals:Section({Name = "enemy visuals", size = 220})
local credits_section = credits:Section({Name = "credits", size = 160})
local main_config = {
	SilentAim = false,
	Aimbot = false,
	Fov = 250,
	Smoothness = 0,
	AntiAim = false,
	AntiAimSpin = false,
	AntiAimJitter = false,
	AntiAimSpeed = 60,
	ESP = false,
	ESPNames = true,
	ESPHealth = true,
	ESPTracers = false,
	ESPColor = Color3.fromRGB(255, 70, 70),
	TeamCheck = true,
	VisibleCheck = true,
	AimPart = "Head",
	RandPart = "Head",
	Humanizer = false,
	HumanizerAmount = 35,
	TeamESP = false,
	Box2D = false,
	Box3D = false,
	ShowFOV = false,
	LookDown = false,
	Backtrack = false,
	BacktrackTime = 200
}
local rs = game:GetService("ReplicatedStorage")
local silent_flag = rs:FindFirstChild("Credibility_SilentAim")
if not silent_flag then
	silent_flag = Instance.new("BoolValue")
	silent_flag.Name = "Credibility_SilentAim"
	silent_flag.Parent = rs
end
silent_flag.Value = main_config.SilentAim
local team_flag = rs:FindFirstChild("Credibility_TeamCheck")
if not team_flag then
	team_flag = Instance.new("BoolValue")
	team_flag.Name = "Credibility_TeamCheck"
	team_flag.Parent = rs
end
team_flag.Value = main_config.TeamCheck
local visible_flag = rs:FindFirstChild("Credibility_VisibleCheck")
if not visible_flag then
	visible_flag = Instance.new("BoolValue")
	visible_flag.Name = "Credibility_VisibleCheck"
	visible_flag.Parent = rs
end
visible_flag.Value = main_config.VisibleCheck
local part_flag = rs:FindFirstChild("Credibility_AimPart")
if not part_flag then
	part_flag = Instance.new("StringValue")
	part_flag.Name = "Credibility_AimPart"
	part_flag.Parent = rs
end
part_flag.Value = main_config.AimPart
local bt_flag = rs:FindFirstChild("Credibility_Backtrack")
if not bt_flag then
	bt_flag = Instance.new("BoolValue")
	bt_flag.Name = "Credibility_Backtrack"
	bt_flag.Parent = rs
end
bt_flag.Value = main_config.Backtrack
local bt_time_flag = rs:FindFirstChild("Credibility_BacktrackTime")
if not bt_time_flag then
	bt_time_flag = Instance.new("NumberValue")
	bt_time_flag.Name = "Credibility_BacktrackTime"
	bt_time_flag.Parent = rs
end
bt_time_flag.Value = main_config.BacktrackTime
credits_section:Label({Name = "made by muppet61", Offset = 16})
credits_section:Button({Name = "copy discord link", Callback = function()
	pcall(function()
		setclipboard("https://discord.gg/4gFbm8MTe")
	end)
end})
aimbot_section:Toggle({Name = "silent aim(doesnt work)", Default = false, Callback = function(value)
	main_config.SilentAim = value
	silent_flag.Value = value
end})
aimbot_section:Toggle({Name = "aimbot (hold right mouse)", Default = false, Callback = function(value)
	main_config.Aimbot = value
end})
aimbot_section:Slider({Name = "aim fov", Default = 250, Minimum = 50, Maximum = 600, Decimals = 10, Suffix = "px", Callback = function(value)
	main_config.Fov = value
end})
aimbot_section:Slider({Name = "smoothing", Default = 0, Minimum = 0, Maximum = 95, Decimals = 1, Suffix = "%", Callback = function(value)
	main_config.Smoothness = value / 100
end})
aimbot_section:Toggle({Name = "humanizer", Default = false, Callback = function(value)
	main_config.Humanizer = value
end})
aimbot_section:Slider({Name = "humanizer amount", Default = 35, Minimum = 0, Maximum = 100, Decimals = 5, Suffix = "%", Callback = function(value)
	main_config.HumanizerAmount = value
end})
aimbot_section:Toggle({Name = "team check", Default = true, Callback = function(value)
	main_config.TeamCheck = value
	team_flag.Value = value
end})
aimbot_section:Toggle({Name = "visible", Default = true, Callback = function(value)
	main_config.VisibleCheck = value
	visible_flag.Value = value
end})
local aimParts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}
local aimPartIndex = 1
local aimPartLabel = aimbot_section:Label({Name = "aim part: Head", Offset = 16})
aimbot_section:Button({Name = "cycle body part", Callback = function()
	aimPartIndex = (aimPartIndex % #aimParts) + 1
	main_config.AimPart = aimParts[aimPartIndex]
	part_flag.Value = main_config.AimPart
	aimPartLabel:Set("aim part: " .. aimParts[aimPartIndex])
end})
aimbot_section:Button({Name = "all", Callback = function()
	main_config.AimPart = "All"
	main_config.RandPart = aimParts[math.random(1, #aimParts)]
	part_flag.Value = main_config.RandPart
	aimPartLabel:Set("aim part: all (random)")
end})
antiaim_section:Toggle({Name = "anti aim", Default = false, Callback = function(value)
	main_config.AntiAim = value
end})
antiaim_section:Toggle({Name = "spin", Default = false, Callback = function(value)
	main_config.AntiAimSpin = value
end})
antiaim_section:Toggle({Name = "jitter", Default = false, Callback = function(value)
	main_config.AntiAimJitter = value
end})
antiaim_section:Slider({Name = "spin speed", Default = 60, Minimum = 10, Maximum = 360, Decimals = 10, Suffix = "deg", Callback = function(value)
	main_config.AntiAimSpeed = value
end})
antiaim_section:Toggle({Name = "look down (fake)", Default = false, Callback = function(value)
	main_config.LookDown = value
end})
antiaim_section:Toggle({Name = "backtrack", Default = false, Callback = function(value)
	main_config.Backtrack = value
	bt_flag.Value = value
end})
antiaim_section:Slider({Name = "backtrack amount", Default = 200, Minimum = 50, Maximum = 500, Decimals = 25, Suffix = "ms", Callback = function(value)
	main_config.BacktrackTime = value
	bt_time_flag.Value = value
end})
antiaim_section:Label({Name = "no spin/jitter = face backwards", Offset = 16})
visuals_section:Toggle({Name = "enemy esp", Default = false, Callback = function(value)
	main_config.ESP = value
end})
visuals_section:Toggle({Name = "names", Default = true, Callback = function(value)
	main_config.ESPNames = value
end})
visuals_section:Toggle({Name = "health bar", Default = true, Callback = function(value)
	main_config.ESPHealth = value
end})
visuals_section:Toggle({Name = "tracers", Default = false, Callback = function(value)
	main_config.ESPTracers = value
end})
visuals_section:Toggle({Name = "team esp", Default = false, Callback = function(value)
	main_config.TeamESP = value
end})
visuals_section:Toggle({Name = "2d box", Default = false, Callback = function(value)
	main_config.Box2D = value
end})
visuals_section:Toggle({Name = "3d box", Default = false, Callback = function(value)
	main_config.Box3D = value
end})
visuals_section:Toggle({Name = "show fov", Default = false, Callback = function(value)
	main_config.ShowFOV = value
end})
visuals_section:ColorPicker({Name = "esp color", Color = main_config.ESPColor, Callback = function(color)
	main_config.ESPColor = color
end})
do
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Workspace = game:GetService("Workspace")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local LocalPlayer = Players.LocalPlayer
	local function GetLocalRoot()
		local Character = LocalPlayer.Character
		return Character and Character:FindFirstChild("HumanoidRootPart")
	end
	local function IsValidTarget(Model)
		if not Model or not Model.Parent or Model == LocalPlayer.Character then
			return false
		end
		local Humanoid = Model:FindFirstChildOfClass("Humanoid")
		local Root = Model:FindFirstChild("HumanoidRootPart")
		return Humanoid ~= nil
			and Root ~= nil
			and Humanoid.Health > 0
			and not Model:FindFirstChildOfClass("ForceField")
	end
	local function IsEnemy(Model)
		if not main_config.TeamCheck then
			return true
		end
		local Player = Players:GetPlayerFromCharacter(Model)
		if not Player then
			return true
		end
		local MyTeam = LocalPlayer.Team
		local TheirTeam = Player.Team
		if MyTeam and TheirTeam and MyTeam == TheirTeam then
			return false
		end
		return true
	end
	local function GetEnemies()
		local Enemies = {}
		for _, Player in ipairs(Players:GetPlayers()) do
			local Model = Player.Character
			if Player ~= LocalPlayer and IsValidTarget(Model) and IsEnemy(Model) then
				Enemies[#Enemies + 1] = Model
			end
		end
		local Bots = Workspace:FindFirstChild("Bots")
		if Bots then
			for _, Bot in ipairs(Bots:GetChildren()) do
				if Bot:IsA("Model") and IsValidTarget(Bot) then
					Enemies[#Enemies + 1] = Bot
				end
			end
		end
		return Enemies
	end
	local AimParams = RaycastParams.new()
	AimParams.FilterType = Enum.RaycastFilterType.Exclude
	AimParams.FilterDescendantsInstances = {LocalPlayer.Character}
	local btHistory = {}
	local function RecordBacktrack()
		local Now = os.clock()
		local Cutoff = Now - main_config.BacktrackTime / 1000
		for Model, Entries in pairs(btHistory) do
			while #Entries > 0 and Entries[1].Time < Cutoff do
				table.remove(Entries, 1)
			end
			if #Entries == 0 then
				btHistory[Model] = nil
			end
		end
		if not main_config.Backtrack then
			return
		end
		for _, Model in ipairs(GetEnemies()) do
			local Root = Model:FindFirstChild("HumanoidRootPart")
			if Root then
				local Entries = btHistory[Model]
				if not Entries then
					Entries = {}
					btHistory[Model] = Entries
				end
				Entries[#Entries + 1] = {Time = Now, Position = Root.Position}
			end
		end
	end
	local function LookupBacktrack(Model)
		local Entries = btHistory[Model]
		if not Entries or #Entries == 0 then
			return nil
		end
		local TargetTime = os.clock() - main_config.BacktrackTime / 1000
		local Best, BestDiff = nil, math.huge
		for _, Entry in ipairs(Entries) do
			local Diff = math.abs(Entry.Time - TargetTime)
			if Diff < BestDiff then
				Best, BestDiff = Entry, Diff
			end
		end
		return Best and Best.Position or nil
	end
	task.spawn(function()
		while true do
			if main_config.AimPart == "All" then
				main_config.RandPart = aimParts[math.random(1, #aimParts)]
				part_flag.Value = main_config.RandPart
				aimPartLabel:Set("aim part: all (" .. main_config.RandPart .. ")")
			end
			task.wait(1.5)
		end
	end)
	local espScreen = Instance.new("ScreenGui")
	espScreen.Name = "CredibilityDraw"
	espScreen.DisplayOrder = 8887
	espScreen.IgnoreGuiInset = true
	espScreen.ResetOnSpawn = false
	espScreen.Parent = cre
	local fovFrame = Instance.new("Frame")
	fovFrame.Name = "FOV"
	fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	fovFrame.BackgroundTransparency = 1
	fovFrame.BorderSizePixel = 0
	fovFrame.Visible = false
	fovFrame.ZIndex = 5
	fovFrame.Parent = espScreen
	local fovCorner = Instance.new("UICorner")
	fovCorner.CornerRadius = UDim.new(1, 0)
	fovCorner.Parent = fovFrame
	local fovStroke = Instance.new("UIStroke")
	fovStroke.Color = Color3.fromRGB(255, 70, 70)
	fovStroke.Thickness = 1
	fovStroke.Transparency = 0.3
	fovStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	fovStroke.Parent = fovFrame
	local function GetAimTarget()
		local Camera = Workspace.CurrentCamera
		if not Camera then
			return nil, nil
		end
		AimParams.FilterDescendantsInstances = {LocalPlayer.Character}
		local Viewport = Camera.ViewportSize
		local Center = Vector2.new(Viewport.X / 2, Viewport.Y / 2)
		local BestPart, BestPosition, BestDistance = nil, nil, main_config.Fov
		local AimName = main_config.AimPart == "All" and main_config.RandPart or main_config.AimPart
		for _, Model in ipairs(GetEnemies()) do
			local Part = Model:FindFirstChild(AimName)
				or Model:FindFirstChild("Head")
				or Model:FindFirstChild("HumanoidRootPart")
			if Part then
				local Screen, OnScreen = Camera:WorldToViewportPoint(Part.Position)
				if OnScreen then
					local Distance = (Vector2.new(Screen.X, Screen.Y) - Center).Magnitude
					if Distance <= BestDistance then
						local Visible = true
						if main_config.VisibleCheck then
							local Result = Workspace:Raycast(
								Camera.CFrame.Position,
								Part.Position - Camera.CFrame.Position,
								AimParams
							)
							Visible = Result == nil or Result.Instance:IsDescendantOf(Model)
						end
						if Visible then
							BestPart, BestPosition, BestDistance = Part, Part.Position, Distance
							if main_config.Backtrack then
								local Past = LookupBacktrack(Model)
								if Past then
									BestPosition = Past
								end
							end
						end
					end
				end
			end
		end
		return BestPart, BestPosition
	end
	local silent_source = [=[
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local RunService = game:GetService("RunService")
		local silentFlag = ReplicatedStorage:WaitForChild("Credibility_SilentAim")
		local teamFlag = ReplicatedStorage:WaitForChild("Credibility_TeamCheck")
		local visibleFlag = ReplicatedStorage:WaitForChild("Credibility_VisibleCheck")
		local partFlag = ReplicatedStorage:WaitForChild("Credibility_AimPart")
		local btFlag = ReplicatedStorage:WaitForChild("Credibility_Backtrack")
		local btTimeFlag = ReplicatedStorage:WaitForChild("Credibility_BacktrackTime")
		local targetPlayer = nil
		local aimPosition = nil
		local history = {}

		local function RecordHistory()
			local now = os.clock()
			for _, v in pairs(game.Players:GetPlayers()) do
				if v ~= game.Players.LocalPlayer then
					local char = v.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					if hrp then
						local entries = history[v]
						if not entries then
							entries = {}
							history[v] = entries
						end
						entries[#entries + 1] = {time = now, position = hrp.Position}
						local cutoff = now - (btTimeFlag.Value / 1000)
						while #entries > 0 and entries[1].time < cutoff do
							table.remove(entries, 1)
						end
					end
				end
			end
		end

		local function isVisible(target)
			local origin = game.workspace.CurrentCamera.CFrame
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
			params.IgnoreWater = true

			local direction = (target.Position - origin.Position)
			local result = workspace:Raycast(origin.Position, direction, params)

			if result then
				return game.Players:GetPlayerFromCharacter(result.Instance:FindFirstAncestorOfClass("Model")) ~= nil
			else
				return true
			end
		end

		local function GetClosestPlayer()
			local closestDistance = math.huge
			local closest = nil
			local closestPlayer = nil
			local camera = workspace.CurrentCamera

			for _, v in pairs(game.Players:GetPlayers()) do
				if v == game.Players.LocalPlayer then continue end

				local char = v.Character
				if not char then continue end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if not hrp then continue end
				local hum = char:FindFirstChild("Humanoid")
				if not hum or hum.Health <= 0 then continue end

				if teamFlag.Value then
					local myteam = game.Players.LocalPlayer.Team and game.Players.LocalPlayer.Team.Name
					local theirTeam = v.Team and v.Team.Name

					if myteam and theirTeam and myteam == theirTeam then
						continue
					end
				end

				local part = char:FindFirstChild(partFlag.Value) or char:FindFirstChild("Head") or hrp
				local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
				if onScreen then
					local distance = (Vector2.new(screenPos.X, screenPos.Y) - camera.ViewportSize / 2).Magnitude
					if distance < closestDistance then
						if visibleFlag.Value and not isVisible(part) then continue end
						closestDistance = distance
						closest = part
						closestPlayer = v
					end
				end
			end

			return closest, closestPlayer
		end

		RunService.RenderStepped:Connect(function()
			RecordHistory()
			if silentFlag.Value then
				local part, player = GetClosestPlayer()
				targetPlayer = player
				if part then
					aimPosition = part.Position
					if btFlag.Value and player then
						local entries = history[player]
						if entries and #entries > 0 then
							local targetTime = os.clock() - (btTimeFlag.Value / 1000)
							local best, bestDiff = nil, math.huge
							for _, entry in ipairs(entries) do
								local diff = math.abs(entry.time - targetTime)
								if diff < bestDiff then
									best, bestDiff = entry, diff
								end
							end
							if best then
								aimPosition = best.position
							end
						end
					end
				end
			else
				targetPlayer = nil
				aimPosition = nil
			end
		end)

		for i, v in pairs(getgc()) do
			if type(v) == "function" and islclosure(v) then
				if debug.info(v, "a") == 2 and #debug.getupvalues(v) == 2 and #debug.getconstants(v) == 17 and debug.info(v,"n"):len() <= 10 then
					local old
					old = hookfunction(v, function(p1,p2)
						if aimPosition then
							local mychar = game.Players.LocalPlayer.Character
							if mychar then
								local head = mychar:FindFirstChild("Head")
								if head then
									local direction = (aimPosition - head.Position)
									p1 = Ray.new(head.Position, direction)
								end
							end
						end
						return old(p1,p2)
					end)
				end
			end
		end
	]=]

	pcall(function()
		local actors = getactors()
		local actor = actors and actors[1]
		if actor then
			run_on_actor(actor, silent_source)
		end
	end)
	local spinAngle = 0
	local jitterYaw = 0
	local nextJitter = 0
	local aaRotated = false
	local humanizeOffset = Vector3.new()
	local humanizeAlpha = 1
	local nextHumanize = 0
	pcall(function()
		RunService:UnbindFromRenderStep("CredibilityMain")
	end)
	RunService:BindToRenderStep("CredibilityMain", Enum.RenderPriority.Camera.Value + 1, function(dt)
		local Camera = Workspace.CurrentCamera
		if not Camera then
			return
		end
		RecordBacktrack()
		if fovFrame then
			fovFrame.Visible = main_config.ShowFOV
			if fovFrame.Visible then
				fovFrame.Size = UDim2.new(0, main_config.Fov * 2, 0, main_config.Fov * 2)
				fovStroke.Color = main_config.ESPColor
			end
		end
		if main_config.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			local _, Position = GetAimTarget()
			if Position then
				local Alpha = math.max(1 - math.clamp(main_config.Smoothness, 0, 0.95), 0.02)
				if main_config.Humanizer then
					if os.clock() >= nextHumanize then
						nextHumanize = os.clock() + 0.1
						local Amount = main_config.HumanizerAmount / 100
						humanizeOffset = Vector3.new(
							(math.random() - 0.5),
							(math.random() - 0.5),
							(math.random() - 0.5)
						) * Amount * 12
						humanizeAlpha = 1 - math.random() * Amount * 0.5
					end
					Position = Position + humanizeOffset
					Alpha = math.clamp(Alpha * humanizeAlpha, 0.02, 1)
				end
				Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Position), Alpha)
			end
		end
		local Character = LocalPlayer.Character
		local Root = Character and Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local Pitch = main_config.LookDown and math.rad(-89) or 0
		if (main_config.AntiAim or main_config.LookDown) and Root and Humanoid then
			if Humanoid.AutoRotate then
				Humanoid.AutoRotate = false
			end
			aaRotated = true
			spinAngle = (spinAngle + dt * main_config.AntiAimSpeed) % 360
			local Yaw
			if main_config.AntiAim and main_config.AntiAimJitter then
				if os.clock() >= nextJitter then
					nextJitter = os.clock() + 0.1
					jitterYaw = math.rad(math.random(-180, 180))
				end
				Yaw = jitterYaw
			elseif main_config.AntiAim and main_config.AntiAimSpin then
				Yaw = math.rad(spinAngle)
			else
				Yaw = math.atan(Camera.CFrame.LookVector.X, Camera.CFrame.LookVector.Z)
			end
			Root.CFrame = CFrame.new(Root.Position) * CFrame.Angles(0, Yaw, 0) * CFrame.Angles(Pitch, 0, 0)
		elseif aaRotated and Humanoid and Humanoid.AutoRotate == false then
			Humanoid.AutoRotate = true
			aaRotated = false
		end
	end)
	local ESP_TAG = "CredibilityESP"
	local espNodes = {}
	local tracerLines = {}
	local sqLines = {}
	local b3Lines = {}
	local boxSmooth = {}
	local BOX_EDGES = {
		{1, 2}, {2, 3}, {3, 4}, {4, 1},
		{5, 6}, {6, 7}, {7, 8}, {8, 5},
		{1, 5}, {2, 6}, {3, 7}, {4, 8}
	}
	local function MakeLines(Store, Model, Count)
		local Set = Store[Model]
		if Set then
			return Set
		end
		Set = {}
		for i = 1, Count do
			local Line = Instance.new("Frame")
			Line.Name = "Line"
			Line.AnchorPoint = Vector2.new(0.5, 0.5)
			Line.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
			Line.BorderSizePixel = 0
			Line.Visible = false
			Line.ZIndex = 10
			Line.Parent = espScreen
			local Stroke = Instance.new("UIStroke")
			Stroke.Name = "Outline"
			Stroke.Color = Color3.fromRGB(0, 0, 0)
			Stroke.Thickness = 1
			Stroke.Transparency = 0.25
			Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			Stroke.Parent = Line
			Set[i] = Line
		end
		Store[Model] = Set
		return Set
	end
	local function SetLine(Line, X1, Y1, X2, Y2, Color, Thickness, Transparency)
		local Dx = X2 - X1
		local Dy = Y2 - Y1
		local Length = math.sqrt(Dx * Dx + Dy * Dy)
		local Alpha = Transparency or 0
		Line.Position = UDim2.new(0, (X1 + X2) / 2, 0, (Y1 + Y2) / 2)
		Line.Size = UDim2.new(0, Length, 0, Thickness or 2)
		Line.Rotation = math.deg(math.atan2(Dy, Dx))
		Line.BackgroundColor3 = Color
		Line.BackgroundTransparency = Alpha
		local Stroke = Line:FindFirstChild("Outline")
		if Stroke then
			Stroke.Transparency = math.min(1, Alpha + 0.25)
		end
		Line.Visible = Length > 1
	end
	local function HideLines(Store, Model)
		local Set = Store[Model]
		if Set then
			for _, Line in ipairs(Set) do
				Line.Visible = false
			end
		end
	end
	local function ClearLines(Store, Model)
		local Set = Store[Model]
		if Set then
			for _, Line in ipairs(Set) do
				Line:Destroy()
			end
			Store[Model] = nil
		end
	end
	local function GetBounds(Model)
		local MinPos, MaxPos = nil, nil
		for _, Part in ipairs(Model:GetDescendants()) do
			if Part:IsA("BasePart") then
				local Skip = false
				local Ancestor = Part.Parent
				while Ancestor and Ancestor ~= Model do
					if Ancestor:IsA("Accessory") or Ancestor:IsA("Tool") then
						Skip = true
						break
					end
					Ancestor = Ancestor.Parent
				end
				if not Skip then
					local Half = Part.Size * 0.5
					for _, Sx in ipairs({-1, 1}) do
						for _, Sy in ipairs({-1, 1}) do
							for _, Sz in ipairs({-1, 1}) do
								local Corner = Part.CFrame * Vector3.new(Half.X * Sx, Half.Y * Sy, Half.Z * Sz)
								if not MinPos then
									MinPos, MaxPos = Corner, Corner
								else
									MinPos = Vector3.new(
										math.min(MinPos.X, Corner.X),
										math.min(MinPos.Y, Corner.Y),
										math.min(MinPos.Z, Corner.Z)
									)
									MaxPos = Vector3.new(
										math.max(MaxPos.X, Corner.X),
										math.max(MaxPos.Y, Corner.Y),
										math.max(MaxPos.Z, Corner.Z)
									)
								end
							end
						end
					end
				end
			end
		end
		return MinPos, MaxPos
	end
	local function GetCorners(MinPos, MaxPos)
		return {
			Vector3.new(MinPos.X, MaxPos.Y, MinPos.Z),
			Vector3.new(MaxPos.X, MaxPos.Y, MinPos.Z),
			Vector3.new(MaxPos.X, MaxPos.Y, MaxPos.Z),
			Vector3.new(MinPos.X, MaxPos.Y, MaxPos.Z),
			Vector3.new(MinPos.X, MinPos.Y, MinPos.Z),
			Vector3.new(MaxPos.X, MinPos.Y, MinPos.Z),
			Vector3.new(MaxPos.X, MinPos.Y, MaxPos.Z),
			Vector3.new(MinPos.X, MinPos.Y, MaxPos.Z)
		}
	end
	local function DestroyESP(Model)
		ClearLines(sqLines, Model)
		ClearLines(b3Lines, Model)
		ClearLines(tracerLines, Model)
		local Node = espNodes[Model]
		if Node then
			pcall(function()
				Node.Highlight:Destroy()
			end)
			pcall(function()
				Node.Billboard:Destroy()
			end)
			espNodes[Model] = nil
		end
	end
	local function CreateESP(Model)
		local Adornee = Model:FindFirstChild("Head") or Model:FindFirstChild("HumanoidRootPart")
		if not Adornee then
			return
		end
		local Highlight = Instance.new("Highlight")
		Highlight.Name = ESP_TAG
		Highlight.Adornee = Model
		Highlight.FillColor = main_config.ESPColor
		Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		Highlight.FillTransparency = 0.6
		Highlight.OutlineTransparency = 0
		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		Highlight.Parent = Model
		local Billboard = Instance.new("BillboardGui")
		Billboard.Name = ESP_TAG
		Billboard.Adornee = Adornee
		Billboard.Parent = Adornee
		Billboard.Size = UDim2.new(0, 140, 0, 34)
		Billboard.StudsOffset = Vector3.new(0, 2.4, 0)
		Billboard.AlwaysOnTop = true
		Billboard.MaxDistance = math.huge
		local NameLabel = Instance.new("TextLabel")
		NameLabel.Name = "Name"
		NameLabel.Parent = Billboard
		NameLabel.BackgroundTransparency = 1
		NameLabel.Size = UDim2.new(1, 0, 0, 16)
		NameLabel.Font = Enum.Font.Code
		NameLabel.TextSize = 13
		NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		NameLabel.TextStrokeTransparency = 0.4
		NameLabel.Text = Model.Name
		local HealthBack = Instance.new("Frame")
		HealthBack.Name = "HealthBack"
		HealthBack.Parent = Billboard
		HealthBack.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		HealthBack.BorderSizePixel = 0
		HealthBack.Position = UDim2.new(0.25, 0, 0, 20)
		HealthBack.Size = UDim2.new(0.5, 0, 0, 4)
		local HealthFill = Instance.new("Frame")
		HealthFill.Name = "HealthFill"
		HealthFill.Parent = HealthBack
		HealthFill.BackgroundColor3 = Color3.fromRGB(80, 220, 80)
		HealthFill.BorderSizePixel = 0
		HealthFill.Size = UDim2.new(1, 0, 1, 0)
		espNodes[Model] = {
			Highlight = Highlight,
			Billboard = Billboard,
			NameLabel = NameLabel,
			HealthBack = HealthBack,
			HealthFill = HealthFill
		}
	end
	local syncClock = 0
	RunService.Heartbeat:Connect(function(dt)
		if not (main_config.ESP or main_config.TeamESP or main_config.Box2D or main_config.Box3D or main_config.ESPTracers) then
			for Model in pairs(espNodes) do
				DestroyESP(Model)
			end
			for Model in pairs(tracerLines) do
				DestroyESP(Model)
			end
			for Model in pairs(sqLines) do
				DestroyESP(Model)
			end
			for Model in pairs(b3Lines) do
				DestroyESP(Model)
			end
			return
		end
		syncClock = syncClock + dt
		local refreshText = syncClock >= 0.1
		if refreshText then
			syncClock = 0
		end
		local Camera = Workspace.CurrentCamera
		local Viewport = Camera and Camera.ViewportSize
		local LocalRoot = GetLocalRoot()
		local Live = {}
		local Colored = {}
		for _, Model in ipairs(GetEnemies()) do
			Colored[#Colored + 1] = {Model = Model, Color = main_config.ESPColor, Enemy = true}
		end
		if main_config.TeamESP then
			for _, Player in ipairs(Players:GetPlayers()) do
				local Model = Player.Character
				if Player ~= LocalPlayer and IsValidTarget(Model) and not IsEnemy(Model) then
					Colored[#Colored + 1] = {Model = Model, Color = Color3.fromRGB(80, 255, 80), Enemy = false}
				end
			end
		end
		for _, Entry in ipairs(Colored) do
			local Model = Entry.Model
			local Color = Entry.Color
			local ShowNode = Entry.Enemy and main_config.ESP or (not Entry.Enemy and main_config.TeamESP)
			Live[Model] = true
			if not espNodes[Model] then
				CreateESP(Model)
			end
			local Node = espNodes[Model]
			if Node then
				Node.Highlight.Enabled = ShowNode
				Node.Highlight.FillColor = Color
				Node.Highlight.OutlineColor = Color
				Node.Billboard.Enabled = ShowNode and (main_config.ESPNames or main_config.ESPHealth)
				Node.NameLabel.Visible = ShowNode and main_config.ESPNames
				Node.NameLabel.TextColor3 = Color
				Node.HealthBack.Visible = ShowNode and main_config.ESPHealth
				if refreshText and ShowNode then
					local Humanoid = Model:FindFirstChildOfClass("Humanoid")
					local Health = Humanoid and math.clamp(Humanoid.Health / math.max(Humanoid.MaxHealth, 1), 0, 1) or 0
					Node.HealthFill.Size = UDim2.new(Health, 0, 1, 0)
					Node.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 70, 70):Lerp(
						Color3.fromRGB(80, 255, 80),
						Health
					)
					local Root = Model:FindFirstChild("HumanoidRootPart")
					local Distance = (LocalRoot and Root) and math.floor((LocalRoot.Position - Root.Position).Magnitude) or 0
					Node.NameLabel.Text = Model.Name .. " [" .. tostring(Distance) .. "]"
				end
			end
			if Camera and Viewport then
				local MinPos, MaxPos = GetBounds(Model)
				if MinPos and (main_config.Box2D or main_config.Box3D) then
					local Corners = GetCorners(MinPos, MaxPos)
					if main_config.Box2D then
						local Set = MakeLines(sqLines, Model, 4)
						if Set then
							local MinX, MinY, MaxX, MaxY = math.huge, math.huge, -math.huge, -math.huge
							for _, Corner in ipairs(Corners) do
								local Screen, OnScreen = Camera:WorldToViewportPoint(Corner)
								if OnScreen then
									MinX = math.min(MinX, Screen.X)
									MinY = math.min(MinY, Screen.Y)
									MaxX = math.max(MaxX, Screen.X)
									MaxY = math.max(MaxY, Screen.Y)
								end
							end
							if MinX < MaxX and MinY < MaxY then
								SetLine(Set[1], MinX, MinY, MaxX, MinY, Color, 2)
								SetLine(Set[2], MaxX, MinY, MaxX, MaxY, Color, 2)
								SetLine(Set[3], MaxX, MaxY, MinX, MaxY, Color, 2)
								SetLine(Set[4], MinX, MaxY, MinX, MinY, Color, 2)
							else
								for _, Line in ipairs(Set) do
									Line.Visible = false
								end
							end
						end
					else
						HideLines(sqLines, Model)
					end
					if main_config.Box3D then
						local Set = MakeLines(b3Lines, Model, 12)
						if Set then
							for Index, Edge in ipairs(BOX_EDGES) do
								local Line = Set[Index]
								local ScreenA, OnA = Camera:WorldToViewportPoint(Corners[Edge[1]])
								local ScreenB, OnB = Camera:WorldToViewportPoint(Corners[Edge[2]])
								if OnA and OnB then
									SetLine(Line, ScreenA.X, ScreenA.Y, ScreenB.X, ScreenB.Y, Color, 2)
								else
									Line.Visible = false
								end
							end
						end
					else
						HideLines(b3Lines, Model)
					end
				else
					HideLines(sqLines, Model)
					HideLines(b3Lines, Model)
				end
				if main_config.ESPTracers then
					local Set = MakeLines(tracerLines, Model, 1)
					if Set then
						local Line = Set[1]
						Line.Visible = false
						local Root = Model:FindFirstChild("HumanoidRootPart")
						if Root then
							local Screen, OnScreen = Camera:WorldToViewportPoint(Root.Position)
							if OnScreen then
								SetLine(Line, Viewport.X / 2, Viewport.Y, Screen.X, Screen.Y, Color, 2)
							end
						end
					end
				else
					HideLines(tracerLines, Model)
				end
			end
		end
		for Model in pairs(espNodes) do
			if not Live[Model] then
				DestroyESP(Model)
			end
		end
		for Model in pairs(tracerLines) do
			if not Live[Model] then
				DestroyESP(Model)
			end
		end
		for Model in pairs(sqLines) do
			if not Live[Model] then
				DestroyESP(Model)
			end
		end
		for Model in pairs(b3Lines) do
			if not Live[Model] then
				DestroyESP(Model)
			end
		end
	end)
end
aimbot:Turn(true)
print("Credibility Loaded muthafucka")
local menuScreen = cre:FindFirstChild("credibility")
if menuScreen then
	menuScreen.Enabled = false
end
local splash = Instance.new("ScreenGui")
splash.Name = "CredibilitySplash"
splash.IgnoreGuiInset = true
splash.DisplayOrder = 100000
splash.ResetOnSpawn = false
splash.Parent = cre
local splashImage = Instance.new("ImageLabel")
splashImage.Name = "Image"
splashImage.BackgroundTransparency = 1
splashImage.BorderSizePixel = 0
splashImage.AnchorPoint = Vector2.new(0.5, 0.5)
splashImage.Position = UDim2.new(0.5, 0, 0.5, 0)
splashImage.Size = UDim2.new(0.6, 0, 0.6, 0)
splashImage.ScaleType = Enum.ScaleType.Fit
splashImage.Image = "rbxassetid://122133723181551"
splashImage.Parent = splash
local splashLine1 = Instance.new("TextLabel")
splashLine1.Name = "Line1"
splashLine1.BackgroundTransparency = 1
splashLine1.BorderSizePixel = 0
splashLine1.AnchorPoint = Vector2.new(0.5, 1)
splashLine1.Position = UDim2.new(0.5, 0, 1, -52)
splashLine1.Size = UDim2.new(1, 0, 0, 24)
splashLine1.Font = Enum.Font.Code
splashLine1.Text = "right shift open close"
splashLine1.TextSize = 20
splashLine1.TextColor3 = Color3.fromRGB(255, 255, 255)
splashLine1.TextStrokeTransparency = 0.4
splashLine1.Parent = splash
local splashLine2 = Instance.new("TextLabel")
splashLine2.Name = "Line2"
splashLine2.BackgroundTransparency = 1
splashLine2.BorderSizePixel = 0
splashLine2.AnchorPoint = Vector2.new(0.5, 1)
splashLine2.Position = UDim2.new(0.5, 0, 1, -26)
splashLine2.Size = UDim2.new(1, 0, 0, 24)
splashLine2.Font = Enum.Font.Code
splashLine2.Text = "No Nut November boys"
splashLine2.TextSize = 20
splashLine2.TextColor3 = Color3.fromRGB(255, 255, 255)
splashLine2.TextStrokeTransparency = 0.4
splashLine2.Parent = splash
task.delay(5, function()
	for step = 1, 10 do
		local alpha = step / 10
		splashImage.ImageTransparency = alpha
		splashLine1.TextTransparency = alpha
		splashLine2.TextTransparency = alpha
		task.wait(0.05)
	end
	splash:Destroy()
	if library.setMenuOpen then
		library.setMenuOpen(true)
	elseif menuScreen then
		menuScreen.Enabled = true
	end
end)
return library, utility, obelus
