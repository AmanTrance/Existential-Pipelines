{-# LANGUAGE ExistentialQuantification #-}

module Control.Pipeline
    (Pipeline, createPipeline, runPipeline)
where

import GHC.IO ()

data Pipeline i
  = forall o.
    Stage (Maybe (i -> IO ())) (i -> IO o) (Maybe (o -> IO ())) (Maybe (Pipeline o))

createPipeline ::
  forall i o.
  (Maybe (i -> IO ())) -> (i -> IO o) -> (Maybe (o -> IO ())) -> (Maybe (Pipeline o)) -> Pipeline i
createPipeline pre f post s = Stage pre f post s

runPipeline :: i -> Pipeline i -> IO ()
runPipeline a (Stage Nothing f Nothing Nothing) = do
  _ <- f a
  return ()
runPipeline a (Stage (Just pre) f Nothing Nothing) = do
  () <- pre a
  _ <- f a
  return ()
runPipeline a (Stage Nothing f (Just post) Nothing) = do
  o <- f a
  post o
runPipeline a (Stage (Just pre) f (Just post) Nothing) = do
  () <- pre a
  o <- f a
  post o
runPipeline a (Stage Nothing f Nothing (Just s)) = do
  o <- f a
  runPipeline o s
runPipeline a (Stage (Just pre) f Nothing (Just s)) = do
  () <- pre a
  o <- f a
  runPipeline o s
runPipeline a (Stage Nothing f (Just post) (Just s)) = do
  o <- f a
  () <- post o
  runPipeline o s
runPipeline a (Stage (Just pre) f (Just post) (Just s)) = do
  () <- pre a
  o <- f a
  () <- post o
  runPipeline o s