// 406518412 ns used to find 7584 Ulam numbers.

#include <inttypes.h>

#include <chrono>
#include <fstream>
#include <iostream>
#include <numeric>
#include <vector>

#include <gflags/gflags.h>

DEFINE_int64(limit, 100000ll, "");
DEFINE_string(output_csv, "ulam_100k_cc.csv", "");

namespace {

bool is_ulam_number(int64_t num, const std::vector<int64_t>& ulam_numbers) {
    int i = 0, j = ulam_numbers.size() - 1;
    bool fnd = false;
    while (i < j) {
        const int64_t sum = ulam_numbers[i] + ulam_numbers[j];
        if (sum == num) {
            if (fnd) return false;
            fnd = true;
            i++;
            j--;
        } else if (sum < num) {
            i++;
        } else {
            j--;
        }
    }
    return fnd;
}

}  // namespace


int main(int argc, char* argv[]) {
    gflags::ParseCommandLineFlags(&argc, &argv, true);

    std::vector<int64_t> ulam_numbers;
    std::vector<int64_t> elapsed_ns_list;
    ulam_numbers.push_back(1);
    ulam_numbers.push_back(2);
    elapsed_ns_list.push_back(0);
    elapsed_ns_list.push_back(0);
    auto start = std::chrono::high_resolution_clock::now();
    int64_t total_elapsed_ns = 0;
    for (int i = 3; i <= FLAGS_limit; i++) {
        if (is_ulam_number(i, ulam_numbers)) {
            const std::chrono::duration<double> elapsed =
                std::chrono::high_resolution_clock::now() - start;
            const int64_t elapsed_ns =
                std::chrono::duration_cast<std::chrono::nanoseconds>(elapsed).count();
            std::cout << elapsed_ns << " ns used to find Ulam number " << i << std::endl;
            total_elapsed_ns += elapsed_ns;
            start = std::chrono::high_resolution_clock::now();
            ulam_numbers.push_back(i);
            elapsed_ns_list.push_back(elapsed_ns);
        }
    }
    const std::chrono::duration<double> elapsed =
        std::chrono::high_resolution_clock::now() - start;
    total_elapsed_ns +=
        std::chrono::duration_cast<std::chrono::nanoseconds>(elapsed).count();
    std::cout << total_elapsed_ns << " ns used to find " << ulam_numbers.size() << " Ulam numbers.\n";

    std::ofstream csv_file;
    csv_file.open(FLAGS_output_csv);
    csv_file << "ulam_num,elapsed_ns\n";
    for (int i = 0; i < ulam_numbers.size(); i++) {
        csv_file << ulam_numbers[i] << "," << elapsed_ns_list[i] << std::endl;
    }
    csv_file.close();
}
