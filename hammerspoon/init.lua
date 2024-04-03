-- The workaround to automatically switch input method is shipped from
-- https://gist.github.com/ibreathebsb/65fae9d742c5ebdb409960bceaf934de
-- I also add my own modifications.

-- Available input method names
local imeName = {
  -- 搜狗拼音输入法
  ChineseDefault = "com.sogou.inputmethod.sogou.pinyin",
  -- English US
  EnglishDefault = "com.apple.keylayout.US",

  default = "com.apple.keylayout.US",
}

-- FIXME: Why not just use the App name as the identifier?
local app2Ime = {
  -- Develop
  { '/Applications/iTerm.app', imeName.EnglishDefault },
  { '/Applications/kitty.app', imeName.EnglishDefault },
  { '/Applications/Visual Studio Code.app', imeName.EnglishDefault },
  -- { '/opt/homebrew/Cellar/emacs-plus@29/29.3/Emacs.app', imeName.EnglishDefault },
  { '/Applications/Xcode.app', imeName.EnglishDefault },
  { '/Applications/Logseq.app', imeName.EnglishDefault },
  { '/Applications/UTM.app', imeName.EnglishDefault },

  -- Browser
  { '/Applications/Google Chrome.app', imeName.EnglishDefault },
  { '/Applications/Arc.app', imeName.EnglishDefault },
  { '/Applications/Firefox.app', imeName.EnglishDefault },

  { '/Applications/WeChat.app', imeName.ChineseDefault },
  { '/System/Applications/Messages.app', imeName.ChineseDefault },
  { '/Applications/QQ.app', imeName.ChineseDefault },
}

local app2ImePersist = {
  ['/opt/homebrew/Cellar/emacs-plus@29/29.3/Emacs.app'] = imeName.EnglishDefault,
}

-- Auxiliary for showing the APP information with key binding `ctrl-cmd-.'
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
  hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

-- Must not be `local`, or the watcher might be deleted during garbage collection.
-- See https://github.com/Hammerspoon/hammerspoon/issues/681#issuecomment-212286907.
imeWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
  if eventType == hs.application.watcher.activated
    or eventType == hs.application.watcher.launched then

    local focusAppPath = hs.window.frontmostWindow():application():path()

    -- If the APP's IME is persisted
    if app2ImePersist[focusAppPath] then
      hs.keycodes.currentSourceID(app2ImePersist[focusAppPath])
      return
    end

    local ime = nil
    -- Search the APP in the list
    for _, app in pairs(app2Ime) do
      local appPath = app[1]
      local expectedIme = app[2]

      if focusAppPath == appPath then
        hs.keycodes.currentSourceID(expectedIme)
        return
      end
    end

  end

  -- TODO: currently I don't know how to persist the IME of an APP.
  -- That's because the event `deactivate` happens **after** `activate`, which is weird.
  -- if eventType == hs.application.watcher.deactivated then
  --   print(appName)
  --   print(hs.keycodes.currentSourceID())
  -- end
end)
imeWatcher:start()

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Key bindings

-- ctrl + alt - n: open a new window of iTerm2
hs.hotkey.bind({"ctrl", "alt"}, "N", function()
  hs.applescript('tell application "iTerm2" to create window with default profile')
end)
