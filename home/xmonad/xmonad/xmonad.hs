import XMonad
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Actions.TopicSpace
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks



myTopics = ["main", "browser"]
myWorkspaces = myTopics ++ (drop (length myTopics) (map show [1..12]))

myTopicConfig = defaultTopicConfig 
    { defaultTopicAction = const (return ())
    , defaultTopic = "main"
    , topicActions = M.fromList $
        [ ("browser", spawn "google-chrome-unstable")
        ]
    }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)


myKeys = \c -> mkKeymap c $
    [ ("M-" ++ m ++ [k], f i) | 
            (i, k) <- zip myWorkspaces "1234567890-=", 
            (f, m) <- [ (switchTopic myTopicConfig, ""), (windows . W.shift, "S-")]
    ] ++ 
    [ ("M-<Return>", spawn "xterm")
    , ("M-t", withFocused $ windows . W.sink)
    , ("M-c", kill)
    ]


main = do
    xmonad =<< statusBar "xmobar" defaultPP toggleStrutsKey (
            defaultConfig
            { terminal = "xterm"
            , modMask = mod4Mask
            , borderWidth = 2
            , workspaces = myWorkspaces
            , keys = myKeys
            , layoutHook = avoidStruts $ layoutHook defaultConfig
            , manageHook = manageHook defaultConfig <+> manageDocks 
            })
