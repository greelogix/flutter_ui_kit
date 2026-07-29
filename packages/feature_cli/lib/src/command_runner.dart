import 'package:args/command_runner.dart';

import 'commands/add_command.dart';
import 'commands/analyze_command.dart';
import 'commands/create_command.dart';
import 'commands/doctor_command.dart';
import 'commands/docs_command.dart';
import 'commands/generate_command.dart';
import 'commands/init_command.dart';
import '../services/feature_kit_services.dart';
import 'console/logger.dart';

class FeatureCommandRunner extends CommandRunner<int> {
  FeatureCommandRunner({FeatureKitServices? services})
      : _services = services ?? FeatureKitServices(),
        super(
          'feature',
          'Flutter Feature Kit — scaffold features for any architecture.',
        ) {
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Show additional logging.',
      negatable: false,
    );

    addCommand(InitCommand(services: _services));
    addCommand(CreateCommand(services: _services));
    addCommand(AddCommand(services: _services));
    addCommand(GenerateCommand(services: _services));
    addCommand(AnalyzeCommand(services: _services));
    addCommand(DoctorCommand(services: _services));
    addCommand(DocsCommand(services: _services));
  }

  final FeatureKitServices _services;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      return await super.run(args) ?? 0;
    } on UsageException catch (e) {
      Logger.error(e.message);
      if (e.message.isNotEmpty) {
        Logger.hint(e.usage);
      }
      return 64;
    } catch (e) {
      Logger.error('$e');
      return 1;
    }
  }
}
