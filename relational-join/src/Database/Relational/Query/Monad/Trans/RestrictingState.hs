-- |
-- Module      : Database.Relational.Query.Monad.Trans.RestrictingState
-- Copyright   : 2013 Kei Hibino
-- License     : BSD3
--
-- Maintainer  : ex8k.hibino@gmail.com
-- Stability   : experimental
-- Portability : unknown
--
-- This module provides context definition for
-- "Database.Relational.Query.Monad.Trans.Restricting".
module Database.Relational.Query.Monad.Trans.RestrictingState (
  -- * Context of restriction
  RestrictContext,

  primeRestrictContext,

  addRestriction,

  composeWheres
  ) where

import Database.Relational.Query.Context (Flat)
import Database.Relational.Query.Expr (Expr, fromJust, exprAnd)
import Database.Relational.Query.Expr.Unsafe (showExpr)

import Language.SQL.Keyword (Keyword(..), unwordsSQL)
import qualified Language.SQL.Keyword as SQL


-- | Context type for Restrict.
data RestrictContext =
  RestrictContext
  { restriction :: Maybe (Expr Flat Bool) }

-- | Initial 'RestrictContext'.
primeRestrictContext :: RestrictContext
primeRestrictContext =  RestrictContext Nothing

-- | Add restriction of 'RestrictContext'.
addRestriction :: Expr Flat (Maybe Bool) -> RestrictContext -> RestrictContext
addRestriction e1 ctx =
  ctx { restriction = Just . uf . restriction $ ctx }
  where uf  Nothing  = fromJust e1
        uf (Just e0) = e0 `exprAnd` fromJust e1

-- | Compose SQL String from 'RestrictContext' object.
composeWheres' :: Maybe (Expr Flat Bool) -> String
composeWheres' =  maybe [] (\e -> unwordsSQL [WHERE, SQL.word . showExpr $ e])

-- | Compose SQL String from 'RestrictContext' object.
composeWheres :: RestrictContext -> String
composeWheres = composeWheres' . restriction
