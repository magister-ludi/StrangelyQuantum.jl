
mutable struct R <: AbstractSingleQubitGate
    idx::Int
    inverse::Bool
    expv::Float64
    pow::Int
    matrix::Matrix{ComplexF64}
    function R(exp, idx)
        s, c = sincos(exp)
        return new(idx, false, exp, -1, [1 0; 0 Complex(c, s)])
    end
end

function R(base, pow, idx)
    gate = R(2π / (base^pow), idx)
    gate.pow = pow
    return gate
end

getMatrix(gate::R) = gate.matrix

function setInverse(gate::R, v)
    _setInverse(gate, v)
    matrix .= gate.matrix'
end

getCaption(gate::R) = string("R", gate.pow > -1 ? gate.pow : "th")
