import           Control.Monad.Catch (bracket)
import           Control.Monad.Trans (liftIO)
import           RSCoin.Core         (initLogging, readSecretKey)
import qualified RSCoin.Mintette     as M
import           RSCoin.Timed        (fork_, runRealMode)

import qualified Options             as Opts

main :: IO ()
main = do
    Opts.Options{..} <- Opts.getOptions
    initLogging cloLogSeverity
    sk <- readSecretKey cloSecretKeyPath
    runRealMode $
        bracket (liftIO $ M.openMemState) (liftIO . M.closeState) $
            \st -> do
                fork_ $ M.runWorker sk st
                M.serve cloPort st sk
