
const blockCount = Ref(0)

mutable struct Block
    id::Int
    name::String
    nqubits::Int
    steps::Vector{Step}
    matrix::Union{Nothing, Matrix{ComplexF64}}

    #=
    Create a named block spanning size qubits
    @param name the name of the block
    @param size the number of (adjacent) qubits in this block
     =#
    Block(name::AbstractString, size::Integer) = new((blockCount[] += 1), name, size, [], nothing)
end

Block(size::Integer) = Block("anonymous", size)

function addStep(block::Block, step)
    push!(block.steps, step)
    block.matrix = nothing
end

getSteps(block::Block) = block.steps

getNQubits(block::Block) = block.nqubits

function getMatrix(block::Block)
    if block.matrix === nothing
        block.matrix = Matrix{ComplexF64}(I, 1 << block.nqubits, 1 << block.nqubits)
        simpleSteps = Step[]
        for step in block.steps
            append!(simpleSteps, decomposeStep(step, block.nqubits))
        end
        reverse!(simpleSteps)
        for step in simpleSteps
            gates = getGates(step)
            if block.matrix !== nothing && length(gates) == 1 && gates[1] isa PermutationGate
                block.matrix = permutate(gates[1], block.matrix)
            else
                m = calculateStepMatrix(gates, block.nqubits)
                if block.matrix === nothing
                    block.matrix = m
                else
                    block.matrix *= m
                end
            end
        end
    end
    return block.matrix
end

function applyOptimize(block::Block, probs, inverse)
    simpleSteps = Step[]
    for step in steps
        append!(simpleSteps, decomposeStep(step, block.nqubits))
    end
    if inverse
        reverse!(simpleSteps)
        for step in simpleSteps
            setInverse(step, true)
        end
    end
    for step in simpleSteps
        if !isempty(getGates(step))
            probs = applyStep(block, step, probs)
        end
    end
    if (inverse)
        for step in simpleSteps
            setInverse(step, true)
        end
    end
    return probs
end

function applyStep(block::Block, step, vector)
    gates = getGates(step)
    if !isempty(gates) && gates[1] isa ProbabilitiesGate
        return vector
    end
    if length(gates) == 1 && gates[1] isa PermutationGate
        pg = gates[1]
        return permutateVector(vector, getIndex1(pg), getIndex2(pg))
    end

    result = Vector{ComplexF64}(undef, length(vector))
    result = calculateNewState(gates, vector, block.nqubits)
    return result
end

Base.show(io::IO, block::Block) = print(io, "Block ", block.id, " named ", name)
