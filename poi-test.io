# poi-test.io, testing poi

# go into the ./test directory and get all the
# files from it...
files := Directory at("./test") fileNames

files foreach(k, v, writeln("'", v , "'"))

