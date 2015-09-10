local md5 = require 'md5'

PANDOC = 'pandoc'
TMP = 'tmp_md'
N = 0

function direct_md(md, title, author, day, abstract)
  md = md:gsub('\\par ', '\n\n')
  metadata = meta_md(md)
  resultat = {}
  table.insert(resultat, '\\setchapterpreamble{%\n')
  if author~='false' and metadata.author then
    print('\n\n'..author..'\n\n')
    table.insert(
      resultat, '\\chapauthor{'..metadata['title']..'}\n'
    )
  end
  if day~='false' and metadata.date then
    table.insert(
      resultat, '\\chapdate{'..metadata['title']..'}\n'
    )
  end
  if abstract~='false' and metadata.abstract then
    table.insert(
      resultat, '\\chapabstract{'..metadata['title']..'}\n'
    )
  end
  table.insert(resultat, '}')
  if title~='false' and metadata.title then
    table.insert(resultat, '\\chapter{'..metadata['title']..'}\n')
  end
  tmpname = os.tmpname()
  compiler_md(md, tmpname)
  tmp = io.open(tmpname)
  for _, ligne in pairs(tmp:read("*a"):explode('\n')) do
    table.insert(resultat, ligne)
  end
  tmp:close()
  tex.print(resultat)
  os.remove(tmpname)
end


function inclure_md(entree, title, author, day, abstract)
    nom = splitext(entree, 'md')
    entree = nom..'.md'
    if not lfs.isfile(entree) then entree = kpse.find_file(entree) end
    if not lfs.isfile(entree) then err("Le fichier %s.md n'existe pas.", nom) end
    local i = io.open(entree, 'r')
    md = i:read('*a')
    i:close()
    direct_md(md, title, author, day, abstract)
end


function compiler_md(md, sortie)
    mkdirs(dirname(sortie))
    local commande = PANDOC.." "..
        "-t latex "..
        "-o "..sortie
    local p = io.popen(commande, 'w')
    if p == nil then
      err("\nSomething went wrong when executing\n    "..cmd..".\n"
      .."shell-escape mode may not be activated. Try\n\n%s --shell-escape %s.tex\n\nSee the documentation of gregorio or your TeX\ndistribution to automatize it.", tex.formatname, tex.jobname)
    end
    p:write(md)
    p:close()
end


function meta_md(md)
    tmpname = os.tmpname()
    local f = io.open(tmpname, 'w')
    f:write(md)
    f:close()
    local commande = PANDOC.." "..
        "-t entetes.lua "..tmpname
    local p = io.popen(commande, 'r')
    if p == nil then
      err("\nSomething went wrong when executing\n    "..cmd..".\n"
      .."shell-escape mode may not be activated. Try\n\n%s --shell-escape %s.tex\n\nSee the documentation of gregorio or your TeX\ndistribution to automatize it.", tex.formatname, tex.jobname)
    end
    sortie = p:read('*a')
    p:close()
    return meta(sortie)
end


function meta(metadata)
  resultat = {}
  for _, line in pairs(metadata:explode('\n')) do
    data = line:explode('|')
    resultat[data[1]] = data[2]
  end
  return resultat
end


function err(...)
    print(...)
end


do

  local mybuf = ''
  end_verb = ''

  function readbuf( buf )
      if buf:match(end_verb) then
          return buf
      end
      mybuf = mybuf .. buf .. "\n"
      return ""
  end

  function startrecording(env)
    end_verb = '%s*\\end{'..env..'}'
    luatexbase.add_to_callback('process_input_buffer', readbuf, 'readbuf')
  end

  function stoprecording()
    luatexbase.remove_from_callback('process_input_buffer', 'readbuf')
    local buf_without_end = mybuf:gsub(end_verb,"")
    return buf_without_end
  end
end


function dirname(str)
    if str:match(".-/.-") then
        local name = string.gsub(str, "(.*/)(.*)", "%1")
        return name
    else
        return ''
    end
end


function splitext(str, ext)
    if str:match(".-%..-") then
        local name = string.gsub(str, "(.*)(%." .. ext .. ")", "%1")
        return name
    else
        return str
    end
end


function mkdirs(str)
    path = '.'
    for dir in string.gmatch(str, '([^%/]+)') do
        path = path .. '/' .. dir
        lfs.mkdir(path)
    end
end
