local Config = {}
Config.StartCash = 300
Config.PlotCount = 8
Config.MaxStageLevel = 40
Config.MainstageProductId = 0 -- Replace with the real Developer Product ID before publishing
Config.StageUpgradeCosts = {50,120,250,500,900,1500,2500,4000}
Config.Branches = {
 Stage={label="SCENE",base=100,growth=1.34,max=40},
 Sound={label="SON",base=80,growth=1.32,max=40},
 Lights={label="LIGHTS",base=90,growth=1.33,max=40},
 FX={label="FX",base=130,growth=1.35,max=35},
 Crowd={label="PUBLIC",base=75,growth=1.30,max=50},
 Stands={label="STANDS",base=110,growth=1.34,max=40},
 Marketing={label="MARKETING",base=120,growth=1.34,max=45},
 Staff={label="EQUIPE",base=105,growth=1.33,max=45},
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
 {name="Jumpstyle", genre="Jumpstyle / Techno", soundId="rbxassetid://1839246711"},
 {name="Fast Rave", genre="Techno / Rave", soundId="rbxassetid://1839246840"},
 {name="Fast Pace A", genre="Techno", soundId="rbxassetid://1846971107"},
 {name="Space Trucker", genre="Techno", soundId="rbxassetid://1840537359"},
 {name="67 KID HARDSTYLE", genre="Hardstyle", soundId="rbxassetid://120386531011776"},
 {name="Sonic Terror", genre="Hardcore / Gabber", soundId="rbxassetid://99540892657085"},
 {name="Pandemonium", genre="Techno Groove", soundId="rbxassetid://1843460528"},
 {name="Lose Control", genre="Hard Electro", soundId="rbxassetid://1839925593"},
 {name="Grey Shores", genre="Industrial / Dark", soundId="rbxassetid://9040092810"},
 {name="Electronic Music", genre="Electronic", soundId="rbxassetid://134270835038966"},
}
return Config