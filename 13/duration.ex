defmodule Duration do
  import Kernel, except: [+: 2]

# def add({m1,s1},{m2,s2}) do
#   {m1+m2+div((s1+s2),60), rem(s1+s2, 60)}
# end

  defmacro {m1,s1} + {m2,s2} do
    {Kernel.+(Kernel.+(m1,m2),div(Kernel.+(s1,s2),60)), rem(Kernel.+(s1,s2), 60)}
  end

end
