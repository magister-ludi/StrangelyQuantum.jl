
@enum Axes begin
    XAxis
    YAxis
    ZAxis
end

name(axis::Axes) = replace(string(axis), r"^.*\." => "")

abstract type AbstractRotation <: AbstractSingleQubitGate end

struct Rotation <: AbstractRotation
    idx::Int
    inverse::Bool
    thetav::Float64
    axis::Axes
    matrix::Matrix{ComplexF64}
    function Rotation(theta::Real, axis::Axes, idx)
        gate = new(idx, false, theta, axis, [0 0; 0 0])
        gate.matrix .= constructMatrix(gate, gate.thetav, gate.axis)
        return gate
    end
end

function constructMatrix(::AbstractRotation, theta::Real, axis::Axes)
    s, c = sincos(theta / 2)
    if axis == XAxis
        return [c (-s*im); (-s*im) c]
    elseif axis == YAxis
        return [c -s; s c]
    elseif axis == ZAxis
        return [(c-s * im) 0; 0 (c-s * im)]
    end
end

getMatrix(gate::AbstractRotation) = gate.matrix

function setInverse(gate::AbstractRotation, v)
    _setInverse(gate, v)
    gate.matrix .= gate.matrix'
end

getCaption(gate::AbstractRotation) =
    string("Rotation about ", name(gate.axis), " with angle ", gate.thetav)

struct RotationX <: AbstractRotation
    idx::Int
    inverse::Bool
    thetav::Float64
    axis::Axes
    matrix::Matrix{ComplexF64}
    function RotationX(theta, idx)
        gate = new(idx, false, theta, XAxis, [0 0; 0 0])
        gate.matrix .= constructMatrix(gate, gate.thetav, gate.axis)
        return gate
    end
end

getCaption(gate::RotationX) = string("RotationX ", gate.thetav)

struct RotationY <: AbstractRotation
    idx::Int
    inverse::Bool
    thetav::Float64
    axis::Axes
    matrix::Matrix{ComplexF64}
    function RotationY(theta, idx)
        gate = new(idx, false, theta, YAxis, [0 0; 0 0])
        gate.matrix .= constructMatrix(gate, gate.thetav, gate.axis)
        return gate
    end
end

getCaption(gate::RotationY) = string("RotationY ", gate.thetav)

struct RotationZ <: AbstractRotation
    idx::Int
    inverse::Bool
    thetav::Float64
    axis::Axes
    matrix::Matrix{ComplexF64}
    function RotationZ(theta, idx)
        gate = new(idx, false, theta, ZAxis, [0 0; 0 0])
        gate.matrix .= constructMatrix(gate, gate.thetav, gate.axis)
        return gate
    end
end

getCaption(gate::RotationZ) = string("RotationZ ", gate.thetav)
