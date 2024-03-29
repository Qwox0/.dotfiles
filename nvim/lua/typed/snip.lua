---DATA                                                   *luasnip-snippets-data*
---
---Snippets contain some interesting tables during runtime.
---
---These variables/tables primarily come in handy in `dynamic/functionNodes`,
---where the snippet can be accessed through the immediate parent
---(`parent.snippet`), which is passed to the function. (in most cases `parent ==
---parent.snippet`, but the `parent` of the dynamicNode is not always the
---surrounding snippet, it could be a `snippetNode`).
---@class Snippet
---@field env unknown Contains variables used in the LSP-protocol for example `TM_CURRENT_LINE` or `TM_FILENAME`. It’s possible to add customized variables here too, check |luasnip-variables-environment-namespaces|
---@field captures unknown If the snippet was triggered by a pattern (`regTrig`) and the pattern contained capture-groups, they can be retrieved here.
---@field trigger unknown The string that triggered this snippet. Again only interesting if the snippet was triggered through `regTrig`, for getting the full match.
---@field invalidate fun(): nil call this method to effectively remove the snippet. The snippet will no longer be able to expand via `expand` or `expand_auto`. It will also be hidden from lists (at least if the plugin creating the list respects the `hidden`-key), but it might be necessary to call `ls.refresh_notify(ft)` after invalidating snippets.
---@field get_keyed_node fun(key): Node Returns the currently visible node associated with `key`.

