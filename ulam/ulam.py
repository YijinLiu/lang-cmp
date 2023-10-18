# w/  numba:  5,996,947,971ns used to find 7,584 Ulam numbers <= 100,000.
# w/o numba: 15,245,441,791ns used to find 7,584 Ulam numbers <= 100,000.
import csv
import time
from typing import Callable

from absl import app
from absl import flags
import numba

FLAGS = flags.FLAGS
flags.DEFINE_integer('limit', 100000, '', lower_bound = 1000)
flags.DEFINE_string('output_csv', 'ulam_100k_py.csv', '')
flags.DEFINE_boolean('debug', False, '')

@numba.njit('boolean(int64, ListType(int64), boolean)', nogil=True)
def is_ulam_number(num: int, ulam_numbers: list[int], debug: bool) -> bool:
    if debug:
        print(f'Checking whether {num} is a Ulam number...')
    i = 0
    j = len(ulam_numbers) - 1
    fnd = False
    while i < j:
        total = ulam_numbers[i] + ulam_numbers[j]
        if total == num:
            if debug:
                print(f'\t{num} = {ulam_numbers[i]} + {ulam_numbers[j]}')
            if fnd:
                return False
            fnd = True
            i += 1
            j -= 1
        elif total < num:
            i += 1
        else:
            j -= 1
    return fnd

def find_ulam_numbers(limit: int, debug: bool) -> (list[int], list[int]):
    ulam_numbers = numba.typed.List()
    ulam_numbers.append(1)
    ulam_numbers.append(2)
    elapsed_ns_list = [0, 0]
    start_ns = time.time_ns()
    for i in range(3, limit+1):
        if is_ulam_number(i, ulam_numbers, debug):
            now_ns = time.time_ns()
            ulam_numbers.append(i)
            elapsed_ns = now_ns - start_ns
            print(f'{elapsed_ns:,} ns used to find Ulam number {i:,}.')
            elapsed_ns_list.append(elapsed_ns)
            start_ns = now_ns
    return ulam_numbers, elapsed_ns_list

def main(argv: list[str]):
    (ulam_numbers, elapsed_ns_list) = find_ulam_numbers(FLAGS.limit, FLAGS.debug)
    elapsed_ns = sum(elapsed_ns_list)
    print(f'{elapsed_ns:,}ns used to find {len(ulam_numbers):,} Ulam numbers <= {FLAGS.limit:,}.')
    with open(FLAGS.output_csv, 'w', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(['ulam_num', 'elapsed_ns'])
        for i in range(len(ulam_numbers)):
            csv_writer.writerow([ulam_numbers[i], elapsed_ns_list[i]])

app.run(main)
