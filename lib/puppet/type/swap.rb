Puppet::Type.newtype(:swap) do
    require 'pathname'
    ensurable

    newparam(:path) do
        desc "The path to the swap volume or file."
        isnamevar

        validate do |value|
            p = Pathname.new(value)
            if ! p.absolute?
                raise Puppet::ParseError("'#{value}' is not an absolute path.")
            end
            if ! p.exists?
                raise Puppet::ParseError("'#{value}' must be created first.")
            end
        end
    end
end
