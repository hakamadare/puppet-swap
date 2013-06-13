Puppet::Type.type(:swap).provide :linux do
    desc "Manages swap on Linux systems"

    confine :kernel => 'Linux'
    defaultfor :kernel => 'Linux'

    commands :mkswap => '/sbin/mkswap'
    commands :swapon => '/sbin/swapon'
    commands :swapoff => '/sbin/swapoff'
    commands :swaplist => '/sbin/swapon -s'

    def create
        begin
            mkswap(@resource[:path])
        rescue Puppet::ExecutionFailure
            raise Puppet::ParseError("Unable to initialize swap on '#{@resource[:path]}'.")
        end
        begin
            swapon(@resource[:path])
        rescue Puppet::ExecutionFailure
            raise Puppet::ParseError("Unable to enable swap on '#{@resource[:path]}'.")
        end
    end

    def exists?
        swaps.include?(@resource[:path])
    end

    def destroy
        begin
            swapoff(@resource[:path])
        rescue Puppet::ExecutionFailure
            raise Puppet::ParseError("Unable to disable swap on '#{@resource[:path]}'.")
        end
    end

    def swaps
        raw = Array.new()
        cooked = Array.new()
        begin
            raw = Array(swaplist).split(/\n/)
        rescue Puppet::ExecutionFailure
            nil
        end
        # the first line is the header
        raw.shift
        raw.each do |line|
            path = String(line).split(' ', 2).shift
            cooked.push(path)
        end

        cooked
    end
end
