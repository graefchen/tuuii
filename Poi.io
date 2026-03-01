/*
 *  █▀█ █▀█ █
 *  █▀▀ █▄█ █.io
 *
 * Poi, a minimal markup language.
 * (That tries to be clear and under /200/ 300 lines of code)
 * The parsing strategy of the commonmark implementation
 * was used, in which first the blocks get parsed and then
 * the inline structures.
 *
 * Reference:
 * => (https://spec.commonmark.org/0.31.2/#appendix-a-parsing-strategy)
 *
 */

Node := Object clone do(
  tag      ::= ""
  text     ::= ""
  children ::= List clone
  # parent   ::= nil
  append   := method(T, children append(T))
  # isLeaf   := method(if(children size == 0, true, false))
)

Poi := Object clone do(
  document := Node clone
  footnote := Map clone
  parse := method(source,
    parseBlock(source)
    // parseInline(source)
    return document
  )
  # parsing four blocks: paragraph, heading, blockquote and footnote
  # the blocks are fairly simple and do not look at further than just
  # the first character, to keep it like gemtext simple, but also
  # allow more functional blocks (if i fully understand how to
  # parse multiple blocks in a smart way, then this will be rewritten)
  # when it is not able to parse the line ... it skipps it (for now)
  # => it was the most easy solution, even if the best solution would
  #    be to throw an error, but that is a thing for future me to do
  parseBlock ::= method(source,
    line ::= 0
    # works for now only on windows
    lines ::= source split("\r\n")
    # skip := method(current, chr, expected,
    #   while(chr == expected,
    #     current setText(current text + (lines at(line)))
    #     line = line + 1
    #   )
    # )
    for (_, 0, lines size - 1,
      curl ::= lines at(line)
      chr  ::= curl at(0)
      pos  ::= 0
      if(chr == 35, /* 35 == '#' */
        level ::= 0
        while(curl at(level) == 35, level = level + 1)
        if(level > 6, "Header can not be over 6" println)
        if(curl at(level) == 32/* 32 == ' ' */, pos = level + 1 )
        header := Node clone
        header setTag("h" alignLeft(2,level asString())) /* "clever" hack */
        header setText(curl exSlice(level + 1, curl size))
        document append(header)
      )
      if(chr == 91, /* 91 == '[' */
        start := 1
        while(curl at(pos) != 93,
          if(curl at(pos) == 32,
            "?" println
            break)
          pos = pos + 1
        )
        label := curl exSlice(start, pos)
        pos := pos + 1
        if(curl at(pos) != 58, if(curl at(pos+1) != 32,
          "?" println
          break))
        footnote := footnote atPut(label, curl exSlice(pos+2,curl size))
      )
    )
  )
  // parseInline ::= method(text,
  //   inline println
  // )
  render := method(document,
    document children println
  )
)
