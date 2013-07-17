Facter.add("var_tmp_rw") do
  setcode do
    File.stat("/var/tmp").writable?
  end
end
