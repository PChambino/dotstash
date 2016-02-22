function pushto --description 'Move values to head of variable' --argument var
  set -e argv[1]
  for value in $argv
    if eval 'contains $value $'$var
      eval 'set -e '$var'[(contains -i $value $'$var')]'
    end
    eval 'set '$var $value '$'$var
  end
end
