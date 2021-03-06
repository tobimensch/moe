import unittest
import moepkg/editorstatus, moepkg/gapbuffer, moepkg/unicodeext,
       moepkg/highlight
include moepkg/insertmode

suite "Insert mode":
  test "Issue #474":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru""])

    status.workSpace[0].currentMainWindowNode.highlight = initHighlight(
      $status.bufStatus[0].buffer,
      status.settings.reservedWords,
      status.bufStatus[0].language)

    status.resize(10, 10)

    for i in 0..<100:
      insertCharacter(status.bufStatus[0],
                      status.workSpace[0].currentMainWindowNode,
                      status.settings.autoCloseParen,
                      ru'a')

    status.update

  test "Insert the character which is below the cursor":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"a", ru"b"])

    status.bufStatus[0].insertCharacterBelowCursor(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 2)
    check(buffer[0] == ru"ba")
    check(buffer[1] == ru"b")

  test "Insert the character which is below the cursor 2":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"abc"])

    status.bufStatus[0].insertCharacterBelowCursor(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 1)
    check(buffer[0] == ru"abc")

  test "Insert the character which is below the cursor 3":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"abc", ru"e"])

    status.workspace[0].currentMainWindowNode.currentColumn = 2

    status.bufStatus[0].insertCharacterBelowCursor(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 2)
    check(buffer[0] == ru"abc")
    check(buffer[1] == ru"e")

  test "Insert the character which is above the cursor":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"a", ru"b"])

    status.workspace[0].currentMainWindowNode.currentLine = 1

    status.bufStatus[0].insertCharacterAboveCursor(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 2)
    check(buffer[0] == ru"a")
    check(buffer[1] == ru"ab")

  test "Insert the character which is above the cursor":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"a", ru"bcd"])

    status.workspace[0].currentMainWindowNode.currentLine = 1
    status.workspace[0].currentMainWindowNode.currentColumn = 2

    status.bufStatus[0].insertCharacterAboveCursor(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 2)
    check(buffer[0] == ru"a")
    check(buffer[1] == ru"bcd")

  test "Insert the character which is above the cursor 3":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"a"])

    status.bufStatus[0].insertCharacterAboveCursor(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 1)
    check(buffer[0] == ru"a")

  test "Delete the word before the cursor":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"abc def"])

    status.workspace[0].currentMainWindowNode.currentColumn = 4

    status.bufStatus[0].deleteWordBeforeCursor(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 1)
    check(buffer[0] == ru"def")

  test "Delete the word before the cursor 2":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"abc"])

    status.bufStatus[0].deleteWordBeforeCursor(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 1)
    check(buffer[0] == ru"abc")

  test "Delete the word before the cursor 3":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"abc", ru"def"])

    status.workspace[0].currentMainWindowNode.currentLine = 1

    status.bufStatus[0].deleteWordBeforeCursor(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 1)
    check(buffer[0] == ru"abcdef")

  test "Delete characters before the cursor in current line":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"abcdef"])

    status.workspace[0].currentMainWindowNode.currentColumn = 4

    status.bufStatus[0].deleteCharactersBeforeCursorInCurrentLine(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 1)
    check(buffer[0] == ru"ef")

  test "Delete characters before the cursor in current line 2":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"a"])

    status.bufStatus[0].deleteCharactersBeforeCursorInCurrentLine(
      status.workSpace[0].currentMainWindowNode
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer.len == 1)
    check(buffer[0] == ru"a")

  test "Add indent in current line":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"abc"])

    status.bufStatus[0].addIndentInCurrentLine(
      status.workSpace[0].currentMainWindowNode,
      status.settings.view.tabStop
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer[0] == ru"  abc")

    check(status.workSpace[0].currentMainWindowNode.currentColumn == 2)

  test "Delete indent in current line":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"  abc"])

    status.bufStatus[0].deleteIndentInCurrentLine(
      status.workSpace[0].currentMainWindowNode,
      status.settings.view.tabStop
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer[0] == ru"abc")

    check(status.workSpace[0].currentMainWindowNode.currentColumn == 0)

  test "Delete indent in current line 2":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"abc"])

    status.bufStatus[0].deleteIndentInCurrentLine(
      status.workSpace[0].currentMainWindowNode,
      status.settings.view.tabStop
    )

    let buffer = status.bufStatus[0].buffer
    check(buffer[0] == ru"abc")

    check(status.workSpace[0].currentMainWindowNode.currentColumn == 0)

  test "Move to last of line":
    var status = initEditorStatus()
    status.addNewBuffer("")
    status.bufStatus[0].buffer = initGapBuffer(@[ru"abc"])
    status.bufStatus[0].mode = Mode.insert

    status.bufStatus[0].moveToLastOfLine(status.workspace[0].currentMainWindowNode)

    check status.workspace[0].currentMainWindowNode.currentColumn == 3
