module MixedModelsDatasets

using Arrow
using Artifacts
using LazyArtifacts

export dataset, datasets

_testdata() = artifact"TestData"
cacheddatasets = Dict{String,Arrow.Table}()

"""
    dataset(nm)

Return, as an `Arrow.Table`, the test data set named `nm`, which can be a `String` or `Symbol`

!!! note "Case insensitive"
    Dataset names are case insensitive: internally all names are normalized to lowercase.
"""
function dataset(nm::AbstractString)
    get!(cacheddatasets, nm) do
        path = joinpath(_testdata(), lowercase(nm) * ".arrow")
        if !isfile(path)
            throw(ArgumentError("Dataset \"$nm\" is not available.\nUse MixedModels.datasets() for available names."))
        end
        return Arrow.Table(path)
    end
end
dataset(nm::Symbol) = dataset(string(nm))

"""
    datasets()

Return a vector of names of the available test data sets
"""
function datasets()
    return first.(Base.Filesystem.splitext.(filter(endswith(".arrow"),
                                                   readdir(_testdata()))))
end

end # module MixedModelsDatasets
