// 791,186,553 ns used to find 7,584 Ulam numbers <= 100,000.

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;

public class UlamNumbers {
    private ArrayList<Long> list;

    private UlamNumbers() {
        list = new ArrayList<Long>(Arrays.asList(1l, 2l));
    }

    private boolean check(long num) {
        var result = false;
        int i = 0, j = list.size() - 1;
        while (i < j) {
            final long total = list.get(i) + list.get(j);
            if (total == num) {
                if (result) return false;
                result = true;
                i++;
                j--;
            } else if (total < num) {
                i++;
            } else {
                j--;
            }
        }
        return result;
    }

    public static List<Long> findAll(long limit, List<Long> elapsedNsList) {
        var ulamNums = new UlamNumbers();
        elapsedNsList.add(0l);
        elapsedNsList.add(0l);
        long totalElapsedNs = 0;
        long startNs = System.nanoTime();
        for (long i = 3l; i <= limit; i++) {
            if (ulamNums.check(i)) {
                final long elapsedNs = System.nanoTime() - startNs;
                System.out.printf("%d ns used to find Ulam number %d.\n", elapsedNs, i);
                totalElapsedNs += elapsedNs;
                startNs = System.nanoTime();
                ulamNums.list.add(i);
                elapsedNsList.add(elapsedNs);
            }
        }
        return Collections.unmodifiableList(ulamNums.list);
    }

    public static void main(String[] args) {
        Options options = new Options();
        options.addOption("l", "limit", true, "");
        options.addOption("o", "output_csv", true, "");
        long limit = 100000;
        String outputCsv = "ulam_100k_java.csv";
        try {
            CommandLineParser parser = new DefaultParser();
            var cmd = parser.parse(options, args);
            if (cmd.hasOption("limit")) {
                limit = Long.parseLong(cmd.getOptionValue("limit"));
            }
            if (cmd.hasOption("output_csv")) {
                outputCsv = cmd.getOptionValue("output_csv");
            }
        } catch (ParseException e) {
            System.out.println(e.getMessage());
            HelpFormatter helper = new HelpFormatter();
            helper.printHelp("Usage:", options);
            System.exit(0);
        }

        HelpFormatter helper = new HelpFormatter();
        List<Long> elapsedNsList = new ArrayList<Long>();
        List<Long> ulamNums = UlamNumbers.findAll(limit, elapsedNsList);
        final long elapsed_ns = elapsedNsList.stream().reduce(0l, Long::sum);
        final var nf = NumberFormat.getIntegerInstance();
        System.out.printf(
            "%s ns used to find %s Ulam numbers <= %s.\n", nf.format(elapsed_ns),
            nf.format(ulamNums.size()), nf.format(limit));

        File csvOutputFile = new File(outputCsv);
        try (PrintWriter pw = new PrintWriter(csvOutputFile)) {
            pw.println("ulam_num,elapsed_ns");
            for (int i = 0; i < ulamNums.size(); i++) {
                pw.printf("%d,%d\n", ulamNums.get(i), elapsedNsList.get(i));
            }
        } catch (FileNotFoundException e) {
            System.err.println(e);
        }
    }
}
