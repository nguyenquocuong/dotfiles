local utils = require("configs.utils")
local icons = require("configs.icons")

utils.desc("<leader>a", "AI")

-- Copilot autosuggestions
vim.g.copilot_no_tab_map = true
vim.g.copilot_hide_during_completion = false
vim.g.copilot_proxy_strict_ssl = false
vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
vim.keymap.set("i", "<A-l>", 'copilot#Accept("\\<A-l>")', { expr = true, replace_keycodes = false })

-- Copilot chat
local chat = require("CopilotChat")
local prompts = require("CopilotChat.config.prompts")
local select = require("CopilotChat.select")
local cutils = require("CopilotChat.utils")

local COPILOT_PLAN = [[
You are a software architect and technical planner focused on clear, actionable development plans.
]] .. prompts.COPILOT_BASE.system_prompt .. [[

When creating development plans:
- Start with a high-level overview
- Break down into concrete implementation steps
- Identify potential challenges and their solutions
- Consider architectural impacts
- Note required dependencies or prerequisites
- Estimate complexity and effort levels
- Track confidence percentage (0-100%)
- Format in markdown with clear sections

Always end with:
"Current Confidence Level: X%"
"Would you like to proceed with implementation?" (only if confidence >= 90%)
]]

chat.setup({
	model = "gpt-4.1",
	debug = true,
	temperature = 0,
	question_header = " " .. icons.ui.User .. " ",
	answer_header = " " .. icons.ui.Bot .. " ",
	error_header = "> " .. icons.diagnostics.Warn .. " ",
	sticky = "#buffers",
	mappings = {
		reset = false,
		show_diff = {
			full_diff = true,
		},
	},
	prompts = {
		Explain = {
			mapping = "<leader>ae",
			description = "AI Explain",
		},
		Review = {
			mapping = "<leader>ar",
			description = "AI Review",
		},
		Tests = {
			mapping = "<leader>at",
			description = "AI Tests",
		},
		Fix = {
			mapping = "<leader>af",
			description = "AI Fix",
		},
		Optimize = {
			mapping = "<leader>ao",
			description = "AI Optimize",
		},
		Docs = {
			mapping = "<leader>ad",
			description = "AI Documentation",
		},
		Commit = {
			mapping = "<leader>ac",
			description = "AI Generate Commit",
			selection = select.buffer,
		},
		Plan = {
			prompt = "Create or update the development plan for the selected code. Focus on architecture, implementation steps, and potential challenges.",
			system_prompt = COPILOT_PLAN,
			context = "file:.copilot/plan.md",
			progress = function()
				return false
			end,
			callback = function(response, source)
				chat.chat:append("Plan updated successfully!", source.winnr)
				local plan_file = source.cwd() .. "/.copilot/plan.md"
				local dir = vim.fn.fnamemodify(plan_file, ":h")
				vim.fn.mkdir(dir, "p")
				local file = io.open(plan_file, "w")
				if file then
					file:write(response)
					file:close()
				end
			end,
		},
	},
})

utils.au("BufEnter", {
	pattern = "copilot-*",
	callback = function()
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
	end,
})

vim.keymap.set({ "n" }, "<leader>aa", chat.toggle, { desc = "AI Toggle" })
vim.keymap.set({ "v" }, "<leader>aa", chat.open, { desc = "AI Open" })
vim.keymap.set({ "n" }, "<leader>ax", chat.reset, { desc = "AI Reset" })
vim.keymap.set({ "n" }, "<leader>as", chat.stop, { desc = "AI Stop" })
vim.keymap.set({ "n" }, "<leader>am", chat.select_model, { desc = "AI Models" })
vim.keymap.set({ "n", "v" }, "<leader>ap", chat.select_prompt, { desc = "AI Prompts" })
vim.keymap.set({ "n", "v" }, "<leader>aq", function()
	vim.ui.input({
		prompt = "AI Question> ",
	}, function(input)
		if input ~= "" then
			chat.ask(input)
		end
	end)
end, { desc = "AI Question" })
