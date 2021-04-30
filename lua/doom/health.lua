-- Health status
local health_start = fn['health#report_start']
local health_ok = fn['health#report_ok']
local health_error = fn['health#report_error']
local health_warn = fn['health#report_warn']

local M = {}

-- Installation health
local function install_health()
	health_start('Installation')

	---[[-----------------------]]---
	--    REQUIRED DEPENDENCIES    --
	---]]-----------------------[[---
	-- Check Git
	if fn.executable('git') == 0 then
		health_error('`git` executable not found.', {
			'Install it with your package manager.',
			'Check that your `$PATH` is set correctly.',
		})
	else
		health_ok('`git` executable found.')
	end

	---[[-----------------------]]---
	--    OPTIONAL DEPENDENCIES    --
	---]]-----------------------[[---
	-- Ripgrep and fd
	if fn.executable('rg') == 0 then
		health_warn('`rg` executable not found.', {
			'Required to improve file indexing performance for some commands',
			'Ignore this message if you have `fd` installed.',
		})
	else
		health_ok('`rg` executable found.')
	end
	if fn.executable('fd') == 0 then
		health_warn('`fd` executable not found.', {
			'Required to improve file indexing performance for some commands',
			'Ignore this message if you have `rg` installed.',
		})
	else
		health_ok('`fd` executable found.')
	end

	-- Check NodeJS and NPM
	if fn.executable('node') == 0 then
		health_warn('`node` executable not found.', {
			'Required by the built-in LSP to work, you should need to install it if you want to use LSP.',
		})
	else
		health_ok('`node` executable found.')
	end
	if fn.executable('npm') == 0 then
		health_warn('`npm` executable not found.', {
			'Required by the built-in LSP to work, you should need to install it if you want to use LSP.',
			'If node is installed but npm is not, you should need to install it with your package manager',
		})
	else
		health_ok('`npm` executable found.')
	end
end

function M.checkhealth()
	-- Installation checks
	install_health()
end

return M