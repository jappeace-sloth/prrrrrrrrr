module Main where

import HaskellMobile.App (appContext)
import HaskellMobile.Lifecycle (LifecycleEvent(..), MobileContext(onLifecycle), platformLog)

-- | Desktop entry point: simulates lifecycle and renders UI.
main :: IO ()
main = do
  platformLog "prrrrrrrrr starting..."
  let listen = onLifecycle appContext
  listen Create
  listen Start
  listen Resume
  platformLog "prrrrrrrrr running"
