Puppet::Type.type(:swap).provide :linux do
    desc "Manages swap on Linux systems"

    confine :kernel => 'Linux'

    commands :mkswap => '/sbin/mkswap'
    commands :swapon => '/sbin/swapon'
    commands :swapoff => '/sbin/swapoff'
    commands :swaplist => '/sbin/swapon -s'

    def swaps
        raw = Array(swaplist).split(/\n/)
        # the first line is the header
        raw.shift
        cooked = Array()
        raw.each do |line|
            path = String(line).split(' ', 2).shift
            cooked.push(path)
        end

        cooked
    end
end
