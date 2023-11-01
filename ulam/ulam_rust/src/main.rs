//    413,386,971 ns used to find  7,584 Ulam numbers <=   100,000
// 38,506,263,116 ns used to find 74,084 Ulam numbers <= 1,000,000

use std::fs::File;
use std::io::Write;
use std::time::Instant;

use clap::Parser;

fn is_ulam_number(num: u64, ulam_numbers: &[u64]) -> bool {
    let mut i = 0;
    let mut j = ulam_numbers.len() - 1;
    let mut fnd = false;
    while i < j {
        let sum = ulam_numbers[i] + ulam_numbers[j];
        if sum == num {
            if fnd {
                return false;
            }
            fnd = true;
            i += 1;
            j -= 1;
        } else if sum < num {
            i += 1;
        } else {
            j -= 1;
        }
    }
    return fnd;
}

#[derive(Parser)]
struct Args {
    #[arg(short, long, default_value_t=100000)]
    limit: u64,
    #[arg(short, long, default_value="ulam_100k_rs.csv")]
    output_csv: String,
}

fn main() {
    let args = Args::parse();

    let mut ulam_numbers = vec![1_u64, 2_u64];
    let mut elapsed_ns_vec = vec![0_u64, 0_u64];
    let mut total_elapsed_ns = 0_u64;
    let mut start = Instant::now();
    for i in 3_u64..=args.limit {
        if is_ulam_number(i, &ulam_numbers) {
            let elapsed_ns = start.elapsed().as_nanos() as u64;
            println!("{} ns used to find Ulam number {}.", elapsed_ns, i);
            total_elapsed_ns += elapsed_ns;
            start = Instant::now();
            ulam_numbers.push(i);
            elapsed_ns_vec.push(elapsed_ns);
        }
    }
    total_elapsed_ns += start.elapsed().as_nanos() as u64;
    println!("{} ns used to find {} Ulam numbers <= {}.", total_elapsed_ns, ulam_numbers.len(),
             args.limit);

    let mut csv_file = File::create(args.output_csv).unwrap();
    writeln!(&mut csv_file, "ulam_num,elapsed_ns").unwrap();
    for (i, n) in ulam_numbers.iter().enumerate() {
        writeln!(&mut csv_file, "{},{}", n, elapsed_ns_vec[i]).unwrap();
    }
}
