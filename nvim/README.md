# nvim-config
### nvim config tree
~/.dotfiles/nvim<br>

after<br>
├─ plugin<br>
└──── hello.lua<br>
lua<br>
├─ qwox<br>
├──── init.lua<br>
└──── set.lua<br>
init.lua<br>
install.sh<br>
README.md<br>

1. init.lua<br>
base neovim config file (executed first)

2. after<br>
contains vim config files which are included after init.lua

3. lua<br>
contains lua modules<br>
3.1. include module with:<br>
require("\<modulename\>")<br>
(require("qwox") searches for lua/qwox.lua or lua/qwox/init.lua)<br><br>
3.2. include submodules (eg. sets.lua) can be included with:<br>
require("\<modulename\>.\<submodulename\>")<br>
(require("qwox.sets") includes lua/qwox/set.lua)

4. install.sh
install script to create links in ~/.config/nvim

5. README.md
this
