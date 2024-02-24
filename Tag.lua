TagsModule = getgenv().TagsModule or setmetatable({
    playerTags = {},
}, {
    __tostring = function(self)
        return "TagsModule: " .. tostring(self.playerTags)
    end,
    __newindex = function()
        return error("error: index not found")
    end,
    __index = function(self, key)
        if key == "dummyFunction" then
            return function()
                print("This is a dummy function.")
            end
        else
            return rawget(self, key)
        end
    end,
    __call = function(self, ...)
        print("TagsModule is called with arguments:", ...)
    end
})

function TagsModule:addTag(tag, player, data)
    player = player or game.Players.LocalPlayer
    local playerName = player.Name
    self.playerTags[playerName] = self.playerTags[playerName] or {}
    table.insert(self.playerTags[playerName], { tag = tag, Data = data or {} })
end

function TagsModule:getTagData(tag, player)
    local playerTags = self.playerTags[player.Name]
    return playerTags and (playerTags.find(function(tagData) return tagData.tag == tag end) or {}).Data or nil
end

function TagsModule:addTagData(tag, player, newData)
    local tagData = self.playerTags[player.Name].find(function(td) return td.tag == tag end)
    if tagData then
        for key, value in pairs(newData) do
            tagData.Data[key] = value
        end
    end
end

function TagsModule:clearTagData(tag, player)
    local tagData = self.playerTags[player.Name].find(function(td) return td.tag == tag end)
    if tagData then
        tagData.Data = {}
    end
end

function TagsModule:removeTagData(tag, player, key)
    local tagData = self.playerTags[player.Name].find(function(td) return td.tag == tag end)
    if tagData then
        tagData.Data[key] = nil
    end
end

function TagsModule:isTag(tag, player)
    return (self.playerTags[player.Name] or {}).any(function(tagData) return tagData.tag == tag end) or false
end

function TagsModule:removeTag(tag, player)
    local playerName = player.Name
    local playerTags = self.playerTags[playerName]
    local indexToRemove = playerTags.findIndex(function(tagData) return tagData.tag == tag end)
    if indexToRemove then
        table.remove(playerTags, indexToRemove)
    end
end

function TagsModule:getAllTags(player)
    local playerName = player.Name
    return (self.playerTags[playerName] or {}).map(function(tagData) return tagData.tag end) or {}
end

function TagsModule:getAllPlayerTags()
    return self.playerTags.map(function(playerTags, playerName)
        return { [playerName] = playerTags.map(function(tagData) return { tag = tagData.tag, Data = tagData.Data } end) }
    end)
end

getgenv().TagsModule = TagsModule;
-- Example usage with players in Roblox:
-- local tagsModule = TagsModule
-- local player1 = game.Players.LocalPlayer -- Replace with actual player references
-- local player2 = game.Players["Player2"]
-- tagsModule:addTag("admin", player1, {level = 3})
-- tagsModule:addTagData("admin", player1, {score = 100})
-- print(tagsModule:getTagData("admin", player1).level) -- 3
-- print(tagsModule:getTagData("admin", player1).score) -- 100
-- tagsModule:clearTagData("admin", player1)
-- print(tagsModule:getTagData("admin", player1).score) -- nil
-- tagsModule:removeTagData("admin", player1, "level")
-- print(tagsModule:getTagData("admin", player1).level) -- nil
-- tagsModule:removeTag("admin", player1)
-- print(tagsModule:getAllTags(player1)) -- {}
-- print(tagsModule:getAllPlayerTags()) -- { Player1 = {}, Player2 = {} }

return TagsModule;
