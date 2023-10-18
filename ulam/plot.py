from absl import app
from absl import flags
from matplotlib import pyplot as plt
import pandas as pd

FLAGS = flags.FLAGS
flags.DEFINE_integer('num_samples', 100, '')
flags.DEFINE_string('image_file', 'ulam_100k_py.png', '')

def main(argv):
    fig, ax = plt.subplots(figsize = (32, 18))
    plt.grid()
    for csv_file in argv[1:]:
        label = csv_file.removesuffix('.csv').removeprefix('ulam_')
        print(f'Processing {csv_file} with label {label} ...')
        df = pd.read_csv(csv_file)
        if df.shape[0] > FLAGS.num_samples:
            df = df.sample(n = FLAGS.num_samples)
        plt.scatter(df.ulam_num, df.elapsed_ns, label = label)
    plt.legend()
    plt.savefig(FLAGS.image_file)

app.run(main)
