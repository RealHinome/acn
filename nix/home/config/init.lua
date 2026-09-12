vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 200
opt.timeoutlen = 400
opt.splitbelow = true
opt.splitright = true
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

local map = vim.keymap.set
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

local function find_cargo_manifest(bufnr)
  bufnr = bufnr or 0
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" then
    return nil
  end

  return vim.fs.find("Cargo.toml", {
    path = vim.fs.dirname(filename),
    upward = true,
    type = "file",
    limit = 1,
  })[1]
end

local function manifest_is_verus(manifest)
  if not manifest then
    return false
  end

  local ok, lines = pcall(vim.fn.readfile, manifest)
  if not ok then
    return false
  end

  local content = table.concat(lines, "\n")
  return content:match("%[package%.metadata%.verus%]") ~= nil
    and content:match("verify%s*=%s*true") ~= nil
end

local function buffer_looks_like_verus(bufnr)
  bufnr = bufnr or 0

  local manifest = find_cargo_manifest(bufnr)
  if manifest_is_verus(manifest) then
    return true
  end

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local line_count = math.min(vim.api.nvim_buf_line_count(bufnr), 300)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_count, false)
  local head = table.concat(lines, "\n")

  return head:match("verus%s*!%s*{") ~= nil
    or head:match("vstd::") ~= nil
    or head:match("use%s+vstd::") ~= nil
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("lazy.nvim bootstrap failed:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

local treesitter_parsers = {
  "bash",
  "bibtex",
  "css",
  "html",
  "javascript",
  "json",
  "latex",
  "lua",
  "markdown",
  "markdown_inline",
  "nix",
  "python",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

require("lazy").setup({
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("dracula").setup({
        transparent_bg = false,
        italic_comment = true,
        show_end_of_buffer = false,
      })
      vim.cmd.colorscheme("dracula")
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = false,
      update_focused_file = { enable = true, update_root = false },
      view = { width = 34, side = "left" },
      renderer = {
        highlight_git = true,
        highlight_opened_files = "name",
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      filters = { custom = { "^.DS_Store$" } },
      git = { enable = true, ignore = false },
    },
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "NvimTree",
            text = "Explorer",
            text_align = "left",
            separator = true,
          },
        },
      },
    },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete buffer" },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "dracula",
        globalstatus = true,
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    },
  },

  -- nvim-treesitter main is a full rewrite for Neovim >= 0.12.
  -- Do not use the old `nvim-treesitter.configs` API here.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      if type(ts.install) ~= "function" then
        vim.schedule(function()
          vim.notify(
            "nvim-treesitter legacy checkout detected. Remove ~/.local/share/nvim/lazy/nvim-treesitter and refresh lazy-lock.json, then run :Lazy sync.",
            vim.log.levels.ERROR
          )
        end)
        return
      end

      ts.install(treesitter_parsers)

      vim.treesitter.language.register("bash", "sh")
      vim.treesitter.language.register("bibtex", "bib")
      vim.treesitter.language.register("json", "jsonc")
      vim.treesitter.language.register("latex", "tex")
      vim.treesitter.language.register("javascript", "javascriptreact")
      vim.treesitter.language.register("tsx", "typescriptreact")

      local highlight_filetypes = {
        "sh",
        "bib",
        "css",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "tex",
        "lua",
        "markdown",
        "nix",
        "python",
        "rust",
        "toml",
        "typescript",
        "typescriptreact",
        "vim",
        "yaml",
      }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
        pattern = highlight_filetypes,
        callback = function(args)
          local ok, err = pcall(vim.treesitter.start, args.buf)
          if not ok then
            vim.schedule(function()
              vim.notify("Tree-sitter could not start: " .. tostring(err), vim.log.levels.WARN)
            end)
          end
        end,
      })
    end,
  },

  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_compiler_method = "tectonic"
      vim.g.vimtex_compiler_silent = 1
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_mappings_enabled = 1
      vim.g.vimtex_imaps_enabled = 0
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer", keyword_length = 3 },
        }),
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many" },
        float = { border = "rounded", source = true },
        underline = true,
      })

      local servers = {
        rust_analyzer = {
          -- Verus syntax is not understood correctly by rust-analyzer. Skip
          -- automatic activation in Verus crates; cargo-verus handles checking.
          root_dir = function(bufnr, on_dir)
            if manifest_is_verus(find_cargo_manifest(bufnr)) then
              return
            end

            local root = vim.fs.root(bufnr, { "Cargo.toml", "rust-project.json", ".git" })
            if root then
              on_dir(root)
            end
          end,
        },

        texlab = {},

        basedpyright = {},

        -- Ruff owns linting/code actions/formatting; BasedPyright owns types and
        -- hover. Hover is disabled on Ruff in LspAttach below.
        ruff = {},

        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },

        nil_ls = {},
        ts_ls = {},
      }

      for name, config in pairs(servers) do
        config.capabilities = capabilities
        vim.lsp.config(name, config)
      end

      vim.lsp.enable(vim.tbl_keys(servers))

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          local keyopts = { buffer = args.buf }
          map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", keyopts, { desc = "Definition" }))
          map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", keyopts, { desc = "References" }))
          map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", keyopts, { desc = "Hover" }))
          map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", keyopts, { desc = "Rename" }))
          map(
            { "n", "v" },
            "<leader>ca",
            vim.lsp.buf.code_action,
            vim.tbl_extend("force", keyopts, { desc = "Code action" })
          )
        end,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
        lua = { "stylua" },
        rust = function(bufnr)
          if buffer_looks_like_verus(bufnr) then
            return { "verusfmt" }
          end
          return { "rustfmt" }
        end,
        python = { "ruff_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      formatters = {
        verusfmt = {
          command = "verusfmt",
          stdin = true,
        },
      },
      format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "tex" then
          return nil
        end
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}, {
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  ui = { border = "rounded" },
})

