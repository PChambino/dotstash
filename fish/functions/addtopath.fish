function addtopath
  for value in $argv
    contains $value $PATH; or set PATH $value $PATH
  end
end
