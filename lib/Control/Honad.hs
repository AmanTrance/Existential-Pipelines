{-# LANGUAGE GADTs #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE KindSignatures #-}

module Control.Honad (
    Honadic(..),
    Honad(..)
) where

import Data.Kind

data Honadic a = Unit | Value a

class Honad (m :: Type -> Type) where
    
    (~>~) :: (m a) -> (Honadic a -> b) -> b

instance Honad Maybe where

    (~>~) m f = case m of
        Nothing -> f Unit
        Just v  -> f $ Value v

data Recorder b c d where
    Record :: (Honad a, Show b, Show c, Show d) => a b -> a c -> a d -> Recorder b c d

exampleRecorderBinding :: Recorder b c d -> IO ()
exampleRecorderBinding (Record b c d) = 
    b ~>~ (
        \case
            Unit    -> return ()
            Value v -> print v
    ) >>
    c ~>~ (
        \case
            Unit    -> return ()
            Value v -> print v        
    ) >>
    d ~>~ (
        \case
            Unit    -> return ()
            Value v -> print v        
    )