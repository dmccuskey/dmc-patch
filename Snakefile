# dmc-patch

try:
	if not gSTARTED: print( gSTARTED )
except:
	MODULE = "dmc-patch"
	include: "../DMC-Corona-Library/snakemake/Snakefile"

module_config = {
	"name": "dmc-patch",
	"module": {
		"dir": "dmc_corona",
		"files": [
			"dmc_patch.lua"
		],
		"requires": [
			"dmc-corona-boot",
			"DMC-Lua-Library"
		]
	},
	"tests": {
		"files": [],
		"requires": []
	}
}

register( "dmc-patch", module_config )

