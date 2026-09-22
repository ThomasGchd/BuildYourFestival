local Config = {}
Config.StartCash = 300
Config.PlotCount = 8
Config.MaxStageLevel = 40
Config.MainstageProductId = 0 -- Replace with the real Developer Product ID before publishing
Config.StageUpgradeCosts = {50,120,250,500,900,1500,2500,4000}
Config.Branches = {
 Stage={label="SCENE",base=100,growth=1.16,max=40},
 Sound={label="SON",base=80,growth=1.15,max=40},
 Lights={label="LIGHTS",base=90,growth=1.15,max=40},
 FX={label="FX",base=130,growth=1.17,max=35},
 Crowd={label="PUBLIC",base=75,growth=1.14,max=50},
 Stands={label="STANDS",base=110,growth=1.16,max=40},
 Marketing={label="MARKETING",base=120,growth=1.16,max=45},
 Staff={label="EQUIPE",base=105,growth=1.15,max=45},
}
Config.PrestigeBaseCost = 250000
Config.TycoonPhases = {
 {name="DEPART",need=0},
 {name="PETITE SOIREE",need=6},
 {name="PETITE SCENE",need=20},
 {name="SCENE LOCALE",need=50},
 {name="FESTIVAL",need=100},
 {name="GROS FESTIVAL",need=180},
 {name="MEGA FESTIVAL",need=300},
}

-- Creator Store music. Keep this list curated: arbitrary user audio IDs are never accepted.
Config.Music = {
 -- Known-working Creator Store tracks kept as the reliable base queue.
 {style="ELECTRO", name="Ignited", genre="Electro House", soundId="rbxassetid://1842904926"},
 {style="ELECTRO", name="Let's Make It Hot", genre="House / EDM", soundId="rbxassetid://1843398050"},
 {style="HARD", name="High Velocity", genre="Dance Rock", soundId="rbxassetid://1839898469"},
 {style="DRUM & BASS", name="Mindwinder", genre="Drum & Bass", soundId="rbxassetid://1838075377"},
 {style="DRUM & BASS", name="Future Glow", genre="Future / DnB", soundId="rbxassetid://9045455789"},
 {style="ELECTRO", name="Store", genre="Electro House", soundId="rbxassetid://1837393392"},
 {style="ELECTRO", name="Circles and Circles", genre="Electronic", soundId="rbxassetid://1837393324"},
 -- Harder additions. Music.lua skips any asset Roblox refuses to load.
 {style="JUMPSTYLE", name="Jumpstyle", genre="Jumpstyle / Techno", soundId="rbxassetid://1839246711"},
 {style="TECHNO", name="Fast Rave", genre="Techno / Rave", soundId="rbxassetid://1839246840"},
 {style="TECHNO", name="Fast Pace A", genre="Techno", soundId="rbxassetid://1846971107"},
 {style="TECHNO", name="Space Trucker", genre="Techno", soundId="rbxassetid://1840537359"},
 {style="TECHNO", name="Pandemonium", genre="Techno Groove", soundId="rbxassetid://1843460528"},
 {style="HARDSTYLE", name="Lose Control", genre="Hard Electro", soundId="rbxassetid://1839925593"},
 {style="INDUS", name="Grey Shores", genre="Industrial / Dark", soundId="rbxassetid://9040092810"},
}
return Config