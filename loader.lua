local repo = "https://raw.githubusercontent.com/ttokennxyz/vaultcc/refs/heads/main/"
local function load(filename)
  loadstring(game:HttpGet(repo .. filename .. ".lua"))()
end
if game.PlaceId == 87444640442831 or game.PlaceId == 121583187398542 then
  load("untitledshooter2")
end
