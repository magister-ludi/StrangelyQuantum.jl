
"""
    Program(n, steps...)
Create a Quantum Program with `n` qubits, and optional `steps`.
By default, all qubits are initialized to the |0> state.
"""
mutable struct Program <: AbstractProgram
    numberQubits::Int
    initAlpha::Vector{Float64}
    steps::Vector{Step}
    # cache decomposedSteps
    decomposedSteps::Union{Nothing, Vector{Step}}
    result::Result

    function Program(nQubits, steps...)
        p = new(nQubits, ones(nQubits), [], nothing)
        addSteps(p, steps...)
        return p
    end
end

"""
Initialize qubit at `idx`. The qubit will be in a state
`ψ = α|0> + β|1>`.
Since `α² + β²` should equal 1, only
`α` is required.
"""
function initializeQubit(p::Program, idx, alpha)
    if idx > p.numberQubits
        error("Can not initialize qubit $idx since we have only $(p.numberQubits) qubits.")
    end
    p.initAlpha[idx] = alpha
end

getInitialAlphas(p::Program) = p.initAlpha

"""
    addStep(p::Program, step::Step)
Add a step with one or more gates to the existing program.
In case the Step contains an operation that would put a measured qubit into
a potential superposition again, an exception is thrown.
"""
function addStep(p::Program, step::Step)
    if !ensureMeasuresafe(p, step)
        error("Adding a superposition step to a measured qubit")
    end
    push!(p.steps, step)
    setIndex(step, length(p.steps))
    setProgram(step, p)
    p.decomposedSteps = nothing
end

#=
Adds multiple steps with one or more gates to the existing program.
In case the Step contains an operation that would put a measured qubit into a potential superposition
again, an IllegalArgumentException is thrown.
@param moreSteps steps to be added to the program
=#
function addSteps(p::Program, steps...)
    for step in steps
        addStep(p, step)
    end
end

function ensureMeasuresafe(p::Program, step::Step)
    # determine which qubits might get superpositioned
    mainQubits = Int[]
    for g in getGates(step)
        if g isa Hadamard
            push!(mainQubits, getMainQubitIndex(g))
        elseif g isa Cnot
            push!(mainQubits, getSecondQubitIndex(g))
        end
    end
    for s in getSteps(p)
        for g in getGates(s)
            if g isa Measurement && getMainQubitIndex(g) ∈ mainQubits
                return false
            end
        end
        #=
        match = any(getGates(step)) do g
            if g isa Measurement && getMainQubitIndex(g) ∈ mainQubits
                @show getMainQubitIndex(g)
                true
            else
                false
            end
        end
        match && return false
        =#
    end
    return true
end

getSteps(p::Program) = p.steps

getDecomposedSteps(p::Program) = p.decomposedSteps

setDecomposedSteps(p::Program, ds) = p.decomposedSteps = ds

getNumberQubits(p::Program) = p.numberQubits

setResult(p::Program, r) = p.result = r

getResult(p::Program) = p.result

printInfo(p::Program) = printInfo(stdout, p)

function printInfo(io::IO, p::Program)
    println(io, "Info about Quantum Program")
    println(io, "==========================")
    println(io, "Number of qubits = ", p.numberQubits, ", number of steps = ", length(steps))
    for step in steps
        println(io, "Step: " + getGates(step))
    end
    println(io, "==========================")
end
