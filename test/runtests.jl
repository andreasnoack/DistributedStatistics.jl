addprocs(2)

using Base.Test
using DistributedStatistics, DistributedArrays, StatsBase

@testset "Histograms" begin
    n = 1000
    x = randn(n)
    w = rand(n)
    xd = distribute(x)
    wd = distribute(w)
    @test fit(Histogram, x, closed=:right) == fit(Histogram, xd, closed=:right)
    @test fit(Histogram, x, weights(w), closed=:right).weights ≈ fit(Histogram, xd, weights(wd), closed=:right).weights
end