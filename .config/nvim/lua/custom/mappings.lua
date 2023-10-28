---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },

		-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
		-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
		-- empty mode is same as using <cmd> :map
		-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
		["j"] = { 'v:count || mode(1)[0:1] == "no" ? "jzz" : "gjzz"', "Move down", opts = { expr = true } },
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "kzz" : "gkzz"', "Move up", opts = { expr = true } },
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "kzz" : "gkzz"', "Move up", opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "jzz" : "gjzz"', "Move down", opts = { expr = true } },

		["<C-d>"] = {
			'v:count ? "\\<C-u>" . v:count1 . "\\<C-d>zz" : "\\<C-d>zz"',
			"Scroll down",
			opts = { expr = true },
		},
		["<C-u>"] = {
			'v:count ? "\\<C-u>" . v:count1 . "\\<C-u>zz" : "\\<C-u>zz"',
			"Scroll up",
			opts = { expr = true },
		},
	},
}

-- more keybinds!

return M