---@class SContext
---@field trig string the trigger of the snippet. If the text in front of (to the left of) the cursor when `ls.expand()` is called matches it, the snippet will be expanded. By default, "matches" means the text in front of the cursor matches the trigger exactly, this behaviour can be modified through `trigEngine`
---@field name string can be used by e.g. `nvim-compe` to identify the snippet.
---@field desc string description of the snippet, -separated or table for multiple lines.
---@field dscr string alias for `desc`.
---@field wordTrig boolean if true, the snippet is only expanded if the word (`[%w_]+`) before the cursor matches the trigger entirely. True by default.
---@field regTrig boolean whether the trigger should be interpreted as a lua pattern. False by default. Consider setting `trigEngine` to `"pattern"` instead, it is more expressive, and in line with other settings.
---@field trigEngine string|fun(trigger): fun(line_to_cursor, trigger): whole_match, captures determines how `trig` is interpreted, and what it means for it to "match" the text in front of the cursor. This behaviour can be completely customized by passing a function, but the predefined ones, which are accessible by passing their identifier, should suffice in most cases:
---* `"plain"`: the default-behaviour, the trigger has to match the text before the cursor exactly.
---        * `"pattern"`: the trigger is interpreted as a lua-pattern, and is a match if `trig .. "$"` matches the line up to the cursor. Capture-groups will be accessible as `snippet.captures`.
---        * `"ecma"`: the trigger is interpreted as an ECMAscript-regex, and is a match if `trig .. "$"` matches the line up to the cursor. Capture-groups will be accessible as `snippet.captures`. This `trigEngine` requires `jsregexp` (see |luasnip-lsp-snippets-transformations|) to be installed, if it is not, this engine will behave like `"plain"`.
---        * `"vim"`: the trigger is interpreted as a vim-regex, and is a match if `trig .. "$"` matches the line up to the cursor. As with the other regex/pattern-engines, captures will be available as `snippet.captures`, but there is one caveat: the matching is done using `matchlist`, so for now empty-string submatches will be interpreted as unmatched, and the corresponding `snippet.capture[i]` will be `nil` (this will most likely change, don’t rely on this behavior).
---        Besides these predefined engines, it is also possible to create new ones:
---        Instead of a string, pass a function which satisfies `trigEngine(trigger) ->
---        (matcher(line_to_cursor, trigger) -> whole_match, captures)` (ie. the function
---        receives `trig`, can, for example, precompile a regex, and then returns a
---        function responsible for determining whether the current cursor-position
---        (represented by the line up to the cursor) matches the trigger (it is passed
---        again here so engines which don’t do any trigger-specific work (like
---        compilation) can just return a static `matcher`), and what the capture-groups
---        are). The `lua`-engine, for example, can be (and is!) implemented like this:
---        ```lua
---            local function matcher(line_to_cursor, trigger)
---                *- look for match which ends at the cursor.
---                *- put all results into a list, there might be many capture-groups.
---                local find_res = { line_to_cursor:find(trigger .. "$") }
---
---                if #find_res > 0 then
---                    *- if there is a match, determine matching string, and the
---                    *- capture-groups.
---                    local captures = {}
---                    *- find_res[1] is `from`, find_res[2] is `to` (which we already know
---                    *- anyway).
---                    local from = find_res[1]
---                    local match = line_to_cursor:sub(from, #line_to_cursor)
---                    *- collect capture-groups.
---                    for i = 3, #find_res do
---                        captures[i - 2] = find_res[i]
---                    end
---                    return match, captures
---                else
---                    return nil
---                end
---            end
---
---            local function engine(trigger)
---                *- don't do any special work here, can't precompile lua-pattern.
---                return matcher
---            end
---        ```
---        The predefined engines are defined in `trig_engines.lua`
---        <https://github.com/L3MON4D3/LuaSnip/blob/master/lua/luasnip/nodes/util/trig_engines.lua>,
---        read it for more examples.
---@field docstring string textual representation of the snippet, specified like `desc`. Overrides docstrings loaded from json.
---@field docTrig string used as `line_to_cursor` during docstring-generation. This might be relevant if the snippet relies on specific values in the capture-groups (for example, numbers, which won’t work with the default `$CAPTURESN` used during docstring-generation)
---@field hidden boolean hint for completion-engines. If set, the snippet should not show up when querying snippets.
---@field priority integer Priority of the snippet, 1000 by default. Snippets with high priority will be matched to a trigger before those with a lower one. The priority for multiple snippets can also be set in `add_snippets`.
---@field snippetType string should be either `snippet` or `autosnippet` (ATTENTION: singular form is used), decides whether this snippet has to be triggered by `ls.expand()` or whether is triggered automatically (don’t forget to set `ls.config.setup({ enable_autosnippets = true })` if you want to use this feature). If unset it depends on how the snippet is added of which type the snippet will be.
---@field resolveExpandParams fun(snippet, line_to_cursor, matched_trigger, captures): table|nil where
---        * `snippet`: `Snippet`, the expanding snippet object
---        * `line_to_cursor`: `string`, the line up to the cursor.
---        * `matched_trigger`: `string`, the fully matched trigger (can be retrieved
---            from `line_to_cursor`, but we already have that info here :D)
---        * `captures`: `captures` as returned by `trigEngine`.
---        This function will be evaluated in `Snippet:matches()` to decide whether the
---        snippet can be expanded or not. Returns a table if the snippet can be expanded,
---        `nil` if can not. The returned table can contain any of these fields:
---        * `trigger`: `string`, the fully matched trigger.
---        * `captures`: `table`, this list could update the capture-groups from
---            parameter in snippet expansion.
---            Both `trigger` and `captures` can override the values returned via
---            `trigEngine`.
---        * `clear_region`: `{ "from": {<row>, <column>}, "to": {<row>, <column>} }`,
---            both (0, 0)-indexed, the region where text has to be cleared before
---            inserting the snippet.
---        * `env_override`: `map string->(string[]|string)`, override or extend
---            the snippet’s environment (`snip.env`)
---        If any of these is `nil`, the default is used (`trigger` and `captures` as
---        returned by `trigEngine`, `clear_region` such that exactly the trigger is
---        deleted, no overridden environment-variables).
---        A good example for the usage of `resolveExpandParams` can be found in the
---        implementation of `postfix`
---        <https://github.com/L3MON4D3/LuaSnip/blob/master/lua/luasnip/extras/postfix.lua>.
---@field condition fun(line_to_cursor, matched_trigger, captures): boolean where
---        * `line_to_cursor`: `string`, the line up to the cursor.
---        * `matched_trigger`: `string`, the fully matched trigger (can be retrieved
---            from `line_to_cursor`, but we already have that info here :D)
---        * `captures`: if the trigger is pattern, this list contains the
---            capture-groups. Again, could be computed from `line_to_cursor`, but we
---            already did so.
---@field show_condition fun(line_to_cursor): boolean
---        * `line_to_cursor`: `string`, the line up to the cursor.
---        This function is (should be) evaluated by completion engines, indicating
---        whether the snippet should be included in current completion candidates.
---        Defaults to a function returning `true`. This is different from `condition`
---        because `condition` is evaluated by LuaSnip on snippet expansion (and thus has
---        access to the matched trigger and captures), while `show_condition` is (should
---        be) evaluated by the completion engines when scanning for available snippet
---        candidates.
---@field filetype string the filetype of the snippet. This overrides the filetype the snippet is added (via `add_snippet`) as.




