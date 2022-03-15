
function permutate(pg::PermutationGate, matrix::AbstractMatrix{T}) where {T}
    dbg("Not yet tested!")
    a = getIndex1(pg)
    b = getIndex2(pg)
    amask = 1 << (a - 1)
    bmask = 1 << (b - 1)
    dim = size(matrix, 1)
    swapped = Int[]
    for i = 1:dim
        j = i
        x = (amask & (i - 1)) ÷ amask
        y = (bmask & (i - 1)) ÷ bmask
        if x != y
            j = (j - 1) ⊻ amask + 1
            j = (j - 1) ⊻ bmask + 1
            if j ∉ swapped
                push!(swapped, j)
                push!(swapped, i)
                for k = 1:dim
                    matrix[k, i], matrix[k, j] = matrix[k, j], matrix[k, i]
                end
            end
        end
    end
    return matrix
end

function permutate(matrix::AbstractMatrix{T}, pg::PermutationGate) where {T}
    a = getIndex1(pg)
    b = getIndex2(pg)
    amask = 1 << (a - 1)
    bmask = 1 << (b - 1)
    dim = size(matrix, 1)
    swapped = Int[]
    for i = 1:dim
        j = i
        x = (amask & (i - 1)) ÷ amask
        y = (bmask & (i - 1)) ÷ bmask
        if x != y
            j ⊻= amask
            j ⊻= bmask
            if j ∉ swapped
                push!(swapped, j)
                push!(swapped, i)
                rowa = @view matrix[i, :]
                matrix[i, :] .= @view matrix[j, :]
                matrix[j, :] .= rowa
            end
        end
    end
    return matrix
end
