{-# LANGUAGE TemplateHaskell, MultiParamTypeClasses, FlexibleInstances #-}

module History where

import Prelude hiding (seq, log)
import PgTestDataSource (defineTable)

$(defineTable []
  "EXAMPLE3" "history" [''Show])