---    * `callbacks`: Contains functions that are called upon entering/leaving a node of
---        this snippet. For example: to print text upon entering the _second_ node of a
---        snippet, `callbacks` should be set as follows:
---        ```lua
---            {
---                *- position of the node, not the jump-index!!
---                *- s("trig", {t"first node", t"second node", i(1, "third node")}).
---                [2] = {
---                    [events.enter] = function(node, _event_args) print("2!") end
---                }
---            }
---        ```
---        To register a callback for the snippets’ own events, the key `[-1]` may be
---        used. More info on events in |luasnip-events|
---    * `child_ext_opts`, `merge_child_ext_opts`: Control `ext_opts` applied to the
---        children of this snippet. More info on those in the |luasnip-ext_opts|-section.
---
---The `opts`-table, as described here, can also be passed to e.g. `snippetNode`
---and `indentSnippetNode`. It is also possible to set `condition` and
---`show_condition` (described in the documentation of the `context`-table) from
---`opts`. They should, however, not be set from both.
---@class SOpts

---The most direct way to define snippets is `s`:
---
---```lua
---s({trig="trigger"}, {})
---```
---
---(This snippet is useless beyond serving as a minimal example)
---
---@param context string|SContext Passing a string is equivalent to passing
---    ```lua
---        {
---            trig = context
---        }
---    ```
---@param nodes Node|Node[] A single node or a list of nodes. The nodes that make up the snippet.
---@param opts SOpts?
---@return Snippet
---@diagnostic disable-next-line
function s(context, nodes, opts)
    return require("luasnip").s(context, nodes, opts)
end

---@class Node

---@class NodeRef

---todo
---@class NodeOpts?

---Creates a TextNode. The most simple kind of node; just text.
---
---```lua
---    s("trigger", { t("Wow! Text!") })
---```
---
---This snippet expands to
---
---```
---        Wow! Text!⎵
---```
---
---where ⎵ is the cursor.
---
---Multiline strings can be defined by passing a table of lines rather than a
---string:
---
---```lua
---    s("trigger", {
---        t({"Wow! Text!", "And another line."})
---    })
---```
---
---@param text string|string[]
---@param node_opts NodeOpts?
---@return Node
function t(text, node_opts)
    return require("luasnip").t(text, node_opts)
end

