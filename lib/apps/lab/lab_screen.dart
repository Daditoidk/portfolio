import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/models/experiment.dart';
import 'core/repositories/experiment_repository.dart';
import 'widgets/experiment_card.dart';
import 'widgets/custom_toast.dart';
import '../../../core/navigation/route_names.dart';

class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> {
  final ExperimentRepository _repository = ExperimentRepository();
  List<Experiment> _experiments = [];
  // String _searchQuery = ''; // TODO: Implement search functionality
  List<ExperimentType> _selectedTypes = [];
  List<ExperimentStatus> _selectedStatuses = [];

  @override
  void initState() {
    super.initState();
    _loadExperiments();
  }

  void _loadExperiments() {
    setState(() {
      _experiments = _repository.getAllExperiments();
    });
  }

  void _filterExperiments() {
    setState(() {
      _experiments = _repository.filterExperiments(
        types: _selectedTypes.isEmpty ? null : _selectedTypes,
        statuses: _selectedStatuses.isEmpty ? null : _selectedStatuses,
      );
    });
  }

  void _searchExperiments(String query) {
    setState(() {
      // _searchQuery = query; // TODO: Implement search functionality
      if (query.isEmpty) {
        _experiments = _repository.getAllExperiments();
      } else {
        _experiments = _repository.searchExperiments(query);
      }
    });
  }

  void _onExperimentTap(Experiment experiment) {
    switch (experiment.id) {
      case 'text_order_visualizer':
        context.go(RouteNames.textOrderVisualizer);
        break;
      case 'animation_editor':
        context.go(RouteNames.animationEditor);
        break;
      case 'diy_inbox_cleaner':
        context.go(RouteNames.diyInboxCleaner);
        break;
      default:
        CustomToast.showError(
          context,
          message: '${experiment.title} - Feature not implemented yet',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(child: _buildHeaderSection()),

          // Experiments Grid Section
          SliverToBoxAdapter(child: _buildExperimentsSection()),
        ],
      ),
    );
  }

  /// Build the header section with the lab title and description
  Widget _buildHeaderSection() {
    return Container(
      height: MediaQuery.of(context).size.height, // Increased height
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bgs/lab_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Gradient overlay for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the experiments section with grid and filters
  Widget _buildExperimentsSection() {
    final statistics = _repository.getStatistics();

    return Container(
      padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Experiments & Tools',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${statistics['total']} experiments available',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              // Statistics badges
              Row(
                children: [
                  _buildStatBadge(
                    'Active',
                    statistics['byStatus'][ExperimentStatus.active] ?? 0,
                    Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _buildStatBadge(
                    'Beta',
                    statistics['byStatus'][ExperimentStatus.beta] ?? 0,
                    Colors.orange,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Search and Filters
          _buildSearchAndFilters(),

          const SizedBox(height: 32),

          // Experiments Grid
          _buildExperimentsGrid(),
        ],
      ),
    );
  }

  /// Build search and filter controls
  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        // Search
        Expanded(
          child: TextField(
            onChanged: _searchExperiments,
            decoration: InputDecoration(
              hintText: 'Search experiments...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Type Filter
        DropdownButton<ExperimentType>(
          value: _selectedTypes.isEmpty ? null : _selectedTypes.first,
          hint: const Text('Type'),
          items: [
            const DropdownMenuItem(value: null, child: Text('All Types')),
            ...ExperimentType.values.map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(type.name.toUpperCase()),
              ),
            ),
          ],
          onChanged: (type) {
            setState(() {
              if (type == null) {
                _selectedTypes.clear();
              } else {
                _selectedTypes = [type];
              }
              _filterExperiments();
            });
          },
        ),

        const SizedBox(width: 16),

        // Status Filter
        DropdownButton<ExperimentStatus>(
          value: _selectedStatuses.isEmpty ? null : _selectedStatuses.first,
          hint: const Text('Status'),
          items: [
            const DropdownMenuItem(value: null, child: Text('All Statuses')),
            ...ExperimentStatus.values.map(
              (status) => DropdownMenuItem(
                value: status,
                child: Text(status.name.toUpperCase()),
              ),
            ),
          ],
          onChanged: (status) {
            setState(() {
              if (status == null) {
                _selectedStatuses.clear();
              } else {
                _selectedStatuses = [status];
              }
              _filterExperiments();
            });
          },
        ),
      ],
    );
  }

  /// Build the experiments grid
  Widget _buildExperimentsGrid() {
    if (_experiments.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No experiments found',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75, // Adjust based on card height
      ),
      itemCount: _experiments.length,
      itemBuilder: (context, index) {
        final experiment = _experiments[index];
        return ExperimentCard(
          experiment: experiment,
          onTap: () => _onExperimentTap(experiment),
        );
      },
    );
  }

  /// Build a statistics badge
  Widget _buildStatBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
