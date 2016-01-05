{-# LANGUAGE OverloadedStrings #-}
module UTPC (runApp, app) where

import Control.Monad.IO.Class (liftIO)
import Data.Text.Lazy.Encoding (decodeUtf8)

import Network.HTTP.Types.Status (status400)
import Network.Wai (Application)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Network.Wai.Middleware.Static
import Network.Wai.Parse (fileContent)
import Web.Scotty

import Hackerrank

-- |Take in a post request and either throw an error or redirect to the submissions page
submit :: ActionM ()
submit = do
  flist <- files
  case flist of
    x:[] -> text . decodeUtf8 . fileContent . snd $ x
    _    -> status status400

languages :: ActionM ()
languages = do
    r <- liftIO Hackerrank.languages
    json r

-- |List of routes for the web application
routes :: ScottyM ()
routes = do
  get  "/"          $ file "./static/index.html"
  get  "/languages"   UTPC.languages
  get  "/submit"      (text "submitted")
  post "/submit"      submit

app' :: ScottyM ()
app' = do
  middleware logStdoutDev
  middleware $ staticPolicy (noDots >-> addBase "static")
  routes

app :: IO Application
app = scottyApp app'

runApp :: IO ()
runApp = do
  putStrLn "Starting Server"
  scotty 3000 app'
