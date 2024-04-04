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

local app2Ime = {
  -- Develop
  { 'iTerm', imeName.EnglishDefault },
  { 'kitty', imeName.EnglishDefault },
  { 'Visual Studio Code', imeName.EnglishDefault },
  -- { '/opt/homebrew/Cellar/emacs-plus@29/29.3/Emacs', imeName.EnglishDefault },
  { 'Xcode', imeName.EnglishDefault },
  { 'Logseq', imeName.EnglishDefault },
  { 'UTM', imeName.EnglishDefault },

  -- Browser
  { 'Google Chrome', imeName.EnglishDefault },
  { 'Arc', imeName.EnglishDefault },
  { 'Firefox', imeName.EnglishDefault },

  { 'WeChat', imeName.ChineseDefault },
  { 'Messages', imeName.ChineseDefault },
  { 'QQ', imeName.ChineseDefault },
}

local app2ImePersist = {
  ['Emacs'] = imeName.EnglishDefault,
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

    -- If the APP's IME is persisted
    if app2ImePersist[appName] then
      hs.keycodes.currentSourceID(app2ImePersist[appName])
      return
    end

    -- Search the APP in the list
    for _, app in pairs(app2Ime) do

      if appName == app[1] then
        hs.keycodes.currentSourceID(app[2])
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