local latex_state = {
  dirty = {},
  started = {},
}

local latex_group = vim.api.nvim_create_augroup("TectonicLivePreview", { clear = true })

local function latex_project_key(bufnr)
  local ok, vimtex = pcall(function()
    return vim.b[bufnr].vimtex
  end)

  if ok and type(vimtex) == "table" and type(vimtex.root) == "string" and vimtex.root ~= "" then
    return vimtex.root
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename ~= "" then
    return vim.fs.dirname(filename)
  end

  return tostring(bufnr)
end

local function latex_compiler_is_running(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  local ok, running = pcall(vim.api.nvim_buf_call, bufnr, function()
    return vim.fn.eval("exists('b:vimtex.compiler') ? b:vimtex.compiler.is_running() : 0")
  end)

  return ok and tonumber(running) == 1
end

local function latex_compile_latest(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  if latex_compiler_is_running(bufnr) then
    return false
  end

  local command_exists = vim.api.nvim_buf_call(bufnr, function()
    return vim.fn.exists(":VimtexCompileSS") == 2
  end)

  if not command_exists then
    return false
  end

  local key = latex_project_key(bufnr)
  latex_state.started[key] = latex_state.dirty[key] or 0

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd("silent VimtexCompileSS")
  end)

  return true
end

local function latex_drain(bufnr, attempt)
  attempt = attempt or 0

  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  local key = latex_project_key(bufnr)
  local dirty = latex_state.dirty[key] or 0
  local started = latex_state.started[key] or 0

  if dirty <= started then
    return
  end

  if latex_compiler_is_running(bufnr) then
    -- The VimTeX success/failure callback can fire just before the backend has
    -- fully transitioned to idle. Retry briefly instead of losing the last save.
    if attempt < 40 then
      vim.defer_fn(function()
        latex_drain(bufnr, attempt + 1)
      end, 50)
    end
    return
  end

  latex_compile_latest(bufnr)
end

vim.api.nvim_create_autocmd("BufWritePost", {
  group = latex_group,
  pattern = "*.tex",
  callback = function(args)
    local key = latex_project_key(args.buf)
    latex_state.dirty[key] = (latex_state.dirty[key] or 0) + 1
    local generation = latex_state.dirty[key]

    -- Coalesce very fast write bursts while preserving the newest generation.
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      if latex_state.dirty[key] ~= generation then
        return
      end
      latex_drain(args.buf)
    end, 120)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = latex_group,
  pattern = { "VimtexEventCompileSuccess", "VimtexEventCompileFailed" },
  callback = function(args)
    local bufnr = args.buf ~= 0 and args.buf or vim.api.nvim_get_current_buf()
    vim.defer_fn(function()
      latex_drain(bufnr)
    end, 30)
  end,
})

