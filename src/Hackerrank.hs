{-# LANGUAGE OverloadedStrings #-}
module Hackerrank where

import Control.Lens

import Data.Map as Map
import Data.Aeson
import Data.Aeson.Lens (key)

import Network.Wreq

type Resp = Response (Map String Value)

languagesUrl = "http://api.hackerrank.com/checker/languages.json"

languages :: IO (Maybe Value)
languages = do
  r <- asValue =<< get languagesUrl
  return (r ^? responseBody . key "languages")

