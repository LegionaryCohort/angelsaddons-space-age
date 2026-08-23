--INITIALIZE
angelsmods = angelsmods or {}
local OV = angelsmods.functions.OV

-- Change oil ocean tiles to crude-oil - Offshore pumps will use the "fluid" field.
data.raw.tile["oil-ocean-shallow"].fluid = "crude-oil"
data.raw.tile["oil-ocean-deep"].fluid = "crude-oil"

-- Many Fulgora recipes require electronic-circuit but there is no way to get them on Fulgora. 
if mods["bobelectronics"] then
    local scrap_results = data.raw["recipe"]["scrap-recycling"].results
    table.insert(scrap_results,
        {type = "item", name = "electronic-circuit", amount = 1, probability = 0.1, show_details_in_recipe_tooltip = false})
	data.raw.furnace["recycler"].result_inventory_size = 13
end

-- merge carbon from space age into angels carbon, see also migrations
if mods["angelspetrochem"] then
  OV.global_replace_item("carbon", "angels-solid-carbon")
  data.raw.recipe["carbon"].icon = data.raw.recipe["angels-solid-carbon"].icon
end

OV.execute()

-- bobswarfare adds coal to the firearm-magazine recipe, but coal is not readily available in space. This adds another recipe for firearm-magazine that uses carbon instead of coal.
if mods["bobwarfare"] then
  local firearm_mags_from_carbon = table.deepcopy(data.raw["recipe"]["firearm-magazine"])
  firearm_mags_from_carbon.name = "firearm-magazine-carbon"
  firearm_mags_from_carbon.enabled = false
  firearm_mags_from_carbon.surface_conditions = {{
    property = "gravity",
    max = 0.1
  }}
  firearm_mags_from_carbon.ingredients = {
    {type = "item", name = "iron-plate", amount = 2},
    {type = "item", name = "carbon", amount = 1}
  }

  data:extend{firearm_mags_from_carbon}
end

-- Adding void recipes for space-age-fluids.
-- Notice that I didn't include Holmium Solution since it is ore based. It wouldn't make sense to void it.
angelsmods.functions.make_void("ammonia", "chemical")
angelsmods.functions.make_void("ammoniacal-solution", "water")
angelsmods.functions.make_void("electrolyte", "chemical")
angelsmods.functions.make_void("fluoroketone-hot", "chemical")
angelsmods.functions.make_void("fluoroketone-cold", "chemical")
angelsmods.functions.make_void("fluorine", "chemical")
angelsmods.functions.make_void("lithium-brine", "water")

-- SPACE ORE
-- As discussed in this forum post (https://mods.factorio.com/mod/angelsaddons-space-age/discussion/6985b9f28a864037e5e3ab33)
-- Adjusts some recipes to allow the production of Angel's Ores in space
data:extend{
  {
    type = "recipe",
    name = "angelsaddons-space-age-asteroid-dissolution",
    category = "angels-liquifying",
    subgroup = "angels-liquifying",
    energy_required = 5,
    enabled = false,
    auto_recycle = false,
    ingredients = {
      { type = "item", name = "metallic-asteroid-chunk", amount = 1 },
      { type = "fluid", name = "angels-liquid-ferric-chloride-solution", amount = 20 },
    },
    results = {
      { type = "fluid", name = "angels-slag-slurry", amount = 50 },
    },
    always_show_products = true,
    icons = angelsmods.functions.create_liquid_recipe_icon(
      nil,
      { { 142, 079, 028 }, { 107, 062, 021 }, { 075, 040, 015 } },
      { "metallic-asteroid-chunk" }
    ),
    crafting_machine_tint = angelsmods.functions.get_fluid_recipe_tint("angels-slag-slurry"),
    order = "i [slag-processing-dissolution]-a",
  }
}

-- TODO Gleba:
--		Bacteria decay into ferrous and cupric powder
--		Add reverse sorting recipes to get back the 6 base ores (already crushed)
