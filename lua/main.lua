local cmd = vim.api.nvim_command;  
local fn = vim.fn;    
local g = vim.g;      
local opt = vim.opt;  
local cmp = require'cmp'
local lsp = require'lspconfig'
require('nvim-autopairs').setup{}
require'path' -- All paths
require'keyboard_detector' 
require'template'
-----------Functions---------
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
function ToggleVExplorer()
    g.netrw_chgwin = fn.winnr() + 1
    g.netrw_winsize = 40;
    cmd [[ Lexplore ]];
end
map_leader()
----------Globals----------------
g.netrw_keepdir = 1;
g.netrw_banner = 0;
g.netrw_liststyle = 3;
g.netrw_localcopydircmd = 'cp -r';
g.rainbow_active = 1;
-------------Plugin Managing----------
require'plugin_manager'
cmd [[ command -nargs=1 PluginInstall lua PluginInstall(<f-args>)]]
cmd [[ command PluginUpdate lua PluginUpdate() ]]
cmd [[ command PluginList lua PluginList() ]]
cmd [[ command -nargs=1 PluginDelete lua PluginDelete(<f-args>) ]]
---------Mappings--------------------
map('', '<leader>t', ':tabe<CR>');
map('', '<leader>s', ':vsplit<CR>');
map('', '<leader>n', ':lua ToggleVExplorer()<CR>');
map('n', '<tab>', '<C-W>w', {noremap=true});
----------Vim Commands----------------
cmd [[ set path+=** ]]
cmd [[ filetype plugin indent on ]]
cmd [[ hi! link netrwMarkFile Search ]]
cmd [[ set guitablabel=%N/\ %t\ %M ]]
cmd [[ command Temp lua template() ]]
-----------AutoCompletion---------------
cmp.setup({
    snippet = {
      expand = function(args)
	fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = {
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, { "i", "s" }),

        ["<C-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
----------Language server protocol setup--------------
lsp.clangd.setup{};
lsp.tsserver.setup{};
lsp.jsonls.setup {};
lsp.html.setup{};
lsp.cssls.setup{};
-----------Options--------------
opt.viminfo = '';
opt.shiftwidth = 4;
opt.scrolloff = 1;
opt.tabstop = 4;
opt.sidescrolloff = 5;
opt.number = true;
opt.title = true;
opt.expandtab = true;
opt.errorbells = false;
opt.smartcase = true;
opt.wrap = true;
opt.showmatch = true;
opt.ignorecase = true;
opt.linebreak = true;
opt.cursorline = true;
opt.swapfile = false;
opt.autochdir = true;
opt.backup = false;
opt.wb = false;
opt.shiftround = true;
opt.termguicolors = true;
opt.completeopt = {'menuone','noinsert', 'noselect'};
opt.backspace = {'indent', 'eol', 'start'};
opt.clipboard = {'unnamed'};