local verus_state = {
  jobs = {},
  sequence = {},
  save_generation = {},
  output = {},
}

local function run_verus(mode, bufnr, notify_success)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local manifest = find_cargo_manifest(bufnr)
  if not manifest_is_verus(manifest) then
    vim.notify(
      "No Cargo.toml with [package.metadata.verus] and verify = true found",
      vim.log.levels.WARN
    )
    return
  end

  local root = vim.fs.dirname(manifest)
  verus_state.sequence[manifest] = (verus_state.sequence[manifest] or 0) + 1
  local sequence = verus_state.sequence[manifest]

  local previous = verus_state.jobs[manifest]
  if previous then
    pcall(function()
      previous:kill(15)
    end)
  end

  local command = {
    "cargo",
    "verus",
    mode,
    "--manifest-path",
    manifest,
  }

  verus_state.jobs[manifest] = vim.system(command, {
    cwd = root,
    text = true,
  }, function(result)
    vim.schedule(function()
      -- Ignore completion from a job superseded by a newer save.
      if verus_state.sequence[manifest] ~= sequence then
        return
      end

      verus_state.jobs[manifest] = nil

      local stdout = result.stdout or ""
      local stderr = result.stderr or ""
      local output = stdout
      if stderr ~= "" then
        output = output .. (output ~= "" and "\n" or "") .. stderr
      end
      verus_state.output[manifest] = output

      if result.code == 0 then
        if notify_success then
          vim.notify("Verus " .. mode .. ": verified", vim.log.levels.INFO)
        end
      else
        vim.notify(
          "Verus " .. mode .. " failed (exit " .. result.code .. "). Use :VerusOutput.",
          vim.log.levels.ERROR
        )
      end
    end)
  end)
end

local function show_verus_output(bufnr)
  local manifest = find_cargo_manifest(bufnr or 0)
  if not manifest then
    vim.notify("No Cargo.toml found", vim.log.levels.WARN)
    return
  end

  local output = verus_state.output[manifest]
  if not output or output == "" then
    vim.notify("No Verus output recorded for this project yet", vim.log.levels.INFO)
    return
  end

  local buffer = vim.api.nvim_create_buf(false, true)
  vim.bo[buffer].bufhidden = "wipe"
  vim.bo[buffer].buftype = "nofile"
  vim.bo[buffer].swapfile = false
  vim.bo[buffer].filetype = "rust"
  vim.api.nvim_buf_set_name(buffer, "Verus Output")
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, vim.split(output, "\n", { plain = true }))

  vim.cmd("botright 14split")
  vim.api.nvim_win_set_buf(0, buffer)
end

vim.api.nvim_create_user_command("VerusFocus", function()
  run_verus("focus", vim.api.nvim_get_current_buf(), true)
end, {})

vim.api.nvim_create_user_command("VerusVerify", function()
  run_verus("verify", vim.api.nvim_get_current_buf(), true)
end, {})

vim.api.nvim_create_user_command("VerusOutput", function()
  show_verus_output(vim.api.nvim_get_current_buf())
end, {})

map("n", "<leader>vf", "<cmd>VerusFocus<cr>", { desc = "Verus focus" })
map("n", "<leader>vv", "<cmd>VerusVerify<cr>", { desc = "Verus verify" })
map("n", "<leader>vo", "<cmd>VerusOutput<cr>", { desc = "Verus output" })

local verus_group = vim.api.nvim_create_augroup("VerusVerifyOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = verus_group,
  pattern = "*.rs",
  callback = function(args)
    local manifest = find_cargo_manifest(args.buf)
    if not manifest_is_verus(manifest) then
      return
    end

    verus_state.save_generation[manifest] = (verus_state.save_generation[manifest] or 0) + 1
    local generation = verus_state.save_generation[manifest]

    -- `focus` is the fast editing loop; run :VerusVerify before committing.
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then
        return
      end
      if verus_state.save_generation[manifest] ~= generation then
        return
      end
      run_verus("focus", args.buf, false)
    end, 180)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    if data.file ~= "" and vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(vim.fn.fnameescape(data.file))
      require("nvim-tree.api").tree.open()
    end
  end,
})
