{-# LANGUAGE OverloadedStrings #-}
module UTPC where

import Control.Monad.IO.Class

import Network.HTTP.Types.Status
import Network.Wai.Middleware.RequestLogger
import Hackerrank
import Web.Scotty

-- |Take in a post request and either throw an error or redirect to the submissions page
submit :: ActionM ()
submit = do
  flist <- files
  case flist of
    x:[] -> redirect "submit"
    _    -> status status400

languages :: ActionM ()
languages = do
    r <- liftIO Hackerrank.languages
    json r

-- |List of routes for the web application
routes :: ScottyM ()
routes = do
  get  "/"          (text "homepage")
  get  "/languages" UTPC.languages
  get  "/submit"    (text "submitted")
  post "/submit"    submit

main :: IO ()
main = do
  putStrLn "Starting Server"
  scotty 3000 $ middleware logStdoutDev >> routes
