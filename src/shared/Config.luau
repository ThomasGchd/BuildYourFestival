local Config = {}
Config.StartCash = 300
Config.PlotCount = 8
Config.MaxStageLevel = 25
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
 {name="PETITE SOIREE",need=5},
 {name="PETITE SCENE",need=15},
 {name="SCENE LOCALE",need=35},
 {name="FESTIVAL",need=70},
 {name="GROS FESTIVAL",need=120},
 {name="MEGA FESTIVAL",need=190},
}

-- Creator Store music. Keep this list curated: arbitrary user audio IDs are never accepted.
Config.Music = {
 {name="Ignited", genre="Electro House", soundId="rbxassetid://1842904926"},
 {name="Let's Make It Hot", genre="House / EDM", soundId="rbxassetid://1843398050"},
 {name="High Velocity", genre="Dance Rock", soundId="rbxassetid://1839898469"},
 {name="Mindwinder", genre="Drum & Bass", soundId="rbxassetid://1838075377"},
 {name="Future Glow", genre="Future / DnB", soundId="rbxassetid://9045455789"},
 {name="Store", genre="Electro House", soundId="rbxassetid://1837393392"},
 {name="Circles and Circles", genre="Electronic", soundId="rbxassetid://1837393324"},
 {name="Dusk To Dawn", genre="Lo-Fi", soundId="rbxassetid://9047105308"},
 {name="Bring the Respect", genre="Hip-Hop", soundId="rbxassetid://9042399843"},
}
return Config