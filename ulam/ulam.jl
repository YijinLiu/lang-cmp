# 340,722,486 ns used to find 7,584 Ulam numbers <= 100,000.

using ArgParse
using CSV, DataFrames
using Formatting: sprintf1

function is_ulam_number(num::UInt64, ulam_numbers::Vector{UInt64}, debug::Bool)::Bool
    if debug
        println("Checking whether $num is a Ulam number...")
    end
    i = 1
    j = length(ulam_numbers)
    fnd = false
    while i < j
        sum = ulam_numbers[i] + ulam_numbers[j]
        if sum == num
            if debug
                println("$num = $(ulam_numbers[i]) + $(ulam_numbers[j])")
            end
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

function find_ulam_numbers(limit::UInt64, debug::Bool)::Tuple{Vector{UInt64}, Vector{UInt64}}
    ulam_numbers = UInt64[1, 2]
    elapsed_ns_vec = UInt64[0, 0]
    start_ns = time_ns()
    for i in 3:limit
        if is_ulam_number(i, ulam_numbers, debug)
            now_ns = time_ns()
            append!(ulam_numbers, i)
            elapsed_ns = now_ns - start_ns
            println("$elapsed_ns ns used to find Ulam number $i.")
            append!(elapsed_ns_vec, elapsed_ns)
            start_ns = now_ns
        end
    end
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
        "--debug"
            help = "Print debug information."
            action = :store_true
    end
    args = parse_args(s, as_symbols = true)

    limit = args[:limit]
    output_csv = args[:output_csv]
    debug = args[:debug]

    ulam_numbers, elapsed_ns_vec = find_ulam_numbers(limit, debug)
    elapsed_ns = sum(elapsed_ns_vec)
    println("$(sprintf1("%'d", elapsed_ns)) ns used to find \
$(sprintf1("%'d", length(ulam_numbers))) Ulam numbers <= $(sprintf1("%'d", limit)).")

    df = DataFrame(ulam_num = ulam_numbers, elapsed_ns = elapsed_ns_vec)
    CSV.write(output_csv, df)
end

main()
