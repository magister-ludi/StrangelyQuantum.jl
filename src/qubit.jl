
"""
    Qubit(α::Real = 0.0)
Create a Qubit with an initial value for α.
The initial state of the qubit is `α|0> + √(1-α²)|1>`.
"""
mutable struct Qubit
    alpha::ComplexF64
    beta::ComplexF64
    theta::Float64
    phi::Float64
    measured::Bool
    measuredValue::Bool
    prob::Float64
    Qubit(ralpha::Real = 0.0) = new(ralpha, sqrt(1 - ralpha * ralpha), 0, 0, false)
end

setProbability(q::Qubit, p) = q.prob = p

"""
Perform a measurement on `q`, returning `0` or `1`.
"""
measure(q::Qubit) = q.measuredValue ? 1 : 0

setMeasuredValue(q::Qubit, v) = q.measuredValue = v

getProbability(q::Qubit) = q.prob
