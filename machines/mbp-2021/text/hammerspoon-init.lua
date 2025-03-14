-- The workaround to automatically switch input method is shipped from
-- https://gist.github.com/ibreathebsb/65fae9d742c5ebdb409960bceaf934de
-- I also add my own modifications.

-- Available input method names
local imeName = {
  -- 搜狗拼音输入法
  ChineseDefault = "com.sogou.inputmethod.sogou.pinyin",
  -- English US
  EnglishDefault = "com.apple.keylayout.UnicodeHexInput",

  default = "com.apple.keylayout.UnicodeHexInput",
}

local app2Ime = {
  -- Develop
  { 'iTerm2', imeName.EnglishDefault },
  { 'kitty', imeName.EnglishDefault },
  { 'Code', imeName.EnglishDefault },
  { 'Emacs', imeName.EnglishDefault },
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
  { 'WPS Office', imeName.ChineseDefault },
  { 'Telegram', imeName.ChineseDefault },
}

local app2ImePersist = {
  -- ['Emacs'] = imeName.EnglishDefault,
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

end)
imeWatcher:start()

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

-- Key bindings

hs.hotkey.bind({"cmd", "alt"}, "E", function()
  -- with_user_env: if true, executes the command in the users login shell.
  local output = hs.execute("emacsclient -e '(emacs-everywhere)'", true)
  print("Emacs everywhere: " .. output)
end)
