--[[----------------------------------------------------------------------------

  LiteMount/Localization.lua

  LiteMount translations into other languages.

  Copyright 2011-2017 Mike Battersby

----------------------------------------------------------------------------]]--

-- Vim reformatter from curseforge "Global Strings" export.
-- %s/^\(L\..*\) = \(.*\)/\=printf('%-24s= %s', submatch(1), submatch(2))/

LM_Localize = setmetatable({ }, {__index=function (t,k) return k end})

local L = LM_Localize

local locale = GetLocale()

-- Automatic / Blizzard --------------------------------------------------------

L.CUSTOM1               = CUSTOM .. " 1"
L.CUSTOM2               = CUSTOM .. " 2"
L.NAGRAND               = GetMapNameByID(477)
L.VASHJIR               = GetMapNameByID(613)

-- enUS / enGB / Default -------------------------------------------------------

L.AQ                    = "AQ"
L.C1                    = "C1"
L.C2                    = "C2"
L.FLOAT                 = "Float"
L.FLY                   = "Fly"
L.LM_AUTHOR             = "Author"
L.LM_COMBAT_MACRO_EXP   = "If enabled, this macro will be run instead of the default combat actions if LiteMount is activated while you are combat."
L.LM_COPY_TARGETS_MOUNT = "Try to copy target's mount."
L.LM_CURRENT_SETTINGS   = "Current Settings"
L.LM_DEFAULT_SETTINGS   = "Default Settings"
L.LM_DELETE_PROFILE     = "Delete Profile"
L.LM_DISABLE_NEW_MOUNTS = "Automatically disable newly added mounts."
L.LM_DISABLING_MOUNT    = "Disabling active mount: %s"
L.LM_ENABLING_MOUNT     = "Enabling active mount: %s"
L.LM_FLAGS              = "Flags"
L.LM_HELP_TRANSLATE     = "Help translate LiteMount into your language. Thank you."
L.LM_MACRO_EXP          = "This macro will be run if LiteMount is unable to find a usable mount. This might be because you are indoors, or are moving and don't know any instant-cast mounts."
L.LM_NEW_PROFILE        = "New Profile"
L.LM_NO_USABLE_MOUNTS   = "You don't know any mounts you can use right now."
L.LM_NON_FLYING_MOUNT   = "Non-flying Mount"
L.LM_PROFILES           = "Profiles"
L.LM_RESET_PROFILE      = "Reset Profile"
L.LM_SETTINGS_TAGLINE   = "Simple and reliable random mount summoning."
L.LM_TRANSLATORS        = "Translators"
L.RUN                   = "Run"
L.SWIM                  = "Swim"
L.VASH                  = "Vash"
L.WALK                  = "Walk"

-- deDE ------------------------------------------------------------------------

