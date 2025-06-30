import 'package:flutter/material.dart';
import 'package:frontend/home/providers/home_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/service_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchServices().then((
        result,
      ) {
        result.match(
          (err) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err'), backgroundColor: Colors.red),
          ),
          (services) => null,
        );
      });
    });
    _searchController.addListener(() {
      Provider.of<HomeProvider>(
        context,
        listen: false,
      ).setSearchQuery(_searchController.text);
    });
    _locationController.addListener(() {
      Provider.of<HomeProvider>(context, listen: false).notifyListeners();
    });
  }

  Future<void> _refreshServices() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final result = await provider.fetchServices();
    result.match(
      (err) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $err'), backgroundColor: Colors.red),
      ),
      (services) => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Your Service')),
      body: RefreshIndicator(
        onRefresh: _refreshServices,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        // flex: 3,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Services',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Location Dropdown
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Autocomplete<String>(
                            optionsBuilder: (
                              TextEditingValue textEditingValue,
                            ) {
                              if (textEditingValue.text == '') {
                                return Provider.of<HomeProvider>(
                                  context,
                                  listen: false,
                                ).uniqueLocations.toList();
                              }
                              return Provider.of<HomeProvider>(
                                context,
                                listen: false,
                              ).uniqueLocations.where((String option) {
                                return option.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase(),
                                );
                              });
                            },
                            onSelected: (String selection) {
                              Provider.of<HomeProvider>(
                                context,
                                listen: false,
                              ).setSelectedLocation(selection);
                              _locationController.text = selection;
                              FocusScope.of(context).unfocus();
                            },
                            optionsViewBuilder: (
                              BuildContext context,
                              AutocompleteOnSelected<String> onSelected,
                              Iterable<String> options,
                            ) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  child: SizedBox(
                                    height: 200.0,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder: (
                                        BuildContext context,
                                        int index,
                                      ) {
                                        final String option = options.elementAt(
                                          index,
                                        );
                                        return InkWell(
                                          onTap: () {
                                            onSelected(option);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(option),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            fieldViewBuilder: (
                              BuildContext context,
                              TextEditingController fieldTextEditingController,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              // Initialize with current value
                              fieldTextEditingController.text =
                                  _locationController.text;
                              // Sync _locationController to fieldTextEditingController
                              void syncController() {
                                if (fieldTextEditingController.text !=
                                    _locationController.text) {
                                  fieldTextEditingController.text =
                                      _locationController.text;
                                }
                              }

                              _locationController.addListener(syncController);
                              // Clean up listener when field is disposed
                              fieldFocusNode.addListener(() {
                                if (!fieldFocusNode.hasFocus) {
                                  if (_locationController.text.isEmpty) {
                                    Provider.of<HomeProvider>(
                                      context,
                                      listen: false,
                                    ).setSelectedLocation(null);
                                  }
                                }
                              });
                              return TextField(
                                controller: fieldTextEditingController,
                                focusNode: fieldFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'Location',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                onSubmitted: (_) {
                                  onFieldSubmitted();
                                  FocusScope.of(context).unfocus();
                                },
                                onChanged: (value) {
                                  _locationController.removeListener(
                                    syncController,
                                  );
                                  _locationController.text = value;
                                  _locationController.addListener(
                                    syncController,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      _locationController.clear();
                      Provider.of<HomeProvider>(
                        context,
                        listen: false,
                      ).resetFilters();
                    },
                    child: const Text('Clear Filters'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, provider, child) {
                  Widget content;
                  if (provider.errorMessage.isNotEmpty) {
                    content = SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height:
                            MediaQuery.of(context).size.height -
                            200, // Ensure scrollable area
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              provider.errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (provider.isLoading) {
                    content = const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 400, // Ensure scrollable area
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  } else {
                    final filteredServices =
                        provider.services.where((service) {
                          final matchesSearch =
                              provider.searchQuery.isEmpty ||
                              service.name.toLowerCase().contains(
                                provider.searchQuery.toLowerCase(),
                              ) ||
                              service.skill.toLowerCase().contains(
                                provider.searchQuery.toLowerCase(),
                              );
                          final matchesLocation =
                              provider.selectedLocation == null ||
                              service.location == provider.selectedLocation;
                          return matchesSearch && matchesLocation;
                        }).toList();

                    content = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16.0),
                            itemCount: filteredServices.length,
                            itemBuilder: (context, index) {
                              final service = filteredServices[index];
                              return ServiceCard(service: service);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return content;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
