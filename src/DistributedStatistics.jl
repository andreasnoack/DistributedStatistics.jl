__precompile__()

module DistributedStatistics

using Reexport
@reexport using DistributedArrays, StatsBase

# Extend support of fit(Histogram, vs)
function StatsBase.append!(h::AbstractHistogram{T,N}, vs::NTuple{N,DistributedArrays.DVector}) where {T,N}
    hs = asyncmap(procs(vs[1])) do p
        remotecall_fetch(p) do
            hl = append!(h, localpart.(vs))
        end
    end
    return merge!(hs...)
end
function StatsBase.append!(h::AbstractHistogram{T,N}, vs::NTuple{N,DistributedArrays.DVector}, wv::DistributedArrays.DVector) where {T,N}
    hs = asyncmap(procs(vs[1])) do p
        remotecall_fetch(p) do
            hl = append!(h, localpart.(vs), localpart(wv))
        end
    end
    return merge!(hs...)
end

end