---Creates an InsertNode. These Nodes contain editable text and can be jumped to- and from (e.g.
---traditional placeholders and tabstops, like `$1` in textmate-snippets).
---
---The functionality is best demonstrated with an example:
---
---```lua
---    s("trigger", {
---        t({"After expanding, the cursor is here ->"}), i(1),
---        t({"", "After jumping forward once, cursor is here ->"}), i(2),
---        t({"", "After jumping once more, the snippet is exited there ->"}), i(0),
---    })
---```
---
---The Insert Nodes are visited in order `1,2,3,..,n,0`. (The jump-index 0 also
---_has_ to belong to an `insertNode`!) So the order of InsertNode-jumps is as
---follows:
---
---1. After expansion, the cursor is at InsertNode 1,
---2. after jumping forward once at InsertNode 2,
---3. and after jumping forward again at InsertNode 0.
---
---If no 0-th InsertNode is found in a snippet, one is automatically inserted
---after all other nodes.
---
---The jump-order doesn’t have to follow the "textual" order of the nodes:
---
---```lua
---    s("trigger", {
---        t({"After jumping forward once, cursor is here ->"}), i(2),
---        t({"", "After expanding, the cursor is here ->"}), i(1),
---        t({"", "After jumping once more, the snippet is exited there ->"}), i(0),
---    })
---```
---
---The above snippet will behave as follows:
---
---1. After expansion, we will be at InsertNode 1.
---2. After jumping forward, we will be at InsertNode 2.
---3. After jumping forward again, we will be at InsertNode 0.
---
---An **important** (because here Luasnip differs from other snippet engines)
---detail is that the jump-indices restart at 1 in nested snippets:
---
---```lua
---    s("trigger", {
---        i(1, "First jump"),
---        t(" :: "),
---        sn(2, {
---            i(1, "Second jump"),
---            t" : ",
---            i(2, "Third jump")
---        })
---    })
---```
---
---as opposed to e.g. the textmate syntax, where tabstops are snippet-global:
---
---```snippet
---    ${1:First jump} :: ${2: ${3:Third jump} : ${4:Fourth jump}}
---```
---
---(this is not exactly the same snippet of course, but as close as possible) (the
---restart-rule only applies when defining snippets in lua, the above
---textmate-snippet will expand correctly when parsed).
---
---
---If the `jump_index` is `0`, replacing its’ `text` will leave it outside the
---`insertNode` (for reasons, check out Luasnip#110).
---
---@param jump_index number this determines when this node will be jumped to (see |luasnip-basics-jump-index|).
---@param text string|string[]? a single string for just one line, a list with >1 entries for multiple lines. This text will be SELECTed when the `insertNode` is jumped into.
---@param node_opts NodeOpts? todo: more see |luasnip-choisenode|
---@return Node
---@diagnostic disable-next-line
function i(jump_index, text, node_opts)
    return require("luasnip").i(jump_index, text, node_opts)
end

---Creates a FunctionNode.
---@param fn fun(argnode_text: string[][], parent, ...): string
---@param argnode_reference NodeRef[]|NodeRef|nil
---@param node_opts NodeOpts?
---@return Node
---@diagnostic disable-next-line
function f(fn, argnode_reference, node_opts)
    return require("luasnip").f(fn, argnode_reference, node_opts)
end

---Creates a ChoiceNode.
---@param jump_index number, since choiceNodes can be jumped to, they need a jump-index (Info in |luasnip-basics-jump-index|).
---@param choices Node[]|Node, the choices. The first will be initialliy active. A list of nodes will be turned into a `snippetNode`.
---@param node_opts NodeOpts?
---@return Node
---@diagnostic disable-next-line
function c(jump_index, choices, node_opts)
    return require("luasnip").c(jump_index, choices, node_opts)
end

---Creates a SnippetNode.
---@param jump_index number, the usual |luasnip-jump-index|.
---@param nodes Node[]|Node, just like for `s`. Note that `snippetNode`s don’t accept an `i(0)`, so the jump-indices of the nodes inside them have to be in `1,2,...,n`.
---@param node_opts NodeOpts? - `node_opts`: `table`: again, the keys common to all nodes (documented in |luasnip-node|) are supported, but also `callbacks`, `child_ext_opts` and `merge_child_ext_opts`, which are further explained in |luasnip-snippets|.
---@return Node
---@diagnostic disable-next-line
function sn(jump_index, nodes, node_opts)
    return require("luasnip").sn(jump_index, nodes, node_opts)
end

---Creates an IndentSnippetNode.
---@param jump_index number, the usual |luasnip-jump-index|.
---@param nodes Node[]|Node, just like for `s`. Note that `snippetNode`s don’t accept an `i(0)`, so the jump-indices of the nodes inside them have to be in `1,2,...,n`.
---@param indentstring string, will be used to indent the nodes inside this `snippetNode`. All occurences of `"$PARENT_INDENT"` are replaced with the actual indent of the parent.
---@param node_opts NodeOpts?
---@return Node
---@diagnostic disable-next-line
function isn(jump_index, nodes, indentstring, node_opts)
    return require("luasnip").isn(jump_index, nodes, indentstring, node_opts)
end

---Creates a DynamicNode.
---comment
---@param jump_index number, just like all jumpable nodes, its’ position in the jump-list (|luasnip-basics-jump-index|).
---@param fn fun(args: table<string>, parent: Node, old_state, user_args): Node This function is called when the argnodes’ text changes. It should generate and return (wrapped inside a `snippetNode`) nodes, which will be inserted at the dynamicNode’s place. `args`, `parent` and `user_args` are also explained in |luasnip-functionnode|
---@param node_references NodeRef[]|NodeRef|nil, |luasnip-node-references| to the nodes the dynamicNode depends on: if any of these trigger an update (for example, if the text inside them changes), the `dynamicNode`s’ function will be executed, and the result inserted at the `dynamicNode`s place. (`dynamicNode` behaves exactly the same as `functionNode` in this regard).
---@param node_opts NodeOpts? In addition to the common |luasnip-node|-keys, there is, again, - `user_args`, which is described in |luasnip-functionnode|.
---@return Node
---@diagnostic disable-next-line
function d(jump_index, fn, node_references, node_opts)
    return require("luasnip").d(jump_index, fn, node_references, node_opts)
end

---Creates a RestoreNode.
---@param jump_index number when to jump to this node.
---@param key string `restoreNode`s with the same key share their content.
---@param nodes Node[]|Node: the content of the `restoreNode`. Can either be a single node, or a table of nodes (both of which will be wrapped inside a `snippetNode`, except if the single node already is a `snippetNode`). The content for a given key may be defined multiple times, but if the contents differ, it’s undefined which will actually be used. If a key’s content is defined in a `dynamicNode`, it will not be initially used for `restoreNodes` outside that `dynamicNode`. A way around this limitation is defining the content in the `restoreNode` outside the `dynamicNode`.
---@param node_opts NodeOpts?
---@return Node
---@diagnostic disable-next-line
function r(jump_index, key, nodes, node_opts)
    return require("luasnip").r(jump_index, key, nodes, node_opts)
end

---Creates a MultiSnippet.
---@param context table<SContext[]>
---@param nodes Node[]|Node exactly like in |luasnip-snippets|.
---@param node_opts NodeOpts?
---@diagnostic disable-next-line
function ms(context, nodes, node_opts)
    return require("luasnip").ms(context, nodes, node_opts)
end

---Creates a Lambda. A shortcut for `functionNode`s that only do very basic string manipulation.
---@param lambda any An object created by applying string-operations to `l._n`, objects representing the `n`th argnode. Example 1: `l._1:gsub("a", "e")` replaces all occurences of "a" in the text of the first argnode with "e". Example 2: `l._1 .. l._2` concatenates text of the first and second argnode. If an argnode contains multiple lines of text, they are concatenated with `"\n"` prior to any operation.
---@param argnode_reference NodeRef[]|NodeRef|nil
---@return Node
---@diagnostic disable-next-line
function l(lambda, argnode_reference)
    return require("luasnip").l(lambda, argnode_reference)
end
