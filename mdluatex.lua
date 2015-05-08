function direct_md(content)
  tmpname = os.tmpname()
  cmd = 'pandoc -t latex -o'..tmpname
  local p = io.popen(cmd, 'w')
  if p == nil then
    err("\nSomething went wrong when executing\n    "..cmd..".\n"
    .."shell-escape mode may not be activated. Try\n\n%s --shell-escape %s.tex\n\nSee the documentation of gregorio or your TeX\ndistribution to automatize it.", tex.formatname, tex.jobname)
  end
  print(content)
  p:write(content)
  p:close()
  f = io.open(tmpname)
  tex.print(f:read("*a"):explode('\n'))
  f:close()
  os.remove(tmpname)
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
