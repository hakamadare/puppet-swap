Puppet::Type.newtype(:swap) do
    ensurable

    newparam(:path) do
        desc "The path to the swap volume or file."
        isnamevar
    end
end
