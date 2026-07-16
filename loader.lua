if getgenv().key ~= "vault" then -- i know this is in plain text and easy asf to bypass, its just to get more people in the server <3
  game.Players.LocalPlayer:Kick("please join the discord at https://discord.gg/Z7tvDkBUxX for the key")
end

local repo = "https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/"
local function load(filename)
  loadstring(game:HttpGet(repo .. filename .. ".lua"))()
end
if game.PlaceId == 87444640442831 or game.PlaceId == 121583187398542 then
  load("untitledshooter2")
elseif game.PlaceId == 72920620366355 then
  load("op1")
elseif game.PlaceId == 13687899540 or game.PlaceId == 92518636938049 or game.PlaceId == 121650045752508 then
  load("coldwar")
end