if locale == "deDE" then
L.AQ                    = "AQ"
L.C1                    = "B1"
L.C2                    = "B2"
L.FLOAT                 = "Wasserwandeln"
L.FLY                   = "Fliegen"
L.LM_AUTHOR             = "Autor"
L.LM_COMBAT_MACRO_EXP   = "Bei Aktivierung wird dieses Makro anstelle von normalen Kampfhandlungen benutzt, wenn LiteMount im Kampf verwendet wird."
L.LM_COPY_TARGETS_MOUNT = "Versuche, das Reittier deines Ziels zu kopieren."
L.LM_CURRENT_SETTINGS   = "Aktuelle Einstellungen"
L.LM_DEFAULT_SETTINGS   = "Standardeinstellungen"
L.LM_DELETE_PROFILE     = "Lösche Profil"
L.LM_DISABLE_NEW_MOUNTS = "Deaktiviere automatisch neu gelernte Reittiere"
L.LM_DISABLING_MOUNT    = "Deaktiviere aktuelles Reittier: %s"
L.LM_ENABLING_MOUNT     = "Aktiviere aktuelles Reittier: %s"
L.LM_FLAGS              = "Markierungen"
L.LM_HELP_TRANSLATE     = "Hilf dabei, LiteMount in deine Sprache zu übersetzen. Danke."
L.LM_MACRO_EXP          = "Dieses Makro wird ausgeführt, wenn LiteMount kein nutzbares Reittier findet. Dies kann passieren, wenn du dich in Gebäuden aufhältst oder läufst und keine spontan wirkbaren Reittiere hast."
L.LM_NEW_PROFILE        = "Neues Profil"
L.LM_NO_USABLE_MOUNTS   = "Du kennst keine Reittiere, die du derzeit verwenden kannst."
L.LM_NON_FLYING_MOUNT   = "Nicht-Flugreittier"
L.LM_PROFILES           = "Profile"
L.LM_RESET_PROFILE      = "Profil zurücksetzen"
L.LM_SETTINGS_TAGLINE   = "Einfaches und zuverlässiges Beschwören von zufälligen Reittieren."
L.LM_TRANSLATORS        = "Übersetzer"
L.RUN                   = "Rennen"
L.SWIM                  = "Schwimmen"
L.VASH                  = "Vash"
L.WALK                  = "Laufen"
end

-- esES / esMX -----------------------------------------------------------------

if locale == "esES" or locale == "esMX" then
L.FLY                   = "Volar"
L.LM_AUTHOR             = "Auto"
L.LM_DELETE_PROFILE     = "Borrar un Perfil"
L.LM_NEW_PROFILE        = "Crear perfil"
L.LM_PROFILES           = "Perfiles"
L.LM_RESET_PROFILE      = "Reiniciar Perfil"
L.RUN                   = "Correr"
L.SWIM                  = "Nadar"
end

-- frFR ------------------------------------------------------------------------

if locale == "frFR" then
L.AQ                    = "AQ"
L.C1                    = "C1"
L.C2                    = "C2"
L.FLOAT                 = "Flotte"
L.FLY                   = "Vol"
L.LM_AUTHOR             = "Auteur"
L.LM_COMBAT_MACRO_EXP   = "Si coché, cette macro sera lancée à la place de l'action de combat par défaut si LiteMount est activé lorsque vous êtes en combat."
L.LM_COPY_TARGETS_MOUNT = "Essai de copier la monture de la cible."
L.LM_CURRENT_SETTINGS   = "Réglages actuels"
L.LM_DEFAULT_SETTINGS   = "Réglages par défaut"
L.LM_DELETE_PROFILE     = "Effacer le profil"
L.LM_MACRO_EXP          = "Cette macro sera jouée si LiteMount ne trouve pas de monture utilisable. Cela peut être si vous êtes en intérieur, ou si vous bougez et n'avez pas de monture instantanée."
L.LM_NEW_PROFILE        = "Créer un profil"
L.LM_NON_FLYING_MOUNT   = "Monture non-volante"
L.LM_PROFILES           = "Profils"
L.LM_RESET_PROFILE      = "Réinitialiser le profil"
L.LM_SETTINGS_TAGLINE   = "Invocateur simple et fiable de monture aléatoire."
L.LM_TRANSLATORS        = "Traducteurs"
L.RUN                   = "Sol"
L.SWIM                  = "Nage"
L.VASH                  = "Vash"
end

-- itIT ------------------------------------------------------------------------

if locale == "itIT" then
L.LM_AUTHOR             = "Autore"
L.LM_DELETE_PROFILE     = "Cancella un Profilo"
L.LM_NEW_PROFILE        = "Crea un profilo"
L.LM_PROFILES           = "Profili"
L.LM_RESET_PROFILE      = "Reimposta Profilo"
end

-- koKR ------------------------------------------------------------------------

