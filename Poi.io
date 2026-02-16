/*
 *  █▀█ █▀█ █
 *  █▀▀ █▄█ █
 *
 * Poi, a minimal markup language.
 * (That tries to be clear and under 200 lines of code)
 * The parsing strategy of the commonmark implementation
 * was used, in which first the blocks get parsed and then
 * the inline structures.
 *
 */

Node := clone Object do (
  text     := nil
  children := List clone
  parent   := ""
  append   := method(T, children append(T))
  isLeaf   := method(if(children size == 0, true, false))
)

Poi := clone Object do (
  document := Node clone
  parse    := method(source,
    source print
  )
  parseBlock ::= method(source,
    source println
  )
  parseInline ::= method(text,
    inline println
  )
)
