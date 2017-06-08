__precompile__()

module DistributedStatistics

using DistributedArrays
using StatsBase

# Extend support of fit(Histogram, vs)
function StatsBase.append!(h::AbstractHistogram{T,N}, vs::NTuple{N,DistributedArrays.DVector}) where {T,N}
    hs = asyncmap(procs(vs[1])) do p
        remotecall_fetch(p) do
            hl = append!(h, localpart.(vs))
        end
    end
    return merge!(hs...)
end
function append!(h::AbstractHistogram{T,N}, vs::NTuple{N,DistributedArrays.DVector}, wv::DistributedArrays.DVector) where {T,N}
    hs = asyncmap(procs(vs[1])) do p
        remotecall_fetch(p) do
            hl = append!(h, localpart.(vs), wv)
        end
    end
    return merge!(hs...)
end

end