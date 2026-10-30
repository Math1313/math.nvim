return {
  -- Ouvrir/éditer les .ipynb comme du texte
  {
    'GCBallesteros/jupytext.nvim',
    lazy = false,
    config = function()
      require('jupytext').setup {
        style = 'markdown', -- ou "hydrogen" pour du .py avec # %%
        output_extension = 'md', -- "auto" avec hydrogen
        force_ft = 'markdown', -- "python" avec hydrogen
      }
    end,
  },

  -- Exécution des cellules (optionnel)
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    build = ':UpdateRemotePlugins',
    init = function() vim.g.molten_output_win_max_height = 20 end,
  },
}
