import Control.Monad
import Control.Monad.IO.Class
import Data.IORef
import Graphics.UI.Gtk
import Graphics.UI.Gtk.Layout.Table
import Graphics.UI.Gtk.Buttons.Button
import Graphics.UI.Gtk.Cairo

main :: IO ()
main = do
    void initGUI
    window <- windowNew
    set window [ windowTitle         := "unfixed calculator"
               ,containerBorderWidth := 20
               , windowDefaultWidth  :=330
               , windowDefaultHeight :=350 ]
    
    display <- entryNew
    set display [ entryEditable :=False
                , entryXalign   := 0
                , entryText     := " "]
                
    zero    <-  buttonNewWithLabel  "0"
    one     <-  buttonNewWithLabel  "1"
    two     <-  buttonNewWithLabel  "2"
    three   <-  buttonNewWithLabel  "3"
    four    <-  buttonNewWithLabel  "4"
    five    <-  buttonNewWithLabel  "5"
    six     <-  buttonNewWithLabel  "6"
    seven   <-  buttonNewWithLabel  "7"
    eight   <-  buttonNewWithLabel  "8"
    nine    <-  buttonNewWithLabel  "9"
    sum     <-  buttonNewWithLabel  "+"
    min     <-  buttonNewWithLabel  "_"
    div     <-  buttonNewWithLabel  "/"
    mul     <-  buttonNewWithLabel  "x"
    eq      <-  buttonNewWithLabel  "="
    clear   <-  buttonNewWithLabel  "c"
    
    table <- tableNew 4 4 True
    tableSetHomogeneous table True
    tableAttachDefaults table display   0 4 0 1
    tableAttachDefaults table one       0 1 1 2
    onClicked one (area display "1")
    tableAttachDefaults table two       1 2 1 2
    onClicked two (area display "2")
    tableAttachDefaults table three     2 3 1 2
    onClicked three (area display "3")
    tableAttachDefaults table sum       3 4 1 2
    onClicked sum (area display "+")
    tableAttachDefaults table four      0 1 2 3
    onClicked four (area display "4")
    tableAttachDefaults table five      1 2 2 3
    onClicked five (area display "5")
    tableAttachDefaults table six       2 3 2 3
    onClicked six (area display "6")
    tableAttachDefaults table min       3 4 2 3
    onClicked min (area display "-")
    tableAttachDefaults table seven     0 1 3 4
    onClicked seven (area display "7")
    tableAttachDefaults table eight     1 2 3 4
    onClicked eight (area display "8")
    tableAttachDefaults table nine      2 3 3 4
    onClicked nine (area display "9")
    tableAttachDefaults table mul       3 4 3 4
    onClicked mul (area display "x")
    tableAttachDefaults table zero      0 1 4 5
    onClicked zero (area display "0")
    tableAttachDefaults table div       1 2 4 5
    onClicked div (area display "/")
    tableAttachDefaults table eq        2 3 4 5
    onClicked eq (area display "=")
    tableAttachDefaults table clear     3 4 4 5
    onClicked clear (area display "c")
    containerAdd window table
    widgetShowAll table
    window `on` deleteEvent $ do -- handler to run on window destruction
        liftIO mainQuit
        return False
    widgetShowAll window
    mainGUI




  
area :: Entry -> String -> IO ()
area display label = do
  a <- (entryGetText display)
  let l = ""
  let b = getInt a
  let lab = a ++ label
  if label == "c"
  then set display [entryText := " " ]
  else if label == "+" || label =="/" || label =="x" ||label =="-"
  then do
    let b = getInt a
    let l= label
    set display [entryText := " " ]
  else if label == "="
  then do
    let c = getInt a
    let m = result b l c
    let value = getStr m
    set display [entryText := value]
  else set display [entryText := lab]
  

getInt :: String -> Integer
getInt x = read x :: Integer

result :: Integer -> String -> Integer -> Integer
result b l c =
 if  l == "x"
 then c*b
 else if l == "-"
 then c-b
 else if l == "/"
 then  c `div` b
 else c+b
 

getStr :: Integer -> String
getStr x = show x
