-- lua/custom/plugins/runner.lua
-- Lance le fichier courant dans un terminal en bas, sans debugger.

local runners = {
  python = function(file)
    local py = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') or 'python3'
    return { py, file }
  end,
  lua = function(file) return { 'lua', file } end,
  javascript = function(file) return { 'node', file } end,
  go = function(file) return { 'go', 'run', file } end,
  sh = function(file) return { 'bash', file } end,
}

local run_buf, run_win

local function win_valid() return run_win and vim.api.nvim_win_is_valid(run_win) end
local function buf_valid() return run_buf and vim.api.nvim_buf_is_valid(run_buf) end

local function run_file()
  local runner = runners[vim.bo.filetype]
  if not runner then return vim.notify('Pas de runner pour ' .. vim.bo.filetype, vim.log.levels.WARN) end

  vim.cmd 'silent! write'
  local cmd = runner(vim.fn.expand '%:p')
  local cwd = vim.fn.expand '%:p:h' -- remplace par vim.fn.getcwd() pour lancer depuis la racine du projet
  local origin = vim.api.nvim_get_current_win()

  -- Ferme l'ancien terminal
  if win_valid() then vim.api.nvim_win_close(run_win, true) end
  if buf_valid() then vim.api.nvim_buf_delete(run_buf, { force = true }) end

  vim.cmd 'botright 15new'
  run_win = vim.api.nvim_get_current_win()
  run_buf = vim.api.nvim_get_current_buf()

  if vim.fn.has 'nvim-0.11' == 1 then
    vim.fn.jobstart(cmd, { term = true, cwd = cwd })
  else
    vim.fn.termopen(cmd, { cwd = cwd })
  end

  vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = run_buf, desc = 'Fermer le terminal' })
  vim.cmd 'stopinsert'
  vim.api.nvim_set_current_win(origin) -- le curseur reste dans ton code
end

local function toggle_terminal()
  if win_valid() then
    vim.api.nvim_win_close(run_win, true)
  elseif buf_valid() then
    vim.cmd 'botright 15split'
    run_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(run_win, run_buf)
  else
    vim.notify('Aucun terminal de sortie', vim.log.levels.INFO)
  end
end

vim.keymap.set('n', '<leader>lr', run_file, { desc = '[L]aunch: [R]un file' })
vim.keymap.set('n', '<leader>lt', toggle_terminal, { desc = '[L]aunch: toggle [T]erminal output' })

-- Évite que la sortie ne déforme nvim-tree
vim.opt.equalalways = false

-- Groupe which-key (fusionné avec la config de kickstart)
return {
  {
    'folke/which-key.nvim',
    opts = {
      spec = {
        { '<leader>l', group = '[L]aunch / Run' },
      },
    },
  },
}
