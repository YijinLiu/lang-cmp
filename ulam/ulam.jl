#    263,210,088 ns used to find  7,584 Ulam numbers <=   100,000.
# 23,995,007,599 ns used to find 74,084 Ulam numbers <= 1,000,000.

using ArgParse
using CSV, DataFrames
using Formatting

@inline function is_ulam_number(num::UInt64, ulam_numbers::Vector{UInt64})::Bool
    i = 1
    j = length(ulam_numbers)
    fnd = false
    while i < j
        @inbounds sum = ulam_numbers[i] + ulam_numbers[j]
        if sum == num
            if fnd
                return false
            end
            fnd = true
            i += 1
            j -= 1
        elseif sum < num
            i += 1
        else
            j -= 1
        end
    end
    return fnd
end

function find_ulam_numbers(limit::UInt64)::Tuple{Vector{UInt64}, Vector{UInt64}}
    return ulam_numbers, elapsed_ns_vec
end

function main()
    s = ArgParseSettings()
    @add_arg_table s begin
        "--limit"
            help = "Search Ulam numbers till this number."
            arg_type = UInt64
            default = UInt64(100_000)
        "--output_csv"
            help = "Output CSV file."
            arg_type = String
            default = "ulam_100k_jl.csv"
    end
    args = parse_args(s, as_symbols = true)

    limit = args[:limit]
    output_csv = args[:output_csv]

    ulam_numbers = UInt64[1, 2]
    elapsed_ns_vec = UInt64[0, 0]
    total_elapsed_ns::UInt64 = 0
    start_ns = time_ns()
    for i in 3:limit
        if is_ulam_number(i, ulam_numbers)
            elapsed_ns = time_ns() - start_ns
            printfmt("{} ns used to find Ulam number {}.\n", sprintf1("%'d", elapsed_ns),
                     sprintf1("%'d", i))
            total_elapsed_ns += elapsed_ns
            start_ns = time_ns()
            append!(ulam_numbers, i)
            append!(elapsed_ns_vec, elapsed_ns)
        end
    end
    total_elapsed_ns += time_ns() - start_ns
    printfmt("{} ns used to find {} Ulam numbers <= {}.\n", sprintf1("%'d", total_elapsed_ns),
             sprintf1("%'d", length(ulam_numbers)), sprintf1("%'d", limit))

    df = DataFrame(ulam_num = ulam_numbers, elapsed_ns = elapsed_ns_vec)
    CSV.write(output_csv, df)
end

main()
