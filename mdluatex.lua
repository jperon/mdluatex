local md5 = require 'md5'

PANDOC = 'pandoc'
TMP = 'tmp_md'
N = 0

function direct_md(content)
  content = content:gsub('\\par ', '\n')
  tmpname = os.tmpname()
  compiler_md(content, tmpname)
  f = io.open(tmpname)
  tex.print(f:read("*a"):explode('\n'))
  f:close()
  os.remove(tmpname)
end


function inclure_md(entree)
    nom = splitext(entree, 'md')
    entree = nom..'.md'
    if not lfs.isfile(entree) then entree = kpse.find_file(entree) end
    if not lfs.isfile(entree) then err("Le fichier %s.md n'existe pas.", nom) end
    local i = io.open(entree, 'r')
    md = i:read('*a')
    i:close()
    local sortie = TMP..'/' ..string.gsub(md5.sumhexa(md), '%.', '-')..'.tex'
    if not lfs.isfile(sortie..'.tex') then
        compiler_md(md, sortie)
    end
    local i = io.open(sortie, 'r')
    contenu = i:read("*a")
    i:close()
    tex.print(contenu:explode('\n'))
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
