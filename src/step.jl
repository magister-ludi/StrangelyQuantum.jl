
"""
The type of a step. Typically, a step contains instructions that alter
the quantum circuit. Those are steps with type `NormalStep`.

Some steps do not alter the quantum circuit at all and can be ignored in
computations. Those are steps with type `PseudoStep` and they
are typically used for visualization.
"""
@enum StepType begin
    NormalStep
    PseudoStep
    ProbabilityStep
end

"""
A single step in a quantum `Program`. In a `Step`, a number
of `Gate`s can be added, involving a number of qubits. However, in a single
step a qubit can be involved in at most one `Gate`. It is illegal
to declare 2 gates in a single step that operate on the same qubit.
"""
mutable struct Step{P <: AbstractProgram}
    name::String
    stype::StepType
    # if a complex step needs to broken into
    # simple steps, only one simple step can have this value
    # to be the index of the complex step
    complexStep::Int
    informal::Bool
    gates::Vector{Gate}
    index::Int
    program::P
    function Step(name::AbstractString, stype::StepType, gates...)
        step = new{Program}(name, stype, -1, false, [])
        addGates(step, gates...)
        return step
    end
end

Step(gates...) = Step("unknown", gates...)

Step(name::AbstractString, gates...) = Step(name, NormalStep, gates...)

Step(stype::StepType) = Step("pseudo", stype)

getType(step::Step) = step.stype

getName(step::Step) = step.name

"""
Add gate to the list of gates for this step
"""
function addGate(step::Step, gate::Gate)
    verifyUnique(step, gate)
    push!(step.gates, gate)
end

"""
Add multiple Gates to the list of gates for this step
"""
function addGates(step::Step, gates...)
    for g in gates
        addGate(step, g)
    end
end

getGates(step::Step) = step.gates

removeGate(step::Step, g::Gate) = delete!(step.gates, g)

setComplexStep(step::Step, idx) = step.complexStep = idx

getComplexStep(step::Step) = step.complexStep

setInformalStep(step::Step, b) = step.informal = b

isInformal(step::Step) = step.informal

function setIndex(step::Step, s)
    step.index = s
    step.complexStep = s
end

getIndex(step::Step) = step.index

setProgram(step::Step, p) = step.program = p

getProgram(step::Step) = step.program

function setInverse(step::Step, val)
    for g in step.gates
        if g isa AbstractBlockGate
            inverse(g)
        else
            setInverse(g, val)
        end
    end
end

function verifyUnique(step::Step, gate::Gate)
    gbits = getAffectedQubitIndexes(gate)
    for g in step.gates
        if any(in(gbits), getAffectedQubitIndexes(g))
            #long overlap = g.getAffectedQubitIndexes().stream().filter(gate.getAffectedQubitIndexes() ::contains).count()
            #if (overlap > 0)
            error("Adding gate that affects a qubit already involved in step")
        end
    end
end

function Base.show(io::IO, step::Step)
    if getType(step) == PseudoStep
        print(io, "Pseudo-step")
    else
        print(io, "Step \"", step.name, "\" with gates [", join(step.gates, ", "), "]")
    end
end
