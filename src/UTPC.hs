{-# LANGUAGE OverloadedStrings #-}
module UTPC where

import Web.Scotty (scotty)

-- |List of routes for the web application
routes :: ScottyM ()
routes = do
  get "/"       (text "homepage")

main :: IO ()
main = do
  putStrLn "Starting Server"
  scotty 3000 routes
