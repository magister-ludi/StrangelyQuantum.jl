
abstract type Gate end

hasOptimization(::Gate) = false

applyOptimize(::Gate, v) = nothing