if locale == "koKR" then
L.AQ                    = "안퀴"
L.FLY                   = "비행"
L.LM_AUTHOR             = "저자"
L.LM_COMBAT_MACRO_EXP   = "활성화하면 당신이 전투 중일때 LiteMount가 활성화되면 기본 전투 행동 대신 이 매크로가 실행됩니다."
L.LM_DELETE_PROFILE     = "프로필 삭제"
L.LM_MACRO_EXP          = "LiteMount가 사용 가능한 탈것을 찾을 수 없을 때 실행될 매크로입니다. 실내에 있거나 이동 중이면서 즉시 시전 탈것이 없을 때 사용 됩니다."
L.LM_NEW_PROFILE        = "새로운 프로필"
L.LM_NON_FLYING_MOUNT   = "비행 불가 탈것"
L.LM_PROFILES           = "프로필"
L.LM_RESET_PROFILE      = "프로필 초기화"
L.RUN                   = "지상"
L.SWIM                  = "수중"
L.VASH                  = "바쉬르"
end

-- ptBR ------------------------------------------------------------------------

if locale == "ptBR" then
L.LM_AUTHOR             = "Autor"
L.LM_DELETE_PROFILE     = "Remover um Perfil"
L.LM_NEW_PROFILE        = "Cria um perfil"
L.LM_PROFILES           = "Perfis"
L.LM_RESET_PROFILE      = "Resetar Perfil"
end

-- ruRU ------------------------------------------------------------------------

if locale == "ruRU" then
L.AQ                    = "АК"
L.FLOAT                 = "плавучий"
L.FLY                   = "летающий"
L.LM_AUTHOR             = "Aвтор"
L.LM_DELETE_PROFILE     = "Удалить профиль"
L.LM_FLAGS              = "летающий"
L.LM_NEW_PROFILE        = "Новый профиль"
L.LM_PROFILES           = "Профили"
L.LM_RESET_PROFILE      = "Сброс профиль"
L.RUN                   = "беговой"
L.SWIM                  = "плавательный"
L.WALK                  = "ходячий"
end

-- zhCN ------------------------------------------------------------------------

if locale == "zhCN" then
L.AQ                    = "AQ"
L.FLY                   = "飞"
L.LM_AUTHOR             = "作者"
L.LM_COMBAT_MACRO_EXP   = "如启用，LiteMount被激活并且当你在战斗中，该宏会被运行替代默认战斗动作。"
L.LM_DELETE_PROFILE     = "删除一个配置文件"
L.LM_MACRO_EXP          = "如果LiteMount不能找到可用的坐骑会用到此宏，这可能是因为你在室内，或者正在移动中，并且不会任何瞬发坐骑。"
L.LM_NEW_PROFILE        = "新建一个配置文件"
L.LM_NON_FLYING_MOUNT   = "非飞行坐骑"
L.LM_PROFILES           = "配置文件"
L.LM_RESET_PROFILE      = "重置配置文件"
L.RUN                   = "跑"
L.SWIM                  = "游"
L.VASH                  = "海底"
end

-- zhTW ------------------------------------------------------------------------

if locale == "zhTW" then
L.AQ                    = "安其拉"
L.FLY                   = "飛行"
L.LM_AUTHOR             = "作者"
L.LM_COMBAT_MACRO_EXP   = "如果啟用，此巨集將替代預設的戰鬥行動，如果LiteMount是啟用的而且你在戰鬥中。"
L.LM_DELETE_PROFILE     = "刪除一個設定檔"
L.LM_MACRO_EXP          = "此巨集將被運作在如果LiteMount無法找到一個可用的坐騎，這有可能是由於你在室內，或在移動中並且沒有任何可瞬間招換的坐騎。"
L.LM_NEW_PROFILE        = "新建一的設定檔"
L.LM_NON_FLYING_MOUNT   = "非飛行坐騎"
L.LM_PROFILES           = "設定檔"
L.LM_RESET_PROFILE      = "重置設定檔"
L.RUN                   = "陸地"
L.SWIM                  = "水中"
L.VASH                  = "瓦許"
end
