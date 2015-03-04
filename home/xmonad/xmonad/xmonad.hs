import XMonad
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Actions.TopicSpace
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Actions.SpawnOn
import XMonad.Prompt
import XMonad.Actions.Navigation2D
import XMonad.Util.NamedScratchpad
import XMonad.Layout.Grid
import Data.Time


-- myLayout = Tall ||| Full ||| Mirror Tall;



myTopics = ["main", "browser"]
myWorkspaces = myTopics ++ (drop (length myTopics) (map show [1..10]))

myTopicConfig = defaultTopicConfig 
    { defaultTopicAction = const (return ())
    , defaultTopic = "main"
    , topicActions = M.fromList $
        [ ("browser", spawnHere "google-chrome-unstable")
        ]
    }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

scratchpads = 
    [ NS "zeal" "zeal" (title =? "Zeal") defaultFloating 
    , NS "sage" "xterm -T sc-sage sage" (title =? "sc-sage") defaultFloating
    , NS "ipython2" "xterm -T sc-ipython2 ipython2" (title =? "sc-ipython2") defaultFloating
    , NS "ydcv" "xterm -T sc-ydcv ydcv" (title =? "sc-ydcv") defaultFloating
    , NS "xterm" "xterm -T sc-xterm sh" (title =? "sc-xterm") defaultFloating
    ]


myKeys = \c -> mkKeymap c $
    [ ("M-" ++ m ++ [k], f i) | 
            (i, k) <- zip myWorkspaces "1234567890", 
            (f, m) <- [ (switchTopic myTopicConfig, ""), (windows . W.shift, "S-")]
    ] ++ 
    [ ("M-<Return>", spawnHere $ XMonad.terminal c)
    , ("M-r", shellPromptHere defaultXPConfig)
    , ("M-t", withFocused $ windows . W.sink)
    , ("M-q", kill)
    , ("M-h", windowGo L False)
    , ("M-j", windowGo D False)
    , ("M-k", windowGo U False)
    , ("M-l", windowGo R False)
    , ("M-m", windows W.swapMaster)
    , ("<XF86AudioRaiseVolume>", spawn "ponymix increase 2")
    , ("<XF86AudioLowerVolume>", spawn "ponymix decrease 2")
    , ("<XF86AudioMute>", spawn "ponymix toggle")
    , ("M-; z", namedScratchpadAction scratchpads "zeal")
    , ("M-; s", namedScratchpadAction scratchpads "sage")
    , ("M-; d", namedScratchpadAction scratchpads "ydcv")
    , ("M-; x", namedScratchpadAction scratchpads "xterm")
    , ("M-; p", namedScratchpadAction scratchpads "ipython2")
    , ("M-<Space>", sendMessage NextLayout)
    , ("<Print>", spawnHere "sleep 0.1; scrot -s -e 'mkdir -p /tmp/scrot/; mv $f /tmp/scrot/'")
    , ("S-<Print>", spawnHere "scrot -e 'mkdir -p /tmp/scrot/; mv $f /tmp/scrot/'")
    , ("M--", sendMessage Shrink)
    , ("M-=", sendMessage Expand)
    ]

myManageHook = composeAll $ [manageDocks, namedScratchpadManageHook scratchpads]

main = do
    xmonad =<< statusBar "xmobar" defaultPP toggleStrutsKey (
            defaultConfig
            { terminal = "xterm"
            , modMask = mod4Mask
            , borderWidth = 2
            , workspaces = myWorkspaces
            , keys = myKeys
            , layoutHook = avoidStruts $ layoutHook defaultConfig
            , manageHook = myManageHook
            })
