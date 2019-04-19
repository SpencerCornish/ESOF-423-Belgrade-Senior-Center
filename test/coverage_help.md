# Collection of deep coverage elements

1. `dart --observe generated_runner.dart`
2. `collect_coverage [observatory_url] cov.json`
3. `format_coverage -i cov.json -l -o cov.lcov`
4. `genhtml cov.lcov